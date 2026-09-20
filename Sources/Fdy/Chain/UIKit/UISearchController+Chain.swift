import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UISearchController {
    /// 搜索结果更新者
    /// - Parameter searchResultsUpdater: 要设置的搜索结果更新者
    /// - Returns: `Self`
    @discardableResult
    func searchResultsUpdater(_ searchResultsUpdater: UISearchResultsUpdating?) -> Self {
        base.searchResultsUpdater = searchResultsUpdater
        return self
    }

    /// 是否激活
    /// - Parameter active: 是否处于活动态
    /// - Returns: `Self`
    @discardableResult
    func active(_ active: Bool) -> Self {
        base.isActive = active
        return self
    }

    /// 代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UISearchControllerDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 展示时是否隐藏导航栏
    /// - Parameter hidesNavigationBarDuringPresentation: 要设置的展示时是否隐藏导航栏
    /// - Returns: `Self`
    @discardableResult
    func hidesNavigationBarDuringPresentation(_ hidesNavigationBarDuringPresentation: Bool) -> Self {
        base.hidesNavigationBarDuringPresentation = hidesNavigationBarDuringPresentation
        return self
    }

    /// 是否在展示时遮挡底层内容
    /// - Parameter obscuresBackgroundDuringPresentation: 展示时是否遮挡背景
    /// - Returns: `Self`
    @discardableResult
    func obscuresBackgroundDuringPresentation(_ obscuresBackgroundDuringPresentation: Bool) -> Self {
        base.obscuresBackgroundDuringPresentation = obscuresBackgroundDuringPresentation
        return self
    }

    /// 作用域栏的激活方式
    /// - Parameter scopeBarActivation: 要设置的作用域栏的激活方式
    /// - Returns: `Self`
    @discardableResult
    func scopeBarActivation(_ scopeBarActivation: UISearchController.ScopeBarActivation) -> Self {
        base.scopeBarActivation = scopeBarActivation
        return self
    }

    /// 搜索建议列表
    /// - Parameter searchSuggestions: 搜索建议数组,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func searchSuggestions(_ searchSuggestions: [UISearchSuggestion]?) -> Self {
        base.searchSuggestions = searchSuggestions
        return self
    }

    /// 是否忽略「搜索栏与内容堆叠」布局下的搜索建议
    /// - Parameter ignoresSearchSuggestionsForSearchBarPlacementStacked: 堆叠摆放搜索框时是否忽略搜索建议
    /// - Returns: `Self`
    @discardableResult
    func ignoresSearchSuggestionsForSearchBarPlacementStacked(
        _ ignoresSearchSuggestionsForSearchBarPlacementStacked: Bool
    ) -> Self {
        base.ignoresSearchSuggestionsForSearchBarPlacementStacked =
            ignoresSearchSuggestionsForSearchBarPlacementStacked
        return self
    }
}
