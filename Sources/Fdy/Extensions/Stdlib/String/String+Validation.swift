import Foundation

// MARK: - 通用格式验证
public extension String {
    /// 是否为有效中国手机号(11 位,1[3-9] 开头)
    /// - Returns: 是否满足条件
    var fdy_isValidPhoneNumber: Bool {
        fdy_isMatch(pattern: "^1[3-9]\\d{9}$")
    }

    /// 是否为有效邮箱(宽松版)
    /// - Returns: 是否满足条件
    var fdy_isValidEmail: Bool {
        fdy_isMatch(pattern: #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#)
    }

    /// 是否为有效 URL(任意协议)
    ///
    /// - Returns: 是否满足条件
    /// - Note: 只判 `URL(string:) != nil` 判不出任何东西 —— 实测 `"hello world"` / `"not a url"` /
    ///   `"://x"` 都能构造出 `URL` 对象。这里额外要求**有 scheme**,才真正筛掉普通文本。
    var fdy_isValidURL: Bool {
        URL(string: self)?.scheme != nil
    }

    /// 是否为带协议的 URL(如 http://, https://)
    /// - Returns: 是否满足条件
    var fdy_isValidSchemedURL: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// 是否为 HTTPS URL
    /// - Returns: 是否满足条件
    var fdy_isValidHttpsURL: Bool {
        URL(string: self)?.scheme == "https"
    }

    /// 是否为 HTTP URL
    /// - Returns: 是否满足条件
    var fdy_isValidHttpURL: Bool {
        URL(string: self)?.scheme == "http"
    }

    /// 是否为文件 URL
    /// - Returns: 是否满足条件
    var fdy_isValidFileURL: Bool {
        URL(string: self)?.isFileURL == true
    }
}

// MARK: - 自定义规则
public extension String {
    /// 是否符合字母数字+下划线,长度在 [min, max]
    /// - Parameters:
    ///   - minLen: 最小长度
    ///   - maxLen: 最大长度
    /// - Returns: 是否满足条件
    func fdy_isValidAlphanumeric(minLen: Int, maxLen: Int) -> Bool {
        guard self.count >= minLen, self.count <= maxLen else { return false }
        return self.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
    }

    /// 是否为有效昵称(中英文、数字、下划线)
    ///
    /// - Returns: 是否满足条件
    /// - Note: 旧实现写的是正则 `^[\u{4e00}-\u{9fff}a-zA-Z0-9_]+$`。`#"..."#` 是**原始字符串**,
    ///   `\u{4e00}` 不会被 Swift 转义成汉字,而是原样交给 ICU —— 而 ICU **不认带花括号的 `\u{...}`**,
    ///   正则编译失败,`fdy_isMatch` 随即走「无效正则视为不匹配」的兜底 → **该方法恒返回 `false`**。
    ///   实测:`"ab-c"` / `"张三"`,连纯 ASCII 的 `"a_b"` 都是 `false`。现改用 `allSatisfy`,不再依赖正则。
    var fdy_isValidNickname: Bool {
        !self.isEmpty && self.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
    }

    /// 是否为有效用户名(中英文,1-20 字符)
    ///
    /// - Returns: 是否满足条件
    /// - Note: 旧实现是 `$0.isLetter || (首个 Unicode 标量 >= 0x4E00)`。后半段**既多余又有害**:
    ///   汉字本就 `isLetter == true`（多余）,而「首标量 ≥ 0x4E00」把 emoji(`U+1F600`)、日文、
    ///   韩文及大量符号区一并放行（实测 `"🎉"` / `"Привет"` / `"あ"` 全部返回 `true`）。
    var fdy_isValidUsername: Bool {
        guard self.count >= 1, self.count <= 20 else { return false }
        return self.allSatisfy(\.isLetter)
    }

    /// 是否为有效密码
    /// - Parameter complex: 是否使用复杂形式,默认为 `false`
    /// - Returns: 是否满足条件
    /// - `complex = false`: 至少包含字母+数字,≥6 位
    /// - `complex = true`: 必须包含大小写字母+数字+特殊符号,≥8 位
    func fdy_isValidPassword(complex: Bool = false) -> Bool {
        if complex {
            return fdy_isMatch(pattern: #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{}|;:'",.<>/?]).{8,}$"#)
        } else {
            return self.count >= 6 && self.fdy_hasLetters && self.fdy_hasDigits
        }
    }
}

// MARK: - 数字格式
public extension String {
    /// 是否为整数(支持负号)
    /// - Returns: 是否满足条件
    var fdy_isInteger: Bool {
        let scanner = Scanner(string: self)
        return scanner.scanInt() != nil && scanner.isAtEnd
    }

    /// 是否为浮点数(支持科学计数法)
    /// - Returns: 是否满足条件
    var fdy_isFloat: Bool {
        let scanner = Scanner(string: self)
        return scanner.scanFloat() != nil && scanner.isAtEnd
    }
}

// MARK: - 身份证(简化版)
public extension String {
    /// 是否符合身份证基本格式(15/18 位)
    /// - Returns: 是否满足条件
    var fdy_isBasicIDNumber: Bool {
        fdy_isMatch(pattern: #"^(\d{15}|\d{17}[\dXx])$"#)
    }

    /// 是否为严格有效的 18 位身份证(含校验码)
    /// - Returns: 是否满足条件
    var fdy_isStrictIDNumber: Bool {
        guard self.count == 18, fdy_isBasicIDNumber else { return false }

        let weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        let checkCodes = "10X98765432"

        var sum = 0
        for i in 0 ..< 17 {
            guard let digit = Int(self.fdy_Character(at: i)) else { return false }
            sum += digit * weights[i]
        }

        let expected = String(checkCodes[checkCodes.index(checkCodes.startIndex, offsetBy: sum % 11)])
        let actual = String(self[self.index(self.startIndex, offsetBy: 17)])
        return expected.uppercased() == actual.uppercased()
    }
}

// MARK: - 子串匹配
public extension String {
    /// 是否包含子串(可选大小写敏感)
    /// - Parameters:
    ///   - substring: 子串
    ///   - caseSensitive: 是否区分大小写,默认为 `true`
    /// - Returns: 是否满足条件
    func fdy_contains(_ substring: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return contains(substring)
        }
        return self.localizedCaseInsensitiveContains(substring)
    }

    /// 是否以某前缀开头(可选大小写敏感)
    /// - Parameters:
    ///   - prefix: 前缀
    ///   - caseSensitive: 是否区分大小写,默认为 `true`
    /// - Returns: 是否满足条件
    func fdy_starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return self.hasPrefix(prefix)
        }
        return self.lowercased().hasPrefix(prefix.lowercased())
    }

    /// 是否以某后缀结尾(可选大小写敏感)
    /// - Parameters:
    ///   - suffix: 后缀
    ///   - caseSensitive: 是否区分大小写,默认为 `true`
    /// - Returns: 是否满足条件
    func fdy_ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return self.hasSuffix(suffix)
        }
        return self.lowercased().hasSuffix(suffix.lowercased())
    }
}
