import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UINavigationBarAppearance {
    /// 行内(小)标题的文本属性
    ///
    /// - Parameter titleTextAttributes: 标题文本属性
    /// - Returns: `Self`
    /// - Note: 只给 `font` / `foregroundColor` 会省下大量样板;两者都不给时系统用默认值补齐。
    ///   单独设字号/颜色见 ``titleFont(_:)`` 与 ``titleColor(_:)``。
    @discardableResult
    func titleTextAttributes(_ titleTextAttributes: [NSAttributedString.Key: Any]) -> Self {
        base.titleTextAttributes = titleTextAttributes
        return self
    }

    /// 行内标题的额外位置偏移
    /// - Parameter titlePositionAdjustment: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func titlePositionAdjustment(_ titlePositionAdjustment: UIOffset) -> Self {
        base.titlePositionAdjustment = titlePositionAdjustment
        return self
    }

    /// 大标题的文本属性
    /// - Parameter largeTitleTextAttributes: 要设置的大标题的文本属性
    /// - Returns: `Self`
    @discardableResult
    func largeTitleTextAttributes(_ largeTitleTextAttributes: [NSAttributedString.Key: Any]) -> Self {
        base.largeTitleTextAttributes = largeTitleTextAttributes
        return self
    }

    /// 导航栏副标题的文本属性
    ///
    /// - Parameter subtitleTextAttributes: 要设置的导航栏副标题的文本属性
    /// - Returns: `Self`
    /// - Note: 标注为 `iOS 26.0` 起可用(反证实测:去掉 `@available` 编译报
    ///   `'subtitleTextAttributes' is only available in iOS 26.0 or newer`)。
    @available(iOS 26.0, *)
    @discardableResult
    func subtitleTextAttributes(_ subtitleTextAttributes: [NSAttributedString.Key: Any]) -> Self {
        base.subtitleTextAttributes = subtitleTextAttributes
        return self
    }

    /// 「大标题下方副标题」的文本属性
    ///
    /// - Parameter largeSubtitleTextAttributes: 大标题下副标题的文本属性
    /// - Returns: `Self`
    /// - Note: 同 ``subtitleTextAttributes(_:)``,`iOS 26.0` 起可用。
    @available(iOS 26.0, *)
    @discardableResult
    func largeSubtitleTextAttributes(_ largeSubtitleTextAttributes: [NSAttributedString.Key: Any]) -> Self {
        base.largeSubtitleTextAttributes = largeSubtitleTextAttributes
        return self
    }

    /// 普通样式按钮项的外观
    /// - Parameter buttonAppearance: 要设置的普通样式按钮项的外观
    /// - Returns: `Self`
    @discardableResult
    func buttonAppearance(_ buttonAppearance: UIBarButtonItemAppearance) -> Self {
        base.buttonAppearance = buttonAppearance
        return self
    }

    ///  `.prominent` 样式按钮项的外观
    ///
    /// - Parameter prominentButtonAppearance: 突出的按钮外观
    /// - Returns: `Self`
    /// - Note: 导航栏上**没有**使用该样式的按钮时,本设置不产生任何效果。
    @discardableResult
    func prominentButtonAppearance(_ prominentButtonAppearance: UIBarButtonItemAppearance) -> Self {
        base.prominentButtonAppearance = prominentButtonAppearance
        return self
    }

    /// 返回按钮的外观
    ///
    /// - Parameter backButtonAppearance: 返回按钮外观
    /// - Returns: `Self`
    /// - Note: 未显式设置时,返回按钮会从 ``buttonAppearance(_:)`` 取默认值。
    @discardableResult
    func backButtonAppearance(_ backButtonAppearance: UIBarButtonItemAppearance) -> Self {
        base.backButtonAppearance = backButtonAppearance
        return self
    }
}

// MARK: - 方法
public extension FdyWrapper where Base: UINavigationBarAppearance {
    /// 返回指示图标及其过渡遮罩图
    ///
    /// - Parameters:
    ///   - backIndicatorImage: 图片
    ///   - transitionMaskImage: 图片
    /// - Returns: `Self`
    /// - Note: **两端绑定** —— 任一张传 `nil` 会把**两张**一起重置成系统默认(头文件明示),
    ///   不存在「只改其中一张」的用法。
    @discardableResult
    func backIndicatorImage(
        _ backIndicatorImage: UIImage?,
        transitionMaskImage: UIImage?
    ) -> Self {
        base.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: transitionMaskImage)
        return self
    }

    /// 行内标题字体
    ///
    /// - Parameter font: 字体
    /// - Returns: `Self`
    /// - Note: 与 `UINavigationBar+Chain.swift` 上的同名方法作用对象**不同** —— 那边改的是导航栏
    ///   `standardAppearance` 的一份副本,这边改的是**本外观对象**;要同时覆盖滚动边缘态,
    ///   两个 `appearance` 各自设一遍。
    @discardableResult
    func titleFont(_ font: UIFont) -> Self {
        updateTextAttributes(\.titleTextAttributes) { $0[.font] = font }
    }

    /// 行内标题颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func titleColor(_ color: UIColor?) -> Self {
        updateTextAttributes(\.titleTextAttributes) { $0[.foregroundColor] = color }
    }

    /// 大标题字体
    /// - Parameter font: 字体
    /// - Returns: `Self`
    @discardableResult
    func largeTitleFont(_ font: UIFont) -> Self {
        updateTextAttributes(\.largeTitleTextAttributes) { $0[.font] = font }
    }

    /// 大标题颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func largeTitleColor(_ color: UIColor?) -> Self {
        updateTextAttributes(\.largeTitleTextAttributes) { $0[.foregroundColor] = color }
    }
}

// MARK: - 文本属性读写模板收敛
private extension FdyWrapper where Base: UINavigationBarAppearance {
    /// 在指定文本属性字典上做一次修改并写回
    ///
    /// 收敛「取字典 → 改一个键 → 写回」的模板。字典是**值类型**,直接对
    /// `base.titleTextAttributes[.font] = font` 做下标赋值虽然也能编过,但会隐去写回语义,
    /// 这里统一走显式写法。
    ///
    /// - Parameters:
    ///   - mutate: 接收 `inout` 字典的闭包
    @discardableResult
    @inline(__always)
    func updateTextAttributes(
        _ keyPath: ReferenceWritableKeyPath<Base, [NSAttributedString.Key: Any]>,
        _ mutate: (inout [NSAttributedString.Key: Any]) -> Void
    ) -> Self {
        var attributes = base[keyPath: keyPath]
        mutate(&attributes)
        base[keyPath: keyPath] = attributes
        return self
    }
}
