import UIKit

// MARK: - 链式设置属性
//
// `UITabBarAppearance` 是 `UIBarAppearance` 的子类,`UIBarAppearance+Chain.swift` 里的
// 背景/阴影/预设方法已自动继承;本文件只补它自己的属性。
public extension FdyWrapper where Base: UITabBarAppearance {
    /// 设置「堆叠」布局下标签项的外观
    @discardableResult
    func stackedLayoutAppearance(_ stackedLayoutAppearance: UITabBarItemAppearance) -> Self {
        base.stackedLayoutAppearance = stackedLayoutAppearance
        return self
    }

    /// 设置「行内」布局下标签项的外观
    @discardableResult
    func inlineLayoutAppearance(_ inlineLayoutAppearance: UITabBarItemAppearance) -> Self {
        base.inlineLayoutAppearance = inlineLayoutAppearance
        return self
    }

    /// 设置「紧凑行内」布局下标签项的外观
    @discardableResult
    func compactInlineLayoutAppearance(_ compactInlineLayoutAppearance: UITabBarItemAppearance) -> Self {
        base.compactInlineLayoutAppearance = compactInlineLayoutAppearance
        return self
    }

    /// 设置选中指示器的颜色
    ///
    /// - Note: 与 ``selectionIndicatorImage(_:)`` 的配合规则和导航栏阴影同源:图为 `nil` 时本色染
    ///   系统默认指示器,**`nil` 与 `.clear` 都表示「不要指示器」**;图是模板图时本色当 tint 用;
    ///   图**不是**模板图时照常渲染、无视本色。
    @discardableResult
    func selectionIndicatorTintColor(_ selectionIndicatorTintColor: UIColor?) -> Self {
        base.selectionIndicatorTintColor = selectionIndicatorTintColor
        return self
    }

    /// 设置选中指示器图片(渲染在选中项之下、标签栏背景之上)
    @discardableResult
    func selectionIndicatorImage(_ selectionIndicatorImage: UIImage?) -> Self {
        base.selectionIndicatorImage = selectionIndicatorImage
        return self
    }

    /// 设置堆叠布局下标签项的排布方式
    @discardableResult
    func stackedItemPositioning(_ stackedItemPositioning: UITabBar.ItemPositioning) -> Self {
        base.stackedItemPositioning = stackedItemPositioning
        return self
    }

    /// 设置堆叠布局下标签项的宽度
    ///
    /// - Note: 命名上只作用于**堆叠布局**;行内布局由系统自行排布。头文件**未说明**这两个属性是否
    ///   受 ``stackedItemPositioning(_:)`` 取值影响 —— 本轮未做行为实测,**不作断言**。
    @discardableResult
    func stackedItemWidth(_ stackedItemWidth: CGFloat) -> Self {
        base.stackedItemWidth = stackedItemWidth
        return self
    }

    /// 设置堆叠布局下标签项的间距
    ///
    /// - Note: 同 ``stackedItemWidth(_:)``,仅堆叠布局 + 未实测依赖关系。
    @discardableResult
    func stackedItemSpacing(_ stackedItemSpacing: CGFloat) -> Self {
        base.stackedItemSpacing = stackedItemSpacing
        return self
    }
}
