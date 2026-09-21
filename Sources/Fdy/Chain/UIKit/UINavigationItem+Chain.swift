import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UINavigationItem {
    /// 大标题的显示模式
    /// - Parameter mode: 大标题显示模式
    /// - Returns: `Self`
    /// - Note: 需配合 `UINavigationBar.prefersLargeTitles = true` 使用
    @discardableResult
    func largeTitleDisplayMode(_ mode: UINavigationItem.LargeTitleDisplayMode) -> Self {
        base.largeTitleDisplayMode = mode
        return self
    }

    /// 导航栏标题文本
    /// - Parameter title: 标题字符串
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        base.title = title
        return self
    }

    /// 自定义标题视图
    /// - Parameter view: 自定义视图
    /// - Returns: `Self`
    /// - Note: 会覆盖 `title`
    @discardableResult
    func titleView(_ view: UIView?) -> Self {
        base.titleView = view
        return self
    }

    /// 返回按钮的外观
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 按钮样式,默认为 `.plain`
    /// - Returns: `Self`
    /// - Note:影响下一个`push`进来的控制器的返回按钮
    @discardableResult
    func backBarButtonItem(title: String?, style: UIBarButtonItem.Style = .plain) -> Self {
        let backButton = UIBarButtonItem(title: title, style: style, target: nil, action: nil)
        base.backBarButtonItem = backButton
        return self
    }

    /// 左侧单个按钮
    /// - Parameter buttonItem: 左侧按钮项
    /// - Returns: `Self`
    @discardableResult
    func leftBarButtonItem(_ buttonItem: UIBarButtonItem?) -> Self {
        base.leftBarButtonItem = buttonItem
        return self
    }

    /// 右侧单个按钮
    /// - Parameter buttonItem: 右侧按钮项
    /// - Returns: `Self`
    @discardableResult
    func rightBarButtonItem(_ buttonItem: UIBarButtonItem?) -> Self {
        base.rightBarButtonItem = buttonItem
        return self
    }

    /// 左侧多个按钮
    ///
    /// - Parameter items: 按钮数组,顺序从左到右
    /// - Returns: `Self`
    @discardableResult
    func leftBarButtonItems(_ items: [UIBarButtonItem]?) -> Self {
        base.leftBarButtonItems = items
        return self
    }

    /// 右侧多个按钮
    ///
    /// - Parameter items: 按钮数组,顺序从右到左
    /// - Returns: `Self`
    @discardableResult
    func rightBarButtonItems(_ items: [UIBarButtonItem]?) -> Self {
        base.rightBarButtonItems = items
        return self
    }

    /// 提示语(显示在标题上方的小字)
    /// - Parameter prompt: 提示语,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func prompt(_ prompt: String?) -> Self {
        base.prompt = prompt
        return self
    }

    /// 返回按钮标题
    /// - Parameter backButtonTitle: 标题,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func backButtonTitle(_ backButtonTitle: String?) -> Self {
        base.backButtonTitle = backButtonTitle
        return self
    }

    /// 是否隐藏返回按钮
    /// - Parameter hidesBackButton: `true` 表示隐藏返回按钮
    /// - Returns: `Self`
    @discardableResult
    func hidesBackButton(_ hidesBackButton: Bool) -> Self {
        base.hidesBackButton = hidesBackButton
        return self
    }

    /// 返回按钮展示模式
    /// - Parameter backButtonDisplayMode: 返回按钮显示模式
    /// - Returns: `Self`
    @discardableResult
    func backButtonDisplayMode(_ backButtonDisplayMode: UINavigationItem.BackButtonDisplayMode) -> Self {
        base.backButtonDisplayMode = backButtonDisplayMode
        return self
    }

    /// 返回操作
    /// - Parameter backAction: 操作,传 `nil` 用系统默认
    /// - Returns: `Self`
    @discardableResult
    func backAction(_ backAction: UIAction?) -> Self {
        base.backAction = backAction
        return self
    }

    /// 重命名代理
    /// - Parameter renameDelegate: 遵循 `UINavigationItemRenameDelegate` 的对象
    /// - Returns: `Self`
    @discardableResult
    func renameDelegate(_ renameDelegate: UINavigationItemRenameDelegate?) -> Self {
        base.renameDelegate = renameDelegate
        return self
    }

    /// 文档属性(用于展示文件类信息)
    /// - Parameter documentProperties: 文档属性,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func documentProperties(_ documentProperties: UIDocumentProperties?) -> Self {
        base.documentProperties = documentProperties
        return self
    }

    /// 左侧按钮是否与返回按钮并存
    /// - Parameter leftItemsSupplementBackButton: 要设置的左侧按钮是否与返回按钮并存
    /// - Returns: `Self`
    @discardableResult
    func leftItemsSupplementBackButton(_ leftItemsSupplementBackButton: Bool) -> Self {
        base.leftItemsSupplementBackButton = leftItemsSupplementBackButton
        return self
    }

    /// 自定义标识符
    /// - Parameter customizationIdentifier: 标识符,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func customizationIdentifier(_ customizationIdentifier: String?) -> Self {
        base.customizationIdentifier = customizationIdentifier
        return self
    }

    /// 前置按钮组
    /// - Parameter leadingItemGroups: 要设置的前置按钮组
    /// - Returns: `Self`
    @discardableResult
    func leadingItemGroups(_ leadingItemGroups: [UIBarButtonItemGroup]) -> Self {
        base.leadingItemGroups = leadingItemGroups
        return self
    }

    /// 中间按钮组
    /// - Parameter centerItemGroups: 要设置的中间按钮组
    /// - Returns: `Self`
    @discardableResult
    func centerItemGroups(_ centerItemGroups: [UIBarButtonItemGroup]) -> Self {
        base.centerItemGroups = centerItemGroups
        return self
    }

    /// 后置按钮组
    /// - Parameter trailingItemGroups: 要设置的后置按钮组
    /// - Returns: `Self`
    @discardableResult
    func trailingItemGroups(_ trailingItemGroups: [UIBarButtonItemGroup]) -> Self {
        base.trailingItemGroups = trailingItemGroups
        return self
    }

    /// 固定在后置位置的分组
    /// - Parameter pinnedTrailingGroup: 分组,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func pinnedTrailingGroup(_ pinnedTrailingGroup: UIBarButtonItemGroup?) -> Self {
        base.pinnedTrailingGroup = pinnedTrailingGroup
        return self
    }

    /// 溢出区域的额外菜单元素
    /// - Parameter additionalOverflowItems: 菜单元素,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func additionalOverflowItems(_ additionalOverflowItems: UIDeferredMenuElement?) -> Self {
        base.additionalOverflowItems = additionalOverflowItems
        return self
    }

    /// 导航项样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func style(_ style: UINavigationItem.ItemStyle) -> Self {
        base.style = style
        return self
    }

    /// 搜索控制器
    /// - Parameter searchController: 搜索控制器,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func searchController(_ searchController: UISearchController?) -> Self {
        base.searchController = searchController
        return self
    }

    /// 滚动时是否隐藏搜索栏
    /// - Parameter hidesSearchBarWhenScrolling: 要设置的滚动时是否隐藏搜索栏
    /// - Returns: `Self`
    @discardableResult
    func hidesSearchBarWhenScrolling(_ hidesSearchBarWhenScrolling: Bool) -> Self {
        base.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
        return self
    }

    /// 搜索栏的首选位置
    /// - Parameter preferredSearchBarPlacement: 要设置的搜索栏的首选位置
    /// - Returns: `Self`
    @discardableResult
    func preferredSearchBarPlacement(
        _ preferredSearchBarPlacement: UINavigationItem.SearchBarPlacement
    ) -> Self {
        base.preferredSearchBarPlacement = preferredSearchBarPlacement
        return self
    }

    /// 该项自己的默认外观
    /// - Parameter appearance: 目标外观,传 `nil` 回退到导航栏的设置
    /// - Returns: `Self`
    @discardableResult
    func standardAppearance(_ appearance: UINavigationBarAppearance?) -> Self {
        base.standardAppearance = appearance
        return self
    }

    /// 该项在紧凑高度下的外观
    /// - Parameter appearance: 目标外观,传 `nil` 回退到上一级
    /// - Returns: `Self`
    @discardableResult
    func compactAppearance(_ appearance: UINavigationBarAppearance?) -> Self {
        base.compactAppearance = appearance
        return self
    }

    /// 该项滚动到边缘时的外观
    /// - Parameter appearance: 目标外观,传 `nil` 回退到上一级
    /// - Returns: `Self`
    @discardableResult
    func scrollEdgeAppearance(_ appearance: UINavigationBarAppearance?) -> Self {
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 该项在紧凑高度且滚动到边缘时的外观
    /// - Parameter appearance: 目标外观,传 `nil` 回退到上一级
    /// - Returns: `Self`
    @discardableResult
    func compactScrollEdgeAppearance(_ appearance: UINavigationBarAppearance?) -> Self {
        base.compactScrollEdgeAppearance = appearance
        return self
    }
}

public extension FdyWrapper where Base: UINavigationItem {
    /// 导航栏副标题
    ///
    /// - Parameter subtitle: 要显示的副标题,传 `nil` 清空
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func subtitle(_ subtitle: String?) -> Self {
        base.subtitle = subtitle
        return self
    }

    /// 导航栏富文本副标题
    ///
    /// - Parameter attributedSubtitle: 富文本副标题,传 `nil` 清空;优先级高于 `subtitle`
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func attributedSubtitle(_ attributedSubtitle: AttributedString?) -> Self {
        base.attributedSubtitle = attributedSubtitle
        return self
    }

    /// 大标题下的副标题
    ///
    /// - Parameter largeSubtitle: 要显示的副标题,传 `nil` 清空
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func largeSubtitle(_ largeSubtitle: String?) -> Self {
        base.largeSubtitle = largeSubtitle
        return self
    }

    /// 大标题下的富文本副标题
    ///
    /// - Parameter largeAttributedSubtitle: 富文本副标题,传 `nil` 清空;优先级高于 `largeSubtitle`
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func largeAttributedSubtitle(_ largeAttributedSubtitle: AttributedString?) -> Self {
        base.largeAttributedSubtitle = largeAttributedSubtitle
        return self
    }

    /// 自定义副标题视图
    ///
    /// - Parameter subtitleView: 要展示的视图,传 `nil` 清空;优先级高于 `subtitle` 与 `attributedSubtitle`
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func subtitleView(_ subtitleView: UIView?) -> Self {
        base.subtitleView = subtitleView
        return self
    }

    /// 自定义大标题副标题视图
    ///
    /// - Parameter largeSubtitleView: 要展示的视图,传 `nil` 清空;优先级高于其它副标题
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func largeSubtitleView(_ largeSubtitleView: UIView?) -> Self {
        base.largeSubtitleView = largeSubtitleView
        return self
    }

    /// 是否允许搜索栏并入工具栏
    ///
    /// - Parameter allowsToolbarIntegration: `true` 允许并入
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func searchBarPlacementAllowsToolbarIntegration(_ allowsToolbarIntegration: Bool) -> Self {
        base.searchBarPlacementAllowsToolbarIntegration = allowsToolbarIntegration
        return self
    }

    /// 是否允许上层容器取走搜索栏
    ///
    /// - Parameter allowsExternalIntegration: `true` 允许取走
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func searchBarPlacementAllowsExternalIntegration(_ allowsExternalIntegration: Bool) -> Self {
        base.searchBarPlacementAllowsExternalIntegration = allowsExternalIntegration
        return self
    }

    /// 导航栏富文本标题
    ///
    /// - Parameter attributedTitle: 富文本标题,传 `nil` 清空
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func attributedTitle(_ attributedTitle: AttributedString?) -> Self {
        base.attributedTitle = attributedTitle
        return self
    }
}
