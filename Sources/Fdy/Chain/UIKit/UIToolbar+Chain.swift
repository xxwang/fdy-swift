import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIToolbar {
    /// 工具栏样式
    /// - Parameter barStyle: 要设置的工具栏样式
    /// - Returns: `Self`
    @discardableResult
    func barStyle(_ barStyle: UIBarStyle) -> Self {
        base.barStyle = barStyle
        return self
    }

    /// 工具栏上的按钮项,传 `nil` 可清空
    /// - Parameter items: 元素数组
    /// - Returns: `Self`
    @discardableResult
    func items(_ items: [UIBarButtonItem]?) -> Self {
        base.items = items
        return self
    }

    /// 代理,传 `nil` 可清空
    /// - Parameter delegate: 回调闭包
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: (any UIToolbarDelegate)?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 是否半透明
    ///
    /// - Parameter isTranslucent: `true` 表示半透明
    /// - Returns: `Self`
    /// - Note: 与 `UITabBar+Chain.swift` 的同名方法一致 —— 除写属性外,还会把
    ///   `standardAppearance` 切成透明/不透明预设。**只写 `isTranslucent` 属性本身几乎看不出效果**,
    ///   真正决定观感的是外观对象;`UINavigationBar+Chain.swift` 的同名方法不做这步同步,
    ///   两边**语义不同源**,别互相套用。
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        base.isTranslucent = isTranslucent
        let appearance = base.standardAppearance
        isTranslucent ? appearance.configureWithTransparentBackground() : appearance.configureWithOpaqueBackground()
        base.standardAppearance = appearance
        return self
    }

    /// 工具栏的 `tintColor`(作用于按钮项)
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        base.tintColor = color
        return self
    }

    /// 工具栏的 `barTintColor`(作用于栏背景)
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func barTintColor(_ color: UIColor?) -> Self {
        base.barTintColor = color
        return self
    }

    /// 默认外观
    /// - Parameter appearance: 外观配置
    /// - Returns: `Self`
    @discardableResult
    func standardAppearance(_ appearance: UIToolbarAppearance) -> Self {
        base.standardAppearance = appearance
        return self
    }

    /// 紧凑高度下的外观,传 `nil` 可回落默认
    /// - Parameter appearance: 外观配置
    /// - Returns: `Self`
    @discardableResult
    func compactAppearance(_ appearance: UIToolbarAppearance?) -> Self {
        base.compactAppearance = appearance
        return self
    }

    /// 滚动到边缘时的独立外观,传 `nil` 可回落默认
    /// - Parameter appearance: 外观配置
    /// - Returns: `Self`
    @discardableResult
    func scrollEdgeAppearance(_ appearance: UIToolbarAppearance?) -> Self {
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 滚动到边缘且处于紧凑高度时使用的外观,传 `nil` 可回落默认
    /// - Parameter appearance: 外观配置
    /// - Returns: `Self`
    @discardableResult
    func compactScrollEdgeAppearance(_ appearance: UIToolbarAppearance?) -> Self {
        base.compactScrollEdgeAppearance = appearance
        return self
    }
}

// MARK: - 链式方法
public extension FdyWrapper where Base: UIToolbar {
    /// 背景颜色
    ///
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    /// - Note: 写的是 `standardAppearance`,并清掉 `backgroundEffect` —— 不清的话毛玻璃会盖住纯色。
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        let appearance = base.standardAppearance
        appearance.backgroundColor = color
        appearance.backgroundEffect = nil
        base.standardAppearance = appearance
        return self
    }

    /// 背景图片
    ///
    /// - Parameter backgroundImage: 图片
    /// - Returns: `Self`
    /// - Note: 同 ``backgroundColor(_:)``,一并清掉 `backgroundEffect`。
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> Self {
        let appearance = base.standardAppearance
        appearance.backgroundImage = backgroundImage
        appearance.backgroundEffect = nil
        base.standardAppearance = appearance
        return self
    }

    /// 阴影图片
    ///
    /// - Parameter shadowImage: 图片
    /// - Returns: `Self`
    /// - Note: 与 `UINavigationBar+Chain.swift` / `UITabBar+Chain.swift` 一致,统一
    ///   `.withRenderingMode(.alwaysOriginal)`,否则图片会被当模板图整体染色。
    @discardableResult
    func shadowImage(_ shadowImage: UIImage?) -> Self {
        let appearance = base.standardAppearance
        appearance.shadowImage = shadowImage?.withRenderingMode(.alwaysOriginal)
        base.standardAppearance = appearance
        return self
    }

    /// 阴影颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func shadowColor(_ color: UIColor?) -> Self {
        let appearance = base.standardAppearance
        appearance.shadowColor = color
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
}
