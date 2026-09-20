import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UISearchTextField {
    /// 令牌(token)数组,用于把结构化对象当整体编辑与删除
    /// - Parameter tokens: 令牌数组
    /// - Returns: `Self`
    @discardableResult
    func tokens(_ tokens: [UISearchToken]) -> Self {
        base.tokens = tokens
        return self
    }

    /// 令牌的背景色
    /// - Parameter tokenBackgroundColor: 颜色
    /// - Returns: `Self`
    @discardableResult
    func tokenBackgroundColor(_ tokenBackgroundColor: UIColor?) -> Self {
        base.tokenBackgroundColor = tokenBackgroundColor
        return self
    }

    /// 是否允许用退格键逐个删除令牌
    /// - Parameter allowsDeletingTokens: 是否允许删除令牌
    /// - Returns: `Self`
    @discardableResult
    func allowsDeletingTokens(_ allowsDeletingTokens: Bool) -> Self {
        base.allowsDeletingTokens = allowsDeletingTokens
        return self
    }

    /// 是否允许把令牌当作文本一起复制
    /// - Parameter allowsCopyingTokens: 是否允许复制令牌
    /// - Returns: `Self`
    @discardableResult
    func allowsCopyingTokens(_ allowsCopyingTokens: Bool) -> Self {
        base.allowsCopyingTokens = allowsCopyingTokens
        return self
    }

    /// 搜索建议列表,传 `nil` 可清空
    ///
    /// - Parameter searchSuggestions: 搜索建议数组
    /// - Returns: `Self`
    /// - Note: `iOS 16.0` 起可用,低于新增 API 门槛(`iOS 18.0`),按约定**不加** `@available`。
    /// - Note: ⚠️ **读回值被系统改写** —— 该属性的默认值**不是 `nil`**,传 `nil` 清空后读回是
    ///   **空数组**(CLI 取证实测,18.0 / 26.5 一致)。别拿它跟 `nil` 比。
    @discardableResult
    func searchSuggestions(_ searchSuggestions: [any UISearchSuggestion]?) -> Self {
        base.searchSuggestions = searchSuggestions
        return self
    }
}
