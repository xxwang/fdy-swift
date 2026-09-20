import Foundation
import UIKit

// MARK: - 字符串操作
public extension String {
    /// 首字母大写,其余保持不变
    /// - Returns: 处理后的字符串,不可用时返回 `nil`
    /// - 返回值: 首字母大写后的字符串;若为空,返回 `nil`
    func fdy_capitalizeFirst() -> String? {
        guard let first = self.first else { return nil }
        return String(first).uppercased() + self.dropFirst()
    }

    /// 返回反转的字符串(非 mutating)
    /// - Returns: 处理后的字符串
    /// - 返回值: 反转结果
    func fdy_reverse() -> String {
        String(self.reversed())
    }

    /// 在字符串前添加前缀(若尚未包含)
    /// - Parameter prefix: 前缀
    /// - Returns: 处理后的字符串
    /// - 参数 prefix: 要添加的前缀
    /// - 返回值: 添加后的字符串
    func fdy_withPrefix(_ prefix: String) -> String {
        self.hasPrefix(prefix) ? self : prefix + self
    }

    /// 在字符串后添加后缀(若尚未包含)
    /// - Parameter suffix: 后缀
    /// - Returns: 处理后的字符串
    /// - 参数 suffix: 要添加的后缀
    /// - 返回值: 添加后的字符串
    func fdy_withSuffix(_ suffix: String) -> String {
        self.hasSuffix(suffix) ? self : self + suffix
    }

    /// 在指定字符位置插入字符串
    /// - Parameters:
    ///   - content: 内容
    ///   - position: 位置
    /// - Returns: 处理后的字符串
    /// - 参数 content: 要插入的内容
    /// - 参数 at: 插入位置（按 `Character` 序号,从 0 开始）
    /// - 返回值: 新字符串;若位置越界,插入到末尾
    func fdy_insert(_ content: String, at position: Int) -> String {
        let safePos = max(0, min(position, self.count))
        let idx = self.index(self.startIndex, offsetBy: safePos)
        return String(self[..<idx]) + content + String(self[idx...])
    }

    /// 重复当前字符串指定次数
    /// - Parameter times: 次数
    /// - Returns: 处理后的字符串
    /// - 参数 times: 重复次数(≥0)
    /// - 返回值: 重复后的字符串;若 `times ≤ 0`,返回空串
    func fdy_repeated(_ times: Int) -> String {
        guard times > 0 else { return "" }
        return String(repeating: self, count: times)
    }

    /// 获取与另一字符串的最长公共后缀
    /// - Parameter other: 另一个值
    /// - Returns: 处理后的字符串
    /// - 参数 other: 比较对象
    /// - 返回值: 公共后缀字符串
    func fdy_commonSuffix(with other: String) -> String {
        let common = zip(self.reversed(), other.reversed())
            .prefix(while: { pair in pair.0 == pair.1 })
            .map(\.0)
        return String(common.reversed())
    }
}

// MARK: - 字符判断(高效、无正则)
public extension String {
    // MARK: - 基础字符检测

    /// 是否包含任意字母
    /// - Returns: 是否满足条件
    var fdy_hasLetters: Bool {
        self.rangeOfCharacter(from: .letters) != nil
    }

    /// 是否只包含字母(无数字、符号等)
    /// - Returns: 是否满足条件
    var fdy_isAlphabetic: Bool {
        !self.isEmpty && self.allSatisfy(\.isLetter)
    }

    /// 是否包含任意数字
    /// - Returns: 是否满足条件
    var fdy_hasDigits: Bool {
        self.rangeOfCharacter(from: .decimalDigits) != nil
    }

    /// 是否只包含数字字符（Unicode `isNumber` 口径）
    ///
    /// - Returns: 是否满足条件
    /// - Note: **不是「仅 0–9」** —— 实现用的是 `Character.isNumber`，
    ///   实测阿拉伯-印度数字 `"١٢٣"`、罗马数字 `"Ⅷ"` 都返回 `true`。
    ///   若要严格限定 ASCII `0`–`9`，请改用
    ///   `rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil`。
    var fdy_isDigits: Bool {
        !self.isEmpty && self.allSatisfy(\.isNumber)
    }

    /// 是否同时包含字母和数字
    /// - Returns: 是否满足条件
    var fdy_hasAlphanumeric: Bool {
        self.fdy_hasLetters && self.fdy_hasDigits
    }

    /// 是否只包含字母或数字(即：字母数字混合,无符号)
    /// - Returns: 是否满足条件
    var fdy_isAlphanumeric: Bool {
        !self.isEmpty && self.allSatisfy { $0.isLetter || $0.isNumber }
    }

    /// 是否只包含空格或换行符
    /// - Returns: 是否满足条件
    var fdy_isWhitespace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 是否所有字符唯一(无重复)
    /// - Returns: 是否满足条件
    var fdy_hasUniqueCharacters: Bool {
        Set(self).count == self.count
    }

    /// 是否包含中文字符(支持扩展汉字)
    /// - Returns: 是否满足条件
    var fdy_containsChinese: Bool {
        self.unicodeScalars.contains { scalar in
            let v = scalar.value
            return (v >= 0x4E00 && v <= 0x9FFF) ||
                (v >= 0x3400 && v <= 0x4DBF) ||
                (v >= 0x20000 && v <= 0x2A6DF) ||
                (v >= 0x2A700 && v <= 0x2B73F) ||
                (v >= 0x2B740 && v <= 0x2B81F)
        }
    }

    /// 是否只包含**基本区**中文字符
    ///
    /// - Returns: 是否满足条件
    /// - Important: 本属性**比同文件的 `fdy_containsChinese` 窄** —— 只认
    ///   `U+4E00–U+9FFF`（基本区）与 `U+3400–U+4DBF`（扩展 A），不认扩展 B 及以后。
    ///   实测扩展 B 区汉字 `"𠀋"`（U+20000）：`fdy_isChinese` 为 `false`，
    ///   而 `fdy_containsChinese` 为 `true`。两者判定范围不一致，按需选用。
    /// - Note: 实现只取**首个** Unicode 标量判定，多标量组合字符按首标量归类。
    var fdy_isChinese: Bool {
        !self.isEmpty && self.allSatisfy { char in
            guard let scalar = char.unicodeScalars.first else { return false }
            let v = scalar.value
            return (v >= 0x4E00 && v <= 0x9FFF) ||
                (v >= 0x3400 && v <= 0x4DBF)
        }
    }

    // MARK: - 连续数字检测

    /// 是否包含连续 ≥2 位的数字
    /// - Returns: 是否满足条件
    var fdy_hasContinuousDigits: Bool {
        var count = 0
        for c in self {
            if c.isNumber {
                count += 1
                if count >= 2 {
                    return true
                }
            } else {
                count = 0
            }
        }
        return false
    }
}

// MARK: - 回文 & 拼写
public extension String {
    /// 是否为回文(忽略大小写,仅比较字母)
    /// - Returns: 是否满足条件
    var fdy_isPalindrome: Bool {
        let letters = self.filter(\.isLetter).lowercased()
        return letters == String(letters.reversed())
    }

    /// 是否拼写正确(仅 iOS/macOS)
    /// - Returns: 是否满足条件
    var fdy_isSpelledCorrectly: Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: self.utf16.count)
        let misspelled = checker.rangeOfMisspelledWord(
            in: self,
            range: range,
            startingAt: 0,
            wrap: false,
            language: Locale.preferredLanguages.first ?? "en"
        )
        return misspelled.location == NSNotFound
    }
}
