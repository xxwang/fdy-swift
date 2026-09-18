import UIKit

// MARK: - 命名空间入口
//
// `UIContentUnavailableConfiguration` 在 Swift 侧是 **struct**,**不继承** `extension NSObject: FdyExtension`,
// 必须单独补一条 conformance,否则本文件全部链式方法对外不可达。
extension UIContentUnavailableConfiguration: FdyExtension {}

// MARK: - 链式设置属性
//
// - Note: 值类型语义 —— 链式改的是 `.fdy` 持有的一份**拷贝**,需以 `build()` 取回:
//   ```swift
//   let empty = UIContentUnavailableConfiguration.empty().fdy
//       .image(UIImage(systemName: "tray"))
//       .text("暂无内容")
//       .build()
//   ```
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 设置主图标
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 设置主文本
    @discardableResult
    func text(_ text: String?) -> Self {
        base.text = text
        return self
    }

    /// 设置主文本(属性字符串)
    ///
    /// - Note: 与 ``text(_:)`` 是同一属性的两种载体,后设者赢(与列表内容配置同机制)。
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString?) -> Self {
        base.attributedText = attributedText
        return self
    }

    /// 设置副文本
    @discardableResult
    func secondaryText(_ secondaryText: String?) -> Self {
        base.secondaryText = secondaryText
        return self
    }

    /// 设置副文本(属性字符串)
    @discardableResult
    func secondaryAttributedText(_ secondaryAttributedText: NSAttributedString?) -> Self {
        base.secondaryAttributedText = secondaryAttributedText
        return self
    }

    /// 设置主按钮配置
    @discardableResult
    func button(_ button: UIButton.Configuration) -> Self {
        base.button = button
        return self
    }

    /// 设置副按钮配置
    @discardableResult
    func secondaryButton(_ secondaryButton: UIButton.Configuration) -> Self {
        base.secondaryButton = secondaryButton
        return self
    }

    /// 设置图标与文本的整体对齐方式
    @discardableResult
    func alignment(_ alignment: UIContentUnavailableConfiguration.Alignment) -> Self {
        base.alignment = alignment
        return self
    }

    /// 设置是否保留父视图的 `layoutMargins` 轴
    @discardableResult
    func axesPreservingSuperviewLayoutMargins(_ axesPreservingSuperviewLayoutMargins: UIAxis) -> Self {
        base.axesPreservingSuperviewLayoutMargins = axesPreservingSuperviewLayoutMargins
        return self
    }

    /// 设置内容四周的布局边距
    @discardableResult
    func directionalLayoutMargins(_ directionalLayoutMargins: NSDirectionalEdgeInsets) -> Self {
        base.directionalLayoutMargins = directionalLayoutMargins
        return self
    }

    /// 设置图标与文本的间距
    @discardableResult
    func imageToTextPadding(_ imageToTextPadding: CGFloat) -> Self {
        base.imageToTextPadding = imageToTextPadding
        return self
    }

    /// 设置主文本与副文本的间距
    @discardableResult
    func textToSecondaryTextPadding(_ textToSecondaryTextPadding: CGFloat) -> Self {
        base.textToSecondaryTextPadding = textToSecondaryTextPadding
        return self
    }

    /// 设置文本与主按钮的间距
    @discardableResult
    func textToButtonPadding(_ textToButtonPadding: CGFloat) -> Self {
        base.textToButtonPadding = textToButtonPadding
        return self
    }

    /// 设置主按钮与副按钮的间距
    @discardableResult
    func buttonToSecondaryButtonPadding(_ buttonToSecondaryButtonPadding: CGFloat) -> Self {
        base.buttonToSecondaryButtonPadding = buttonToSecondaryButtonPadding
        return self
    }

    /// 设置整体背景配置
    ///
    /// - Note: 值类型赋入,`UIBackgroundConfiguration` 的链式写法见
    ///   `UIBackgroundConfiguration+Chain.swift`。
    @discardableResult
    func background(_ background: UIBackgroundConfiguration) -> Self {
        base.background = background
        return self
    }
}

// MARK: - 图像轴
//
// `imageProperties` 是嵌套 struct,按本库既有约定**拍平**成前缀方法。
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 设置图标的符号配置(字号、粗细、缩放等)
    @discardableResult
    func imagePreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?) -> Self {
        updateImageProperties { $0.preferredSymbolConfiguration = configuration }
    }

    /// 设置图标着色
    @discardableResult
    func imageTintColor(_ tintColor: UIColor?) -> Self {
        updateImageProperties { $0.tintColor = tintColor }
    }

    /// 设置图标圆角
    @discardableResult
    func imageCornerRadius(_ cornerRadius: CGFloat) -> Self {
        updateImageProperties { $0.cornerRadius = cornerRadius }
    }

    /// 设置图标最大尺寸
    @discardableResult
    func imageMaximumSize(_ maximumSize: CGSize) -> Self {
        updateImageProperties { $0.maximumSize = maximumSize }
    }

    /// 设置图标是否忽略「智能反转」
    @discardableResult
    func imageAccessibilityIgnoresInvertColors(_ ignores: Bool) -> Self {
        updateImageProperties { $0.accessibilityIgnoresInvertColors = ignores }
    }
}

// MARK: - 主文本轴
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 设置主文本字体
    @discardableResult
    func textFont(_ font: UIFont) -> Self {
        updateTextProperties(\.textProperties) { $0.font = font }
    }

    /// 设置主文本颜色
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        updateTextProperties(\.textProperties) { $0.color = color }
    }

    /// 设置主文本换行模式
    @discardableResult
    func textLineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        updateTextProperties(\.textProperties) { $0.lineBreakMode = lineBreakMode }
    }

    /// 设置主文本最大行数
    @discardableResult
    func textNumberOfLines(_ numberOfLines: Int) -> Self {
        updateTextProperties(\.textProperties) { $0.numberOfLines = numberOfLines }
    }

    /// 设置主文本是否自动缩放以适配宽度
    @discardableResult
    func textAdjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        updateTextProperties(\.textProperties) { $0.adjustsFontSizeToFitWidth = adjusts }
    }

    /// 设置主文本自动缩放的**最小**缩放系数
    @discardableResult
    func textMinimumScaleFactor(_ minimumScaleFactor: CGFloat) -> Self {
        updateTextProperties(\.textProperties) { $0.minimumScaleFactor = minimumScaleFactor }
    }

    /// 设置主文本截断时是否允许系统收紧字距
    @discardableResult
    func textAllowsDefaultTighteningForTruncation(_ allows: Bool) -> Self {
        updateTextProperties(\.textProperties) { $0.allowsDefaultTighteningForTruncation = allows }
    }
}

// MARK: - 副文本轴
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 设置副文本字体
    @discardableResult
    func secondaryTextFont(_ font: UIFont) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.font = font }
    }

    /// 设置副文本颜色
    @discardableResult
    func secondaryTextColor(_ color: UIColor) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.color = color }
    }

    /// 设置副文本换行模式
    @discardableResult
    func secondaryTextLineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.lineBreakMode = lineBreakMode }
    }

    /// 设置副文本最大行数
    @discardableResult
    func secondaryTextNumberOfLines(_ numberOfLines: Int) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.numberOfLines = numberOfLines }
    }

    /// 设置副文本是否自动缩放以适配宽度
    @discardableResult
    func secondaryTextAdjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.adjustsFontSizeToFitWidth = adjusts }
    }

    /// 设置副文本自动缩放的**最小**缩放系数
    @discardableResult
    func secondaryTextMinimumScaleFactor(_ minimumScaleFactor: CGFloat) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.minimumScaleFactor = minimumScaleFactor }
    }

    /// 设置副文本截断时是否允许系统收紧字距
    @discardableResult
    func secondaryTextAllowsDefaultTighteningForTruncation(_ allows: Bool) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.allowsDefaultTighteningForTruncation = allows }
    }
}

// MARK: - 主按钮轴
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 设置主按钮的触发动作
    @discardableResult
    func buttonPrimaryAction(_ primaryAction: UIAction?) -> Self {
        updateButtonProperties(\.buttonProperties) { $0.primaryAction = primaryAction }
    }

    /// 设置主按钮的下拉菜单
    @discardableResult
    func buttonMenu(_ menu: UIMenu?) -> Self {
        updateButtonProperties(\.buttonProperties) { $0.menu = menu }
    }

    /// 设置主按钮是否可点
    @discardableResult
    func buttonIsEnabled(_ isEnabled: Bool) -> Self {
        updateButtonProperties(\.buttonProperties) { $0.isEnabled = isEnabled }
    }

    /// 设置主按钮的角色(影响系统配色,如 `.destructive`)
    @discardableResult
    func buttonRole(_ role: UIButton.Role) -> Self {
        updateButtonProperties(\.buttonProperties) { $0.role = role }
    }
}

// MARK: - 副按钮轴
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 设置副按钮的触发动作
    @discardableResult
    func secondaryButtonPrimaryAction(_ primaryAction: UIAction?) -> Self {
        updateButtonProperties(\.secondaryButtonProperties) { $0.primaryAction = primaryAction }
    }

    /// 设置副按钮的下拉菜单
    @discardableResult
    func secondaryButtonMenu(_ menu: UIMenu?) -> Self {
        updateButtonProperties(\.secondaryButtonProperties) { $0.menu = menu }
    }

    /// 设置副按钮是否可点
    @discardableResult
    func secondaryButtonIsEnabled(_ isEnabled: Bool) -> Self {
        updateButtonProperties(\.secondaryButtonProperties) { $0.isEnabled = isEnabled }
    }

    /// 设置副按钮的角色(影响系统配色,如 `.destructive`)
    @discardableResult
    func secondaryButtonRole(_ role: UIButton.Role) -> Self {
        updateButtonProperties(\.secondaryButtonProperties) { $0.role = role }
    }
}

// MARK: - 方法
public extension FdyWrapper where Base == UIContentUnavailableConfiguration {
    /// 按给定配置状态换算出一份**已应用状态默认值**的配置并替换当前值
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
    /// - Returns: `Self`
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
    ///   - keyPath: 目标文本属性轴
    ///   - mutate: 接收 `inout` 文本属性对象的闭包
    /// - Returns: `Self`
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
    ///   - keyPath: 目标按钮属性轴
    ///   - mutate: 接收 `inout` 按钮属性对象的闭包
    /// - Returns: `Self`
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
