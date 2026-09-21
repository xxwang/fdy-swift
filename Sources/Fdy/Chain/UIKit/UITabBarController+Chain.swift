import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UITabBarController {
    /// 代理,传 `nil` 可清空
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UITabBarControllerDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 子控制器
    /// - Parameters:
    ///   - viewControllers: 控制器数组
    ///   - animated: 是否启用动画,默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func viewControllers(_ viewControllers: [UIViewController]?, animated: Bool = false) -> Self {
        if animated {
            base.setViewControllers(viewControllers, animated: true)
        } else {
            base.viewControllers = viewControllers
        }
        return self
    }

    /// 选中索引
    /// - Parameter index: 需要选中的索引
    /// - Returns: `Self`
    @discardableResult
    func selectedIndex(_ index: Int) -> Self {
        base.selectedIndex = index
        return self
    }

    /// 标签页数组
    /// - Parameter tabs: 要设置的标签页数组
    /// - Returns: `Self`
    @discardableResult
    func tabs(_ tabs: [UITab]) -> Self {
        base.tabs = tabs
        return self
    }

    /// 当前选中的标签页
    /// - Parameter selectedTab: 标签页,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func selectedTab(_ selectedTab: UITab?) -> Self {
        base.selectedTab = selectedTab
        return self
    }

    /// 标签栏展示模式
    /// - Parameter mode: 展示模式(标签栏 / 侧边栏)
    /// - Returns: `Self`
    @discardableResult
    func mode(_ mode: UITabBarController.Mode) -> Self {
        base.mode = mode
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

    /// 紧凑模式下展示的标签页标识符
    /// - Parameter compactTabIdentifiers: 标识符数组,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func compactTabIdentifiers(_ compactTabIdentifiers: [String]?) -> Self {
        base.compactTabIdentifiers = compactTabIdentifiers
        return self
    }

    /// 是否隐藏标签栏
    /// - Parameter isTabBarHidden: `true` 表示隐藏标签栏
    /// - Returns: `Self`
    @discardableResult
    func isTabBarHidden(_ isTabBarHidden: Bool) -> Self {
        base.isTabBarHidden = isTabBarHidden
        return self
    }
}

public extension FdyWrapper where Base: UITabBarController {
    /// 标签栏收起行为
    ///
    /// - Parameter tabBarMinimizeBehavior: 收起行为枚举值
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func tabBarMinimizeBehavior(_ tabBarMinimizeBehavior: UITabBarController.MinimizeBehavior) -> Self {
        base.tabBarMinimizeBehavior = tabBarMinimizeBehavior
        return self
    }

    /// 标签栏底部的附属视图
    ///
    /// - Parameter bottomAccessory: 附属视图,传 `nil` 清除
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func bottomAccessory(_ bottomAccessory: UITabAccessory?) -> Self {
        base.bottomAccessory = bottomAccessory
        return self
    }

    /// 需突出显示的标签标识
    ///
    /// - Parameter prominentTabIdentifier: 标签的 `identifier`,传 `nil` 清除
    /// - Returns: `Self`
    @available(iOS 27.0, *)
    @discardableResult
    func prominentTabIdentifier(_ prominentTabIdentifier: String?) -> Self {
        base.prominentTabIdentifier = prominentTabIdentifier
        return self
    }
}
