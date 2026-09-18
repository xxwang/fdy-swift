import UIKit

// MARK: - 链式设置属性
//
// `UIBarAppearance` 及其子类(`UINavigationBarAppearance` / `UITabBarAppearance` / `UIToolbarAppearance`)
// 都是 `NSObject` 子类,因此**继承**了 `extension NSObject: FdyExtension` 的 `.fdy` 入口,无需另行登记
// conformance;链式语义是**引用语义** —— 就地改属性、`return self`,不需要 `build()` 收尾。
//
// 子类独有属性写在各自的 `+Chain.swift` 里;本文件只放三个子类共有的部分(子类自动拿到)。
public extension FdyWrapper where Base: UIBarAppearance {
    /// 设置背景模糊效果
    ///
    /// - Note: 合成顺序是**效果在下、颜色在上、图片再上** —— 与 ``backgroundColor(_:)`` /
    ///   ``backgroundImage(_:)`` 同时使用时会叠加,不是互相覆盖。
    @discardableResult
    func backgroundEffect(_ backgroundEffect: UIBlurEffect?) -> Self {
        base.backgroundEffect = backgroundEffect
        return self
    }

    /// 设置背景色
    ///
    /// - Note: 盖在 ``backgroundEffect(_:)`` 之上,又被 ``backgroundImage(_:)`` 盖住。
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        base.backgroundColor = backgroundColor
        return self
    }

    /// 设置背景图
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> Self {
        base.backgroundImage = backgroundImage
        return self
    }

    /// 设置背景图的渲染方式
    ///
    /// - Note: `.redraw` 会被系统**按 `.scaleToFill` 处理**(头文件明示),不是本库的钳位。
    @discardableResult
    func backgroundImageContentMode(_ backgroundImageContentMode: UIView.ContentMode) -> Self {
        base.backgroundImageContentMode = backgroundImageContentMode
        return self
    }

    /// 设置阴影色
    ///
    /// - Note: 与 ``shadowImage(_:)`` 的配合规则(头文件明示,非本库推导):`shadowImage` 为 `nil` 时
    ///   本色给默认阴影上色,**`nil` 与 `.clear` 都表示「没有阴影」**;`shadowImage` 是模板图时本色
    ///   当 tint 用;`shadowImage` **不是**模板图时它照常渲染、完全无视本色。
    @discardableResult
    func shadowColor(_ shadowColor: UIColor?) -> Self {
        base.shadowColor = shadowColor
        return self
    }

    /// 设置阴影图
    @discardableResult
    func shadowImage(_ shadowImage: UIImage?) -> Self {
        base.shadowImage = shadowImage
        return self
    }

    /// 覆盖该外观自身的 `userInterfaceStyle`
    ///
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
    @discardableResult
    func configureWithDefaultBackground() -> Self {
        base.configureWithDefaultBackground()
        return self
    }

    /// 重置为「不透明背景」(用主题色,不带半透明)
    ///
    /// - Note: 会**同时重置背景与阴影**两组属性,不只改背景。
    @discardableResult
    func configureWithOpaqueBackground() -> Self {
        base.configureWithOpaqueBackground()
        return self
    }

    /// 重置为「透明背景」
    ///
    /// - Note: 同 ``configureWithOpaqueBackground()``,背景与阴影一起被重置。
    @discardableResult
    func configureWithTransparentBackground() -> Self {
        base.configureWithTransparentBackground()
        return self
    }
}
