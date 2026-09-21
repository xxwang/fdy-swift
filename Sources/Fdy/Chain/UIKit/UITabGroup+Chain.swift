import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UITabGroup {
    /// 选中的子标签
    /// - Parameter selectedChild: 要设置的选中的子标签
    /// - Returns: `Self`
    @discardableResult
    func selectedChild(_ selectedChild: UITab?) -> Self {
        base.selectedChild = selectedChild
        return self
    }

    /// 默认子标签标识
    /// - Parameter defaultChildIdentifier: 首次展示时选中的子标签 `identifier`
    /// - Returns: `Self`
    @discardableResult
    func defaultChildIdentifier(_ defaultChildIdentifier: String?) -> Self {
        base.defaultChildIdentifier = defaultChildIdentifier
        return self
    }

    /// 子标签列表
    /// - Parameter children: 分组内的子标签(层级最多两层)
    /// - Returns: `Self`
    @discardableResult
    func children(_ children: [UITab]) -> Self {
        base.children = children
        return self
    }

    /// 是否允许重排序
    /// - Parameter allowsReordering: `true` 表示允许重排序
    /// - Returns: `Self`
    @discardableResult
    func allowsReordering(_ allowsReordering: Bool) -> Self {
        base.allowsReordering = allowsReordering
        return self
    }

    /// 展示顺序
    /// - Parameter displayOrderIdentifiers: 按 `identifier` 指定的显式顺序
    /// - Returns: `Self`
    @discardableResult
    func displayOrderIdentifiers(_ displayOrderIdentifiers: [String]) -> Self {
        base.displayOrderIdentifiers = displayOrderIdentifiers
        return self
    }

    /// 管理该分组的导航控制器
    /// - Parameter managingNavigationController: 由系统接管,仅在侧边栏形态下非 `nil`
    /// - Returns: `Self`
    @discardableResult
    func managingNavigationController(_ managingNavigationController: UINavigationController?) -> Self {
        base.managingNavigationController = managingNavigationController
        return self
    }

    /// 侧边栏操作数组
    /// - Parameter sidebarActions: 要设置的侧边栏操作数组
    /// - Returns: `Self`
    @discardableResult
    func sidebarActions(_ sidebarActions: [UIAction]) -> Self {
        base.sidebarActions = sidebarActions
        return self
    }

    /// 侧边栏外观
    /// - Parameter sidebarAppearance: 要设置的侧边栏外观
    /// - Returns: `Self`
    @discardableResult
    func sidebarAppearance(_ sidebarAppearance: UITabGroup.SidebarAppearance) -> Self {
        base.sidebarAppearance = sidebarAppearance
        return self
    }
}

public extension FdyWrapper where Base: UITabGroup {
    /// 是否作为侧边栏目标
    ///
    /// - Parameter isSidebarDestination: `true` 时该组可作为侧边栏
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func isSidebarDestination(_ isSidebarDestination: Bool) -> Self {
        base.isSidebarDestination = isSidebarDestination
        return self
    }

    /// 默认是否折叠
    ///
    /// - Parameter isCollapsedByDefault: `true` 默认折叠
    /// - Returns: `Self`
    @available(iOS 26.1, *)
    @discardableResult
    func isCollapsedByDefault(_ isCollapsedByDefault: Bool) -> Self {
        base.isCollapsedByDefault = isCollapsedByDefault
        return self
    }
}
