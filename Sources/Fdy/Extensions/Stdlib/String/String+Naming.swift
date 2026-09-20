import Foundation

// MARK: - 命名与格式转换
public extension String {
    /// 转换为驼峰命名法(首单词小写,其余首字母大写)
    /// - Returns: 处理后的字符串
    /// - 返回值: 驼峰格式字符串
    var fdy_camelCase: String {
        let words = self.fdy_words
        guard !words.isEmpty else { return "" }
        let first = words[0].lowercased()
        let rest = words.dropFirst().map(\.capitalized).joined()
        return first + rest
    }

    /// 转换为蛇形命名法（全小写、下划线分隔，非字母数字一律视作分隔符并压缩为单个下划线）
    ///
    /// 与 ``fdy_camelCase`` 互为反向。
    ///
    /// - Returns: 处理后的字符串
    /// - Note: 连续大写的缩写会被整体识别为一个词（`"myURLSession"` → `"my_url_session"`，
    ///   而不是 `"my_u_r_l_session"`）—— 判据是「大写字母后面紧跟小写字母」时在此处断词。
    var fdy_snakeCase: String {
        let chars = Array(self)
        guard !chars.isEmpty else { return "" }

        var result = ""
        for (index, char) in chars.enumerated() {
            if char.isUppercase {
                let previousIsLowerOrDigit = index > 0 && (chars[index - 1].isLowercase || chars[index - 1].isNumber)
                let nextIsLowercase = index + 1 < chars.count && chars[index + 1].isLowercase
                // 词内大写（前面是小写/数字）或缩写末尾（后面接小写）时断词
                if previousIsLowerOrDigit || (nextIsLowercase && index > 0) {
                    result.append("_")
                }
                result.append(contentsOf: char.lowercased())
            } else if char.isLetter || char.isNumber {
                result.append(char)
            } else if !result.isEmpty, result.last != "_" {
                // 非字母数字统一作分隔符，并压缩连续分隔符
                result.append("_")
            }
        }

        while result.last == "_" {
            result.removeLast()
        }
        return result
    }

    /// 将汉字转为拼音(可选择是否保留声调)
    /// - Parameter withTone: 是否带语调,默认为 `false`
    /// - Returns: 处理后的字符串
    /// - 参数 withTone: 是否保留声调符号,默认 `false`
    /// - 返回值: 拼音字符串(空格分隔);若无可转换字符,返回原串
    func fdy_pinyin(withTone: Bool = false) -> String {
        let mutable = NSMutableString(string: self) as CFMutableString
        // 转为拉丁字母(带声调)
        CFStringTransform(mutable, nil, kCFStringTransformMandarinLatin, false)
        // 去声调
        if !withTone {
            CFStringTransform(mutable, nil, kCFStringTransformStripDiacritics, false)
        }
        return mutable as String
    }

    /// 提取每个汉字的拼音首字母
    /// - Parameter uppercase: 是否转为大写,默认为 `true`
    /// - Returns: 处理后的字符串
    /// - 参数 uppercase: 是否转为大写,默认 `true`
    /// - 返回值: 首字母字符串;非汉字部分会被忽略
    func fdy_pinyinInitials(uppercase: Bool = true) -> String {
        let pinyin = self.fdy_pinyin(withTone: false)
        let initials = pinyin
            .components(separatedBy: .whitespaces)
            .compactMap { word in
                word.first.flatMap { String($0).uppercased().first }
            }
        let result = String(initials)
        return uppercase ? result : result.lowercased()
    }

    /// 返回本地化字符串(调用 `NSLocalizedString`)
    /// - Parameter comment: 注释文本,默认为 `""`
    /// - Returns: 处理后的字符串
    /// - 参数 comment: 供翻译人员参考的注释
    /// - 返回值: 本地化后的字符串
    func fdy_localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }

    /// 转换为 URL 友好的 slug 格式(小写、短横线分隔)
    /// - Returns: 处理后的字符串
    /// - 返回值: 清理后的 slug 字符串
    func fdy_slug() -> String {
        // 转小写并去除重音
        let normalized = self.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale.current)
        // 替换空白符为短横线
        let dashed = normalized.replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
        // 仅保留字母、数字、短横线
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))
        let filtered = dashed.filter { String($0).rangeOfCharacter(from: allowed) != nil }
        // 去除首尾短横线,并压缩连续短横线
        return filtered
            .trimmingCharacters(in: .init(charactersIn: "-"))
            .replacingOccurrences(of: "-+", with: "-", options: .regularExpression)
    }
}

// MARK: - 空白符处理
public extension String {
    /// 移除首尾的空白符和换行符
    /// - Returns: 处理后的字符串
    func fdy_trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 仅移除首尾空白符(不含换行)
    /// - Returns: 处理后的字符串
    func fdy_trimWhitespaces() -> String {
        self.trimmingCharacters(in: .whitespaces)
    }

    /// 仅移除首尾换行符
    /// - Returns: 处理后的字符串
    func fdy_trimNewlines() -> String {
        self.trimmingCharacters(in: .newlines)
    }

    /// 移除所有空白字符（**含全角空格 U+3000、制表符**等，不限 ASCII 空格）
    ///
    /// - Returns: 处理后的字符串
    /// - Note: 旧实现是 `replacingOccurrences(of: " ", with: "")`，只删 ASCII 空格。
    ///   实测 `"a\u{3000}b"`（全角空格）删完仍剩 3 个字符，与「移除所有空格」的承诺不符。
    func fdy_removeSpaces() -> String {
        self.components(separatedBy: .whitespaces).joined()
    }

    /// 移除所有换行字符（`\n`、`\r`、`\r\n`、U+2028、U+2029 全覆盖）
    ///
    /// - Returns: 处理后的字符串
    /// - Note: 旧实现是 `replacingOccurrences(of: "\n", with: "")`，只删 `\n`。
    ///   实测 `"a\r\nb"` 的 Unicode 标量为 `[97, 13, 98]` —— **`\r` 被留下来了**，
    ///   即 Windows 换行只删了一半，与「移除所有换行符」的承诺不符。
    func fdy_removeNewlines() -> String {
        self.components(separatedBy: .newlines).joined()
    }

    /// 移除所有空白符和换行符
    /// - Returns: 处理后的字符串
    func fdy_removeAllWhitespace() -> String {
        self.components(separatedBy: .whitespacesAndNewlines).joined()
    }
}
