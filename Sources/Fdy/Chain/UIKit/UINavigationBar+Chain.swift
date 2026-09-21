import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UINavigationBar {
    /// 导航栏是否半透明
    /// - Parameter isTranslucent: 是否半透明
    /// - Returns: `Self`
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        base.isTranslucent = isTranslucent
        return self
    }

    /// 是否启用大标题
    /// - Parameter large: 是否启用大标题
    /// - Returns: `Self`
    @discardableResult
    func prefersLargeTitles(_ large: Bool) -> Self {
        base.prefersLargeTitles = large
        return self
    }

    /// 标题字体
    /// - Parameter font: 标题字体
    /// - Returns: `Self`
    @discardableResult
    func titleFont(_ font: UIFont) -> Self {
        let appearance = base.standardAppearance
        appearance.titleTextAttributes[.font] = font
        base.standardAppearance = appearance
        return self
    }

    /// 大标题字体
    /// - Parameter font: 大标题字体
    /// - Returns: `Self`
    @discardableResult
    func largeTitleFont(_ font: UIFont) -> Self {
        let appearance = base.standardAppearance
        appearance.largeTitleTextAttributes[.font] = font
        base.standardAppearance = appearance
        return self
    }

    /// 标题颜色
    /// - Parameter color: 标题颜色
    /// - Returns: `Self`
    @discardableResult
    func titleColor(_ color: UIColor?) -> Self {
        let appearance = base.standardAppearance
        appearance.titleTextAttributes[.foregroundColor] = color
        base.standardAppearance = appearance
        return self
    }

    /// 大标题颜色
    /// - Parameter color: 大标题颜色
    /// - Returns: `Self`
    @discardableResult
    func largeTitleColor(_ color: UIColor?) -> Self {
        let appearance = base.standardAppearance
        appearance.largeTitleTextAttributes[.foregroundColor] = color
        base.standardAppearance = appearance
        return self
    }

    /// 导航栏的 `barTintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func barTintColor(_ color: UIColor?) -> Self {
        base.barTintColor = color
        return self
    }

    /// 导航栏的背景颜色
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

    /// 导航栏的背景图片
    /// - Parameter image: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ image: UIImage?) -> Self {
        let appearance = base.standardAppearance
        appearance.backgroundImage = image
        appearance.backgroundEffect = nil
        base.standardAppearance = appearance
        return self
    }

    /// 导航栏的阴影图片
    /// - Parameter image: 阴影图片
    /// - Returns: `Self`
    @discardableResult
    func shadowImage(_ image: UIImage?) -> Self {
        let appearance = base.standardAppearance
        appearance.shadowImage = image?.withRenderingMode(.alwaysOriginal)
        base.standardAppearance = appearance
        return self
    }

    /// 导航栏的阴影颜色
    /// - Parameter color: 阴影颜色
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

    /// 滚动到边缘时的独立外观(`scrollEdgeAppearance`)
    /// - Parameter appearance: 目标外观
    /// - Returns: `Self`
    @discardableResult
    func scrollEdgeAppearance(_ appearance: UINavigationBarAppearance) -> Self {
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 导航栏标题的文本属性
    /// - Parameter attributes: 富文本属性
    /// - Returns: `Self`
    @discardableResult
    func titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        let appearance = base.standardAppearance
        appearance.titleTextAttributes = attributes
        base.standardAppearance = appearance
        return self
    }

    /// 导航栏样式
    /// - Parameter barStyle: 要设置的导航栏样式
    /// - Returns: `Self`
    @discardableResult
    func barStyle(_ barStyle: UIBarStyle) -> Self {
        base.barStyle = barStyle
        return self
    }

    /// 导航栏代理
    /// - Parameter delegate: 遵循 `UINavigationBarDelegate` 的对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UINavigationBarDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 导航项数组
    /// - Parameter items: 元素数组
    /// - Returns: `Self`
    @discardableResult
    func items(_ items: [UINavigationItem]?) -> Self {
        base.items = items
        return self
    }

    /// 大标题的文本属性
    ///
    /// 经 `standardAppearance` 写入,传空字典即清空
    /// - Parameter attributes: 属性字典
    /// - Returns: `Self`
    @discardableResult
    func largeTitleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        let appearance = base.standardAppearance
        appearance.largeTitleTextAttributes = attributes
        base.standardAppearance = appearance
        return self
    }

    /// 首选行为样式
    /// - Parameter preferredBehavioralStyle: 要设置的首选行为样式
    /// - Returns: `Self`
    @discardableResult
    func preferredBehavioralStyle(_ preferredBehavioralStyle: UIBehavioralStyle) -> Self {
        base.preferredBehavioralStyle = preferredBehavioralStyle
        return self
    }

    /// 默认外观(`standardAppearance`)
    /// - Parameter appearance: 外观配置
    /// - Returns: `Self`
    @discardableResult
    func standardAppearance(_ appearance: UINavigationBarAppearance) -> Self {
        base.standardAppearance = appearance
        return self
    }

    /// 紧凑高度下的外观(`compactAppearance`)
    /// - Parameter appearance: 目标外观,传 `nil` 回退到 `standardAppearance`
    /// - Returns: `Self`
    @discardableResult
    func compactAppearance(_ appearance: UINavigationBarAppearance?) -> Self {
        base.compactAppearance = appearance
        return self
    }

    /// 紧凑高度且滚动到边缘时的外观(`compactScrollEdgeAppearance`)
    /// - Parameter appearance: 目标外观,传 `nil` 依次回退到 `scrollEdgeAppearance` / `compactAppearance`
    /// - Returns: `Self`
    @discardableResult
    func compactScrollEdgeAppearance(_ appearance: UINavigationBarAppearance?) -> Self {
        base.compactScrollEdgeAppearance = appearance
        return self
    }

    /// 返回按钮的指示图片
    /// - Parameter image: 指示图片,传 `nil` 使用系统默认
    /// - Returns: `Self`
    @discardableResult
    func backIndicatorImage(_ image: UIImage?) -> Self {
        base.backIndicatorImage = image
        return self
    }

    /// 返回按钮指示图片的转场遮罩
    /// - Parameter image: 遮罩图片,传 `nil` 使用系统默认
    /// - Returns: `Self`
    @discardableResult
    func backIndicatorTransitionMaskImage(_ image: UIImage?) -> Self {
        base.backIndicatorTransitionMaskImage = image
        return self
    }
}
