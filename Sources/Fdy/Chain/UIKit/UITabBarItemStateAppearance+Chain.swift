import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UITabBarItemStateAppearance {
    /// 该状态下标题的文本属性
    /// - Parameter titleTextAttributes: 标题文本属性
    /// - Returns: `Self`
    @discardableResult
    func titleTextAttributes(_ titleTextAttributes: [NSAttributedString.Key: Any]) -> Self {
        base.titleTextAttributes = titleTextAttributes
        return self
    }

    /// 该状态下标题的位置偏移
    /// - Parameter titlePositionAdjustment: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func titlePositionAdjustment(_ titlePositionAdjustment: UIOffset) -> Self {
        base.titlePositionAdjustment = titlePositionAdjustment
        return self
    }

    /// 该状态下图标颜色,传 `nil` 可回落默认
    /// - Parameter iconColor: 颜色
    /// - Returns: `Self`
    @discardableResult
    func iconColor(_ iconColor: UIColor?) -> Self {
        base.iconColor = iconColor
        return self
    }

    /// 该状态下角标的位置偏移
    /// - Parameter badgePositionAdjustment: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func badgePositionAdjustment(_ badgePositionAdjustment: UIOffset) -> Self {
        base.badgePositionAdjustment = badgePositionAdjustment
        return self
    }

    /// 该状态下角标的背景色,传 `nil` 可回落默认
    /// - Parameter badgeBackgroundColor: 颜色
    /// - Returns: `Self`
    @discardableResult
    func badgeBackgroundColor(_ badgeBackgroundColor: UIColor?) -> Self {
        base.badgeBackgroundColor = badgeBackgroundColor
        return self
    }

    /// 该状态下角标文字的文本属性
    /// - Parameter badgeTextAttributes: 要设置的该状态下角标文字的文本属性
    /// - Returns: `Self`
    @discardableResult
    func badgeTextAttributes(_ badgeTextAttributes: [NSAttributedString.Key: Any]) -> Self {
        base.badgeTextAttributes = badgeTextAttributes
        return self
    }

    /// 该状态下角标标题的位置偏移
    /// - Parameter badgeTitlePositionAdjustment: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func badgeTitlePositionAdjustment(_ badgeTitlePositionAdjustment: UIOffset) -> Self {
        base.badgeTitlePositionAdjustment = badgeTitlePositionAdjustment
        return self
    }
}
