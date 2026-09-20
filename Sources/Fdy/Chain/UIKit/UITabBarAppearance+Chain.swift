import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UITabBarAppearance {
    /// 「堆叠」布局下标签项的外观
    /// - Parameter stackedLayoutAppearance: 要设置的「堆叠」布局下标签项的外观
    /// - Returns: `Self`
    @discardableResult
    func stackedLayoutAppearance(_ stackedLayoutAppearance: UITabBarItemAppearance) -> Self {
        base.stackedLayoutAppearance = stackedLayoutAppearance
        return self
    }

    /// 「行内」布局下标签项的外观
    /// - Parameter inlineLayoutAppearance: 要设置的「行内」布局下标签项的外观
    /// - Returns: `Self`
    @discardableResult
    func inlineLayoutAppearance(_ inlineLayoutAppearance: UITabBarItemAppearance) -> Self {
        base.inlineLayoutAppearance = inlineLayoutAppearance
        return self
    }

    /// 「紧凑行内」布局下标签项的外观
    /// - Parameter compactInlineLayoutAppearance: 紧凑内联布局外观
    /// - Returns: `Self`
    @discardableResult
    func compactInlineLayoutAppearance(_ compactInlineLayoutAppearance: UITabBarItemAppearance) -> Self {
        base.compactInlineLayoutAppearance = compactInlineLayoutAppearance
        return self
    }

    /// 选中指示器的颜色
    ///
    /// - Parameter selectionIndicatorTintColor: 颜色
    /// - Returns: `Self`
    /// - Note: 与 ``selectionIndicatorImage(_:)`` 的配合规则和导航栏阴影同源:图为 `nil` 时本色染
    ///   系统默认指示器,**`nil` 与 `.clear` 都表示「不要指示器」**;图是模板图时本色当 tint 用;
    ///   图**不是**模板图时照常渲染、无视本色。
    @discardableResult
    func selectionIndicatorTintColor(_ selectionIndicatorTintColor: UIColor?) -> Self {
        base.selectionIndicatorTintColor = selectionIndicatorTintColor
        return self
    }

    /// 选中指示器图片(渲染在选中项之下、标签栏背景之上)
    /// - Parameter selectionIndicatorImage: 图片
    /// - Returns: `Self`
    @discardableResult
    func selectionIndicatorImage(_ selectionIndicatorImage: UIImage?) -> Self {
        base.selectionIndicatorImage = selectionIndicatorImage
        return self
    }

    /// 堆叠布局下标签项的排布方式
    /// - Parameter stackedItemPositioning: 要设置的堆叠布局下标签项的排布方式
    /// - Returns: `Self`
    @discardableResult
    func stackedItemPositioning(_ stackedItemPositioning: UITabBar.ItemPositioning) -> Self {
        base.stackedItemPositioning = stackedItemPositioning
        return self
    }

    /// 堆叠布局下标签项的宽度
    ///
    /// - Parameter stackedItemWidth: 要设置的堆叠布局下标签项的宽度
    /// - Returns: `Self`
    /// - Note: 命名上只作用于**堆叠布局**;行内布局由系统自行排布。头文件**未说明**这两个属性是否
    ///   受 ``stackedItemPositioning(_:)`` 取值影响 —— 本轮未做行为实测,**不作断言**。
    @discardableResult
    func stackedItemWidth(_ stackedItemWidth: CGFloat) -> Self {
        base.stackedItemWidth = stackedItemWidth
        return self
    }

    /// 堆叠布局下标签项的间距
    ///
    /// - Parameter stackedItemSpacing: 要设置的堆叠布局下标签项的间距
    /// - Returns: `Self`
    /// - Note: 同 ``stackedItemWidth(_:)``,仅堆叠布局 + 未实测依赖关系。
    @discardableResult
    func stackedItemSpacing(_ stackedItemSpacing: CGFloat) -> Self {
        base.stackedItemSpacing = stackedItemSpacing
        return self
    }
}
