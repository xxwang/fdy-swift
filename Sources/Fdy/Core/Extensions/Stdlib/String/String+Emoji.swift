import Foundation

// MARK: - Emoji检测与提取
public extension String {
    /// 判断字符串是否为单个视觉单元的 Emoji
    var fdy_isSingleEmoji: Bool {
        return self.count == 1 && self.first?.fdy_isEmoji == true
    }

    /// 判断字符串是否包含至少一个 Emoji 字符
    var fdy_containsEmoji: Bool {
        return self.contains { $0.fdy_isEmoji }
    }

    /// 判断字符串是否仅由`Emoji`字符组成（不含空格、标点等）
    var fdy_containsOnlyEmoji: Bool {
        return !self.isEmpty && self.allSatisfy(\.fdy_isEmoji)
    }

    /// 提取所有`Emoji`字符并拼接成新字符串
    var fdy_emojiString: String {
        return self.fdy_emojis.map(String.init).joined()
    }

    /// 提取所有`Emoji`字符数组
    var fdy_emojis: [Character] {
        return self.filter(\.fdy_isEmoji)
    }

    /// 提取所有 `Emoji` 的底层 `Unicode` 标量
    var fdy_emojiScalars: [UnicodeScalar] {
        return self.fdy_emojis.flatMap(\.unicodeScalars)
    }
}
