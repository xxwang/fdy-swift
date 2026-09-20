import Foundation

// MARK: - 命名空间入口
extension Character: FdyExtension {}

// MARK: - 构造方法
public extension Character {
    /// 使用 `ASCII` 码值`(0–127)`创建一个 `Character`
    ///
    /// - Parameter ascii: 有效的 `ASCII` 码值(`UInt8`)
    init?(fdy_ascii ascii: UInt8) {
        guard ascii <= 127 else { return nil }
        self = Character(UnicodeScalar(ascii))
    }

    /// 使用一个或多个 `Unicode` 码点(十六进制字符串)创建 `Character`
    ///
    /// 支持格式：
    /// - Parameter unicodeScalars: 一个或多个十六进制字符串表示的码点
    /// - `"1F60A"`, `"U+1F60A"`, `"0x1F60A"`, `"\\u{1F60A}"`
    /// - 多个码点用于组合字符(如国旗、家庭 Emoji)
    init?(fdy_unicodeScalars unicodeScalars: String...) {
        guard !unicodeScalars.isEmpty else { return nil }

        let cleanedCodes: [UInt32] = unicodeScalars.compactMap { str in
            var hex = str.trimmingCharacters(in: .whitespacesAndNewlines)

            // 移除常见前缀
            if hex.hasPrefix("U+") || hex.hasPrefix("u+") {
                hex = String(hex.dropFirst(2))
            } else if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
                hex = String(hex.dropFirst(2))
            } else if hex.hasPrefix("\\u{"), hex.hasSuffix("}") {
                let startIndex = hex.index(hex.startIndex, offsetBy: 3)
                let endIndex = hex.index(hex.endIndex, offsetBy: -1)
                hex = String(hex[startIndex ..< endIndex])
            }

            guard !hex.isEmpty, let code = UInt32(hex, radix: 16) else {
                return nil
            }
            return code
        }

        // 必须全部成功解析
        guard cleanedCodes.count == unicodeScalars.count else { return nil }

        // 转换所有码点为 UnicodeScalar
        let scalars = cleanedCodes.compactMap(UnicodeScalar.init)

        // 如果数量不一致,说明有无效码点
        guard scalars.count == cleanedCodes.count else {
            return nil
        }

        // 构造 String
        let scalarView = String.UnicodeScalarView(scalars)
        let string = String(scalarView)

        // 验证是否构成单个 Character(grapheme cluster)
        guard string.count == 1, let char = string.first else {
            return nil
        }

        self = char
    }
}

// MARK: - 类型转换
public extension Character {
    /// 返回当前字符的大写形式
    /// - Returns: 字符
    func fdy_uppercase() -> Character {
        return self.uppercased().first ?? self
    }

    /// 返回当前字符的小写形式
    /// - Returns: 字符
    func fdy_lowercase() -> Character {
        return self.lowercased().first ?? self
    }

    /// 尝试将当前字符转换为其对应的 ASCII 码值(`UInt8`)
    /// - Returns: 字节值,不可用时返回 `nil`
    func fdy_ASCII() -> UInt8? {
        guard let scalar = self.unicodeScalars.first, scalar.isASCII else { return nil }
        return UInt8(scalar.value)
    }

    /// 返回当前字符的 `Swift` 风格 `Unicode` 转义序列(如 `\u{1F60A}`)
    /// - Returns: 处理后的字符串
    func fdy_unicodeEscapeSequence() -> String {
        return self.unicodeScalars.map { "\\u{\(String($0.value, radix: 16, uppercase: true))}" }.joined()
    }
}

// MARK: - 内容判断
public extension Character {
    /// 判断当前字符是否为 `Emoji`(包括`简单Emoji `和`组合 Emoji`)
    ///
    /// - Returns: 是否满足条件
    /// - Note: 单标量分支**不能只看 `properties.isEmoji`** —— 该属性对 `0`–`9`、`#`、`*`
    ///   同样返回 `true`（它们可以是 keycap emoji 的基字符）。实测 `Character("1")` / `("7")` /
    ///   `("#")` / `("*")` 均被误判为 emoji，并连带让 `String.fdy_containsEmoji` /
    ///   `fdy_containsOnlyEmoji` / `fdy_emojiString` 一起失真（`"123"` 会被当成「纯 emoji」）。
    ///   故这里额外要求码点 **> 0x7F**，把 ASCII 全部排除。
    var fdy_isEmoji: Bool {
        let scalars = self.unicodeScalars

        // 单标量：检查 isEmoji，但先排除 ASCII（数字/`#`/`*` 的 isEmoji 也是 true）
        if let first = scalars.first, scalars.count == 1 {
            guard first.value > 0x7F else { return false }
            return first.properties.isEmoji
        }

        // 多标量：必须以 Emoji 标量开头,并包含 VS-16、ZWJ 或区域指示符
        guard let first = scalars.first, first.properties.isEmoji else {
            return false
        }

        // 检查后续标量是否为有效 Emoji 组成部分
        return scalars.dropFirst().contains { scalar in
            let props = scalar.properties
            if props.isVariationSelector || props.isJoinControl {
                return true
            }
            // 区域指示符范围: U+1F1E6 to U+1F1FF
            let value = scalar.value
            return (0x1F1E6 ... 0x1F1FF).contains(value)
        }
    }
}

// MARK: - 字符生成
public extension Character {
    /// 生成一个随机 `ASCII` 字符
    ///
    /// - Parameter includeSpecialChars: 是否包含特殊符号(默认 `false`)
    /// - Returns: 一个随机 `Character`
    static func fdy_random(includeSpecialChars: Bool = false) -> Character {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let digits = "0123456789"
        let special = includeSpecialChars ? "!@#$%^&*()-_=+[]{}|;:'\",.<>?/" : ""
        let pool = letters + digits + special
        guard let randomChar = pool.randomElement() else {
            // `pool` 由三个常量字面量拼接而成,恒非空;此处仅为理论兜底
            preconditionFailure("Character.random() pool is unexpectedly empty")
        }
        return randomChar
    }
}
