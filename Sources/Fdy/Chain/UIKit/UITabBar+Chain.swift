import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UITabBar {
    /// 代理,传 `nil` 可清空
    /// - Parameter delegate: 回调闭包
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: (any UITabBarDelegate)?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 是否半透明
    /// - Parameter isTranslucent: 是否半透明
    /// - Returns: `Self`
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        base.isTranslucent = isTranslucent
        let appearance = base.standardAppearance
        isTranslucent ? appearance.configureWithTransparentBackground() : appearance.configureWithOpaqueBackground()
        base.standardAppearance = appearance
        return self
    }

    /// 标题字体
    /// - Parameters:
    ///   - font: 要设置的字体
    ///   - state: 状态(如 `normal` 或 `selected`),其余状态按 `normal` 处理
    /// - Returns: `Self`
    @discardableResult
    func titleFont(_ font: UIFont, for state: UIControl.State) -> Self {
        let appearance = base.standardAppearance
        if state == .selected {
            var attributes = appearance.stackedLayoutAppearance.selected.titleTextAttributes
            attributes[.font] = font
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributes
        } else {
            var attributes = appearance.stackedLayoutAppearance.normal.titleTextAttributes
            attributes[.font] = font
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
        }
        base.standardAppearance = appearance

        return self
    }

    /// 标题颜色
    /// - Parameters:
    ///   - color: 要设置的颜色
    ///   - state: 状态(如 `normal` 或 `selected`),其余状态按 `normal` 处理
    /// - Returns: `Self`
    @discardableResult
    func titleColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        let appearance = base.standardAppearance
        if state == .selected {
            var attributes = appearance.stackedLayoutAppearance.selected.titleTextAttributes
            attributes[.foregroundColor] = color
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributes
        } else {
            var attributes = appearance.stackedLayoutAppearance.normal.titleTextAttributes
            attributes[.foregroundColor] = color
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
        }
        base.standardAppearance = appearance

        return self
    }

    /// 图标颜色
    /// - Parameters:
    ///   - color: 要设置的颜色
    ///   - state: 状态(如 `normal` 或 `selected`),其余状态按 `normal` 处理
    /// - Returns: `Self`
    @discardableResult
    func iconColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        let appearance = base.standardAppearance
        if state == .selected {
            appearance.stackedLayoutAppearance.selected.iconColor = color
        } else {
            appearance.stackedLayoutAppearance.normal.iconColor = color
        }
        base.standardAppearance = appearance
        return self
    }

    /// 背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        let appearance = base.standardAppearance
        appearance.backgroundColor = color
        appearance.backgroundEffect = nil
        base.standardAppearance = appearance

        return self
    }

    /// 背景图片
    /// - Parameter backgroundImage: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> Self {
        let appearance = base.standardAppearance
        appearance.backgroundImage = backgroundImage
        appearance.backgroundEffect = nil
        base.standardAppearance = appearance

        return self
    }

    /// 标题文字的偏移
    /// - Parameter offset: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func titlePositionAdjustment(_ offset: UIOffset) -> Self {
        let appearance = base.standardAppearance
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
        base.standardAppearance = appearance
        return self
    }

    /// 阴影图片
    /// - Parameter shadowImage: 阴影图片
    /// - Returns: `Self`
    @discardableResult
    func shadowImage(_ shadowImage: UIImage?) -> Self {
        let appearance = base.standardAppearance
        appearance.shadowImage = shadowImage?.withRenderingMode(.alwaysOriginal)
        base.standardAppearance = appearance
        return self
    }

    /// 把 `standardAppearance` 复制给 `scrollEdgeAppearance`,使滚动到边缘时外观一致
    /// - Returns: `Self`
    @discardableResult
    func scrollEdgeAppearanceSynced() -> Self {
        base.scrollEdgeAppearance = base.standardAppearance
        return self
    }

    /// 滚动到边缘时的独立外观(`scrollEdgeAppearance`)
    /// - Parameter appearance: 目标外观
    /// - Returns: `Self`
    @discardableResult
    func scrollEdgeAppearance(_ appearance: UITabBarAppearance) -> Self {
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 选中指示器图片
    /// - Parameter selectionIndicatorImage: 选中指示器图片
    /// - Returns: `Self`
    @discardableResult
    func selectionIndicatorImage(_ selectionIndicatorImage: UIImage) -> Self {
        base.selectionIndicatorImage = selectionIndicatorImage
        return self
    }
}

// MARK: - 链式方法
public extension FdyWrapper where Base: UITabBar {
    /// 圆角,等价于 `CALayer.fdy.roundedCorners(_:corners:)`
    /// - Parameters:
    ///   - maskedCorners: 要圆角的角
    ///   - radius: 圆角半径
    /// - Returns: `Self`
    @discardableResult
    func corner(maskedCorners: CACornerMask, radius: CGFloat) -> Self {
        base.fdy
            .maskedCorners(maskedCorners)
            .cornerRadius(radius)
            .masksToBounds(true)
        return self
    }

    /// 标签栏样式
    /// - Parameter barStyle: 要设置的标签栏样式
    /// - Returns: `Self`
    @discardableResult
    func barStyle(_ barStyle: UIBarStyle) -> Self {
        base.barStyle = barStyle
        return self
    }

    /// 标签项排布方式
    /// - Parameter itemPositioning: 要设置的标签项排布方式
    /// - Returns: `Self`
    @discardableResult
    func itemPositioning(_ itemPositioning: UITabBar.ItemPositioning) -> Self {
        base.itemPositioning = itemPositioning
        return self
    }

    /// 标签项宽度
    /// - Parameter itemWidth: 要设置的标签项宽度
    /// - Returns: `Self`
    @discardableResult
    func itemWidth(_ itemWidth: CGFloat) -> Self {
        base.itemWidth = itemWidth
        return self
    }

    /// 标签项间距
    /// - Parameter itemSpacing: 要设置的标签项间距
    /// - Returns: `Self`
    @discardableResult
    func itemSpacing(_ itemSpacing: CGFloat) -> Self {
        base.itemSpacing = itemSpacing
        return self
    }

    /// 未选中标签项的 `tintColor`
    /// - Parameter color: 颜色,传 `nil` 用系统默认
    /// - Returns: `Self`
    @discardableResult
    func unselectedItemTintColor(_ color: UIColor?) -> Self {
        base.unselectedItemTintColor = color
        return self
    }

    /// 标签栏的默认外观(`standardAppearance`)
    /// - Parameter appearance: 外观配置
    /// - Returns: `Self`
    @discardableResult
    func standardAppearance(_ appearance: UITabBarAppearance) -> Self {
        base.standardAppearance = appearance
        return self
    }
}
