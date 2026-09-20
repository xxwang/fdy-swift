import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIBarAppearance {
    /// 背景模糊效果
    ///
    /// - Parameter backgroundEffect: 要设置的背景模糊效果
    /// - Returns: `Self`
    /// - Note: 合成顺序是**效果在下、颜色在上、图片再上** —— 与 ``backgroundColor(_:)`` /
    ///   ``backgroundImage(_:)`` 同时使用时会叠加,不是互相覆盖。
    @discardableResult
    func backgroundEffect(_ backgroundEffect: UIBlurEffect?) -> Self {
        base.backgroundEffect = backgroundEffect
        return self
    }

    /// 背景色
    ///
    /// - Parameter backgroundColor: 颜色
    /// - Returns: `Self`
    /// - Note: 盖在 ``backgroundEffect(_:)`` 之上,又被 ``backgroundImage(_:)`` 盖住。
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        base.backgroundColor = backgroundColor
        return self
    }

    /// 背景图
    /// - Parameter backgroundImage: 图片
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> Self {
        base.backgroundImage = backgroundImage
        return self
    }

    /// 背景图的渲染方式
    ///
    /// - Parameter backgroundImageContentMode: 要设置的背景图的渲染方式
    /// - Returns: `Self`
    /// - Note: `.redraw` 会被系统**按 `.scaleToFill` 处理**(头文件明示),不是本库的钳位。
    @discardableResult
    func backgroundImageContentMode(_ backgroundImageContentMode: UIView.ContentMode) -> Self {
        base.backgroundImageContentMode = backgroundImageContentMode
        return self
    }

    /// 阴影色
    ///
    /// - Parameter shadowColor: 颜色
    /// - Returns: `Self`
    /// - Note: 与 ``shadowImage(_:)`` 的配合规则(头文件明示,非本库推导):`shadowImage` 为 `nil` 时
    ///   本色给默认阴影上色,**`nil` 与 `.clear` 都表示「没有阴影」**;`shadowImage` 是模板图时本色
    ///   当 tint 用;`shadowImage` **不是**模板图时它照常渲染、完全无视本色。
    @discardableResult
    func shadowColor(_ shadowColor: UIColor?) -> Self {
        base.shadowColor = shadowColor
        return self
    }

    /// 阴影图
    /// - Parameter shadowImage: 图片
    /// - Returns: `Self`
    @discardableResult
    func shadowImage(_ shadowImage: UIImage?) -> Self {
        base.shadowImage = shadowImage
        return self
    }

    /// 覆盖该外观自身的 `userInterfaceStyle`
    ///
    /// - Parameter overrideUserInterfaceStyle: 强制覆盖的界面风格
    /// - Returns: `Self`
    /// - Note: 标注为 `iOS 27.0` 起可用(反证实测:去掉 `@available` 编译报
    ///   `'overrideUserInterfaceStyle' is only available in iOS 27.0 or newer`)。
    ///   部署目标低于 27 时调用方需自己 `if #available(iOS 27.0, *)` 包裹。
    @available(iOS 27.0, *)
    @discardableResult
    func overrideUserInterfaceStyle(_ overrideUserInterfaceStyle: UIUserInterfaceStyle) -> Self {
        base.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        return self
    }
}

// MARK: - 预设背景
public extension FdyWrapper where Base: UIBarAppearance {
    /// 重置为「默认背景」(跟随系统材质的半透明样式)
    /// - Returns: `Self`
    @discardableResult
    func configureWithDefaultBackground() -> Self {
        base.configureWithDefaultBackground()
        return self
    }

    /// 重置为「不透明背景」(用主题色,不带半透明)
    ///
    /// - Returns: `Self`
    /// - Note: 会**同时重置背景与阴影**两组属性,不只改背景。
    @discardableResult
    func configureWithOpaqueBackground() -> Self {
        base.configureWithOpaqueBackground()
        return self
    }

    /// 重置为「透明背景」
    ///
    /// - Returns: `Self`
    /// - Note: 同 ``configureWithOpaqueBackground()``,背景与阴影一起被重置。
    @discardableResult
    func configureWithTransparentBackground() -> Self {
        base.configureWithTransparentBackground()
        return self
    }
}
