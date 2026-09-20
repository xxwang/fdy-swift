import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: NSLayoutManager {
    /// 文本存储
    /// - Parameter textStorage: 要设置的文本存储
    /// - Returns: `Self`
    @discardableResult
    func textStorage(_ textStorage: NSTextStorage?) -> Self {
        base.textStorage = textStorage
        return self
    }

    /// 代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: NSLayoutManagerDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 是否显示不可见字符
    /// - Parameter showsInvisibleCharacters: `true` 表示显示不可见字符
    /// - Returns: `Self`
    @discardableResult
    func showsInvisibleCharacters(_ showsInvisibleCharacters: Bool) -> Self {
        base.showsInvisibleCharacters = showsInvisibleCharacters
        return self
    }

    /// 是否显示控制字符
    /// - Parameter showsControlCharacters: `true` 表示显示控制字符
    /// - Returns: `Self`
    @discardableResult
    func showsControlCharacters(_ showsControlCharacters: Bool) -> Self {
        base.showsControlCharacters = showsControlCharacters
        return self
    }

    /// 是否使用字体的行距
    /// - Parameter usesFontLeading: 是否采用字体自带 leading(关掉可压缩行高)
    /// - Returns: `Self`
    @discardableResult
    func usesFontLeading(_ usesFontLeading: Bool) -> Self {
        base.usesFontLeading = usesFontLeading
        return self
    }

    /// 是否允许非连续布局
    /// - Parameter allowsNonContiguousLayout: `true` 表示允许非连续布局
    /// - Returns: `Self`
    @discardableResult
    func allowsNonContiguousLayout(_ allowsNonContiguousLayout: Bool) -> Self {
        base.allowsNonContiguousLayout = allowsNonContiguousLayout
        return self
    }

    /// 是否限制可疑内容的布局(防恶意文本撑爆)
    /// - Parameter limitsLayoutForSuspiciousContents: 是否限制可疑内容的布局
    /// - Returns: `Self`
    @discardableResult
    func limitsLayoutForSuspiciousContents(_ limitsLayoutForSuspiciousContents: Bool) -> Self {
        base.limitsLayoutForSuspiciousContents = limitsLayoutForSuspiciousContents
        return self
    }

    /// 是否使用默认连字符处理
    /// - Parameter usesDefaultHyphenation: 是否启用自动断词
    /// - Returns: `Self`
    @discardableResult
    func usesDefaultHyphenation(_ usesDefaultHyphenation: Bool) -> Self {
        base.usesDefaultHyphenation = usesDefaultHyphenation
        return self
    }
}
