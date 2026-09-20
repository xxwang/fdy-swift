import UIKit

// MARK: - 命名空间入口
extension UIContentUnavailableConfiguration: FdyExtension {}

// MARK: - 链式设置属性
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 主图标
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 主文本
    /// - Parameter text: 文本
    /// - Returns: `Self`
    @discardableResult
    func text(_ text: String?) -> Self {
        base.text = text
        return self
    }

    /// 主文本(属性字符串)
    ///
    /// - Parameter attributedText: 富文本
    /// - Returns: `Self`
    /// - Note: 与 ``text(_:)`` 是同一属性的两种载体,后设者赢(与列表内容配置同机制)。
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString?) -> Self {
        base.attributedText = attributedText
        return self
    }

    /// 副文本
    /// - Parameter secondaryText: 要设置的副文本
    /// - Returns: `Self`
    @discardableResult
    func secondaryText(_ secondaryText: String?) -> Self {
        base.secondaryText = secondaryText
        return self
    }

    /// 副文本(属性字符串)
    /// - Parameter secondaryAttributedText: 富文本
    /// - Returns: `Self`
    @discardableResult
    func secondaryAttributedText(_ secondaryAttributedText: NSAttributedString?) -> Self {
        base.secondaryAttributedText = secondaryAttributedText
        return self
    }

    /// 主按钮配置
    /// - Parameter button: 要设置的主按钮配置
    /// - Returns: `Self`
    @discardableResult
    func button(_ button: UIButton.Configuration) -> Self {
        base.button = button
        return self
    }

    /// 副按钮配置
    /// - Parameter secondaryButton: 要设置的副按钮配置
    /// - Returns: `Self`
    @discardableResult
    func secondaryButton(_ secondaryButton: UIButton.Configuration) -> Self {
        base.secondaryButton = secondaryButton
        return self
    }

    /// 图标与文本的整体对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: `Self`
    @discardableResult
    func alignment(_ alignment: UIContentUnavailableConfiguration.Alignment) -> Self {
        base.alignment = alignment
        return self
    }

    /// 是否保留父视图的 `layoutMargins` 轴
    /// - Parameter axesPreservingSuperviewLayoutMargins: 保持父视图边距的轴向
    /// - Returns: `Self`
    @discardableResult
    func axesPreservingSuperviewLayoutMargins(_ axesPreservingSuperviewLayoutMargins: UIAxis) -> Self {
        base.axesPreservingSuperviewLayoutMargins = axesPreservingSuperviewLayoutMargins
        return self
    }

    /// 内容四周的布局边距
    /// - Parameter directionalLayoutMargins: 要设置的内容四周的布局边距
    /// - Returns: `Self`
    @discardableResult
    func directionalLayoutMargins(_ directionalLayoutMargins: NSDirectionalEdgeInsets) -> Self {
        base.directionalLayoutMargins = directionalLayoutMargins
        return self
    }

    /// 图标与文本的间距
    /// - Parameter imageToTextPadding: 要设置的图标与文本的间距
    /// - Returns: `Self`
    @discardableResult
    func imageToTextPadding(_ imageToTextPadding: CGFloat) -> Self {
        base.imageToTextPadding = imageToTextPadding
        return self
    }

    /// 主文本与副文本的间距
    /// - Parameter textToSecondaryTextPadding: 要设置的主文本与副文本的间距
    /// - Returns: `Self`
    @discardableResult
    func textToSecondaryTextPadding(_ textToSecondaryTextPadding: CGFloat) -> Self {
        base.textToSecondaryTextPadding = textToSecondaryTextPadding
        return self
    }

    /// 文本与主按钮的间距
    /// - Parameter textToButtonPadding: 要设置的文本与主按钮的间距
    /// - Returns: `Self`
    @discardableResult
    func textToButtonPadding(_ textToButtonPadding: CGFloat) -> Self {
        base.textToButtonPadding = textToButtonPadding
        return self
    }

    /// 主按钮与副按钮的间距
    /// - Parameter buttonToSecondaryButtonPadding: 要设置的主按钮与副按钮的间距
    /// - Returns: `Self`
    @discardableResult
    func buttonToSecondaryButtonPadding(_ buttonToSecondaryButtonPadding: CGFloat) -> Self {
        base.buttonToSecondaryButtonPadding = buttonToSecondaryButtonPadding
        return self
    }

    /// 整体背景配置
    ///
    /// - Parameter background: 要设置的整体背景配置
    /// - Returns: `Self`
    /// - Note: 值类型赋入,`UIBackgroundConfiguration` 的链式写法见
    ///   `UIBackgroundConfiguration+Chain.swift`。
    @discardableResult
    func background(_ background: UIBackgroundConfiguration) -> Self {
        base.background = background
        return self
    }
}

// MARK: - 图像轴
// `imageProperties` 是嵌套 struct,按本库既有约定**拍平**成前缀方法。
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 图标的符号配置(字号、粗细、缩放等)
    /// - Parameter configuration: 配置
    /// - Returns: `Self`
    @discardableResult
    func imagePreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?) -> Self {
        updateImageProperties { $0.preferredSymbolConfiguration = configuration }
    }

    /// 图标着色
    /// - Parameter tintColor: 颜色
    /// - Returns: `Self`
    @discardableResult
    func imageTintColor(_ tintColor: UIColor?) -> Self {
        updateImageProperties { $0.tintColor = tintColor }
    }

    /// 图标圆角
    /// - Parameter cornerRadius: 圆角半径
    /// - Returns: `Self`
    @discardableResult
    func imageCornerRadius(_ cornerRadius: CGFloat) -> Self {
        updateImageProperties { $0.cornerRadius = cornerRadius }
    }

    /// 图标最大尺寸
    /// - Parameter maximumSize: 尺寸
    /// - Returns: `Self`
    @discardableResult
    func imageMaximumSize(_ maximumSize: CGSize) -> Self {
        updateImageProperties { $0.maximumSize = maximumSize }
    }

    /// 图标是否忽略「智能反转」
    /// - Parameter ignores: 要设置的图标是否忽略「智能反转」
    /// - Returns: `Self`
    @discardableResult
    func imageAccessibilityIgnoresInvertColors(_ ignores: Bool) -> Self {
        updateImageProperties { $0.accessibilityIgnoresInvertColors = ignores }
    }
}

// MARK: - 主文本轴
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 主文本字体
    /// - Parameter font: 字体
    /// - Returns: `Self`
    @discardableResult
    func textFont(_ font: UIFont) -> Self {
        updateTextProperties(\.textProperties) { $0.font = font }
    }

    /// 主文本颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        updateTextProperties(\.textProperties) { $0.color = color }
    }

    /// 主文本换行模式
    /// - Parameter lineBreakMode: 换行模式
    /// - Returns: `Self`
    @discardableResult
    func textLineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        updateTextProperties(\.textProperties) { $0.lineBreakMode = lineBreakMode }
    }

    /// 主文本最大行数
    /// - Parameter numberOfLines: 行数
    /// - Returns: `Self`
    @discardableResult
    func textNumberOfLines(_ numberOfLines: Int) -> Self {
        updateTextProperties(\.textProperties) { $0.numberOfLines = numberOfLines }
    }

    /// 主文本是否自动缩放以适配宽度
    /// - Parameter adjusts: 自适应开关
    /// - Returns: `Self`
    @discardableResult
    func textAdjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        updateTextProperties(\.textProperties) { $0.adjustsFontSizeToFitWidth = adjusts }
    }

    /// 主文本自动缩放的**最小**缩放系数
    /// - Parameter minimumScaleFactor: 最小缩放比例
    /// - Returns: `Self`
    @discardableResult
    func textMinimumScaleFactor(_ minimumScaleFactor: CGFloat) -> Self {
        updateTextProperties(\.textProperties) { $0.minimumScaleFactor = minimumScaleFactor }
    }

    /// 主文本截断时是否允许系统收紧字距
    /// - Parameter allows: 是否允许
    /// - Returns: `Self`
    @discardableResult
    func textAllowsDefaultTighteningForTruncation(_ allows: Bool) -> Self {
        updateTextProperties(\.textProperties) { $0.allowsDefaultTighteningForTruncation = allows }
    }
}

// MARK: - 副文本轴
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 副文本字体
    /// - Parameter font: 字体
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextFont(_ font: UIFont) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.font = font }
    }

    /// 副文本颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextColor(_ color: UIColor) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.color = color }
    }

    /// 副文本换行模式
    /// - Parameter lineBreakMode: 换行模式
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextLineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.lineBreakMode = lineBreakMode }
    }

    /// 副文本最大行数
    /// - Parameter numberOfLines: 行数
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextNumberOfLines(_ numberOfLines: Int) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.numberOfLines = numberOfLines }
    }

    /// 副文本是否自动缩放以适配宽度
    /// - Parameter adjusts: 自适应开关
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextAdjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.adjustsFontSizeToFitWidth = adjusts }
    }

    /// 副文本自动缩放的**最小**缩放系数
    /// - Parameter minimumScaleFactor: 最小缩放比例
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextMinimumScaleFactor(_ minimumScaleFactor: CGFloat) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.minimumScaleFactor = minimumScaleFactor }
    }

    /// 副文本截断时是否允许系统收紧字距
    /// - Parameter allows: 是否允许
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextAllowsDefaultTighteningForTruncation(_ allows: Bool) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.allowsDefaultTighteningForTruncation = allows }
    }
}

// MARK: - 主按钮轴
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 主按钮的触发动作
    /// - Parameter primaryAction: 要设置的主按钮的触发动作
    /// - Returns: `Self`
    @discardableResult
    func buttonPrimaryAction(_ primaryAction: UIAction?) -> Self {
        updateButtonProperties(\.buttonProperties) { $0.primaryAction = primaryAction }
    }

    /// 主按钮的下拉菜单
    /// - Parameter menu: 要设置的主按钮的下拉菜单
    /// - Returns: `Self`
    @discardableResult
    func buttonMenu(_ menu: UIMenu?) -> Self {
        updateButtonProperties(\.buttonProperties) { $0.menu = menu }
    }

    /// 主按钮是否可点
    /// - Parameter isEnabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func buttonIsEnabled(_ isEnabled: Bool) -> Self {
        updateButtonProperties(\.buttonProperties) { $0.isEnabled = isEnabled }
    }

    /// 主按钮的角色(影响系统配色,如 `.destructive`)
    /// - Parameter role: 角色
    /// - Returns: `Self`
    @discardableResult
    func buttonRole(_ role: UIButton.Role) -> Self {
        updateButtonProperties(\.buttonProperties) { $0.role = role }
    }
}

// MARK: - 副按钮轴
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 副按钮的触发动作
    /// - Parameter primaryAction: 要设置的副按钮的触发动作
    /// - Returns: `Self`
    @discardableResult
    func secondaryButtonPrimaryAction(_ primaryAction: UIAction?) -> Self {
        updateButtonProperties(\.secondaryButtonProperties) { $0.primaryAction = primaryAction }
    }

    /// 副按钮的下拉菜单
    /// - Parameter menu: 要设置的副按钮的下拉菜单
    /// - Returns: `Self`
    @discardableResult
    func secondaryButtonMenu(_ menu: UIMenu?) -> Self {
        updateButtonProperties(\.secondaryButtonProperties) { $0.menu = menu }
    }

    /// 副按钮是否可点
    /// - Parameter isEnabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func secondaryButtonIsEnabled(_ isEnabled: Bool) -> Self {
        updateButtonProperties(\.secondaryButtonProperties) { $0.isEnabled = isEnabled }
    }

    /// 副按钮的角色(影响系统配色,如 `.destructive`)
    /// - Parameter role: 角色
    /// - Returns: `Self`
    @discardableResult
    func secondaryButtonRole(_ role: UIButton.Role) -> Self {
        updateButtonProperties(\.secondaryButtonProperties) { $0.role = role }
    }
}

// MARK: - 方法
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 按给定配置状态换算出一份**已应用状态默认值**的配置并替换当前值
    /// - Parameter state: 状态
    /// - Returns: `Self`
    @discardableResult
    func updated(for state: any UIConfigurationState) -> Self {
        base = base.updated(for: state)
        return self
    }
}

// MARK: - 嵌套轴读写模板收敛
private extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 在 `imageProperties` 上做一次修改并写回
    /// - Parameter mutate: 接收 `inout` 图像属性对象的闭包
    @discardableResult
    @inline(__always)
    func updateImageProperties(
        _ mutate: (inout UIContentUnavailableConfiguration.ImageProperties) -> Void
    ) -> Self {
        var properties = base.imageProperties
        mutate(&properties)
        base.imageProperties = properties
        return self
    }

    /// 在指定的文本属性轴上做一次修改并写回
    ///
    /// 主/副文本共用同一套 `TextProperties`,靠 `keyPath` 区分。
    ///
    /// - Parameters:
    ///   - mutate: 接收 `inout` 文本属性对象的闭包
    @discardableResult
    @inline(__always)
    func updateTextProperties(
        _ keyPath: WritableKeyPath<Base, UIContentUnavailableConfiguration.TextProperties>,
        _ mutate: (inout UIContentUnavailableConfiguration.TextProperties) -> Void
    ) -> Self {
        var properties = base[keyPath: keyPath]
        mutate(&properties)
        base[keyPath: keyPath] = properties
        return self
    }

    /// 在指定的按钮属性轴上做一次修改并写回
    ///
    /// 主/副按钮共用同一套 `ButtonProperties`,靠 `keyPath` 区分。
    ///
    /// - Parameters:
    ///   - mutate: 接收 `inout` 按钮属性对象的闭包
    @discardableResult
    @inline(__always)
    func updateButtonProperties(
        _ keyPath: WritableKeyPath<Base, UIContentUnavailableConfiguration.ButtonProperties>,
        _ mutate: (inout UIContentUnavailableConfiguration.ButtonProperties) -> Void
    ) -> Self {
        var properties = base[keyPath: keyPath]
        mutate(&properties)
        base[keyPath: keyPath] = properties
        return self
    }
}
