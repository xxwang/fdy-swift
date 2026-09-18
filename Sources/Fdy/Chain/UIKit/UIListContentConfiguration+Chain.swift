import UIKit

// MARK: - 命名空间入口
//
// `UIListContentConfiguration` 在 Swift 侧是 **struct**,**不继承** `extension NSObject: FdyExtension`,
// 必须单独补一条 conformance,否则本文件全部链式方法对外不可达。
extension UIListContentConfiguration: FdyExtension {}

// MARK: - 链式设置属性
//
// - Note: 值类型语义 —— 链式改的是 `.fdy` 持有的一份**拷贝**,需以 `build()` 取回:
//   ```swift
//   let content = UIListContentConfiguration.subtitleCell().fdy
//       .text("标题")
//       .secondaryText("副标题")
//       .textFont(.boldSystemFont(ofSize: 17))
//       .build()
//   ```
public extension FdyWrapper where Base == UIListContentConfiguration {
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
    /// - Note: 与 ``text(_:)`` 是**同一个属性的两种载体**,后设者赢。
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

    /// 设置主/副文本是否并排显示
    @discardableResult
    func prefersSideBySideTextAndSecondaryText(
        _ prefersSideBySideTextAndSecondaryText: Bool
    ) -> Self {
        base.prefersSideBySideTextAndSecondaryText = prefersSideBySideTextAndSecondaryText
        return self
    }

    /// 设置图标与文本的间距
    @discardableResult
    func imageToTextPadding(_ imageToTextPadding: CGFloat) -> Self {
        base.imageToTextPadding = imageToTextPadding
        return self
    }

    /// 设置主/副文本**横排**时的间距
    @discardableResult
    func textToSecondaryTextHorizontalPadding(_ textToSecondaryTextHorizontalPadding: CGFloat) -> Self {
        base.textToSecondaryTextHorizontalPadding = textToSecondaryTextHorizontalPadding
        return self
    }

    /// 设置主/副文本**竖排**时的间距
    @discardableResult
    func textToSecondaryTextVerticalPadding(_ textToSecondaryTextVerticalPadding: CGFloat) -> Self {
        base.textToSecondaryTextVerticalPadding = textToSecondaryTextVerticalPadding
        return self
    }

    /// 设置整体不透明度
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }
}

// MARK: - 图像轴
//
// `imageProperties` 是嵌套 struct,按本库既有约定**拍平**成前缀方法
// (先例:`UIButton.Configuration+Chain.swift` 的 `imageColorTransformer` / `imagePadding`)。
public extension FdyWrapper where Base == UIListContentConfiguration {
    /// 设置图标的符号配置(字号、粗细、缩放等)
    @discardableResult
    func imagePreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?) -> Self {
        updateImageProperties { $0.preferredSymbolConfiguration = configuration }
    }

    /// 设置图标着色
    ///
    /// - Note: 传 `nil` 表示取默认派生色;非模板图不受影响。
    @discardableResult
    func imageTintColor(_ tintColor: UIColor?) -> Self {
        updateImageProperties { $0.tintColor = tintColor }
    }

    /// 设置图标着色变换器
    @discardableResult
    func imageTintColorTransformer(_ transformer: UIConfigurationColorTransformer?) -> Self {
        updateImageProperties { $0.tintColorTransformer = transformer }
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

    /// 设置图标预留的布局尺寸
    ///
    /// - Note: 与 ``imageMaximumSize(_:)`` 不同 —— 这个是**参与布局**的占位尺寸,用于让不同尺寸的
    ///   图标在列表里左右对齐。
    @discardableResult
    func imageReservedLayoutSize(_ reservedLayoutSize: CGSize) -> Self {
        updateImageProperties { $0.reservedLayoutSize = reservedLayoutSize }
    }

    /// 设置图标是否忽略「智能反转」
    @discardableResult
    func imageAccessibilityIgnoresInvertColors(_ ignores: Bool) -> Self {
        updateImageProperties { $0.accessibilityIgnoresInvertColors = ignores }
    }

    /// 设置图标描边色(`iOS 18` 起,本包最低版本即 18,故无需可用性标注)
    @discardableResult
    func imageStrokeColor(_ strokeColor: UIColor?) -> Self {
        updateImageProperties { $0.strokeColor = strokeColor }
    }

    /// 设置图标描边色变换器
    @discardableResult
    func imageStrokeColorTransformer(_ transformer: UIConfigurationColorTransformer?) -> Self {
        updateImageProperties { $0.strokeColorTransformer = transformer }
    }

    /// 设置图标描边宽度
    @discardableResult
    func imageStrokeWidth(_ strokeWidth: CGFloat) -> Self {
        updateImageProperties { $0.strokeWidth = strokeWidth }
    }
}

// MARK: - 主文本轴
public extension FdyWrapper where Base == UIListContentConfiguration {
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

    /// 设置主文本颜色变换器
    @discardableResult
    func textColorTransformer(_ transformer: UIConfigurationColorTransformer?) -> Self {
        updateTextProperties(\.textProperties) { $0.colorTransformer = transformer }
    }

    /// 设置主文本对齐方式
    @discardableResult
    func textAlignment(_ alignment: UIListContentConfiguration.TextProperties.TextAlignment) -> Self {
        updateTextProperties(\.textProperties) { $0.alignment = alignment }
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

    /// 设置主文本是否跟随「内容尺寸」无障碍设置自动放大字号
    @discardableResult
    func textAdjustsFontForContentSizeCategory(_ adjusts: Bool) -> Self {
        updateTextProperties(\.textProperties) { $0.adjustsFontForContentSizeCategory = adjusts }
    }

    /// 设置主文本的大小写变换
    @discardableResult
    func textTransform(_ transform: UIListContentConfiguration.TextProperties.TextTransform) -> Self {
        updateTextProperties(\.textProperties) { $0.transform = transform }
    }
}

// MARK: - 副文本轴
public extension FdyWrapper where Base == UIListContentConfiguration {
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

    /// 设置副文本颜色变换器
    @discardableResult
    func secondaryTextColorTransformer(_ transformer: UIConfigurationColorTransformer?) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.colorTransformer = transformer }
    }

    /// 设置副文本对齐方式
    @discardableResult
    func secondaryTextAlignment(_ alignment: UIListContentConfiguration.TextProperties.TextAlignment) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.alignment = alignment }
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

    /// 设置副文本是否跟随「内容尺寸」无障碍设置自动放大字号
    @discardableResult
    func secondaryTextAdjustsFontForContentSizeCategory(_ adjusts: Bool) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.adjustsFontForContentSizeCategory = adjusts }
    }

    /// 设置副文本的大小写变换
    @discardableResult
    func secondaryTextTransform(_ transform: UIListContentConfiguration.TextProperties.TextTransform) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.transform = transform }
    }
}

// MARK: - 方法
public extension FdyWrapper where Base == UIListContentConfiguration {
    /// 按给定配置状态换算出一份**已应用状态默认值**的配置并替换当前值
    @discardableResult
    func updated(for state: any UIConfigurationState) -> Self {
        base = base.updated(for: state)
        return self
    }
}

// MARK: - 嵌套轴读写模板收敛
private extension FdyWrapper where Base == UIListContentConfiguration {
    /// 在 `imageProperties` 上做一次修改并写回
    /// - Parameter mutate: 接收 `inout` 图像属性对象的闭包
    /// - Returns: `Self`
    @discardableResult
    @inline(__always)
    func updateImageProperties(
        _ mutate: (inout UIListContentConfiguration.ImageProperties) -> Void
    ) -> Self {
        var properties = base.imageProperties
        mutate(&properties)
        base.imageProperties = properties
        return self
    }

    /// 在指定的文本属性轴上做一次修改并写回
    ///
    /// 主/副文本共用同一套 `TextProperties`,靠 `keyPath` 区分,避免写两份完全对称的模板。
    ///
    /// - Parameters:
    ///   - keyPath: 目标文本属性轴
    ///   - mutate: 接收 `inout` 文本属性对象的闭包
    /// - Returns: `Self`
    @discardableResult
    @inline(__always)
    func updateTextProperties(
        _ keyPath: WritableKeyPath<Base, UIListContentConfiguration.TextProperties>,
        _ mutate: (inout UIListContentConfiguration.TextProperties) -> Void
    ) -> Self {
        var properties = base[keyPath: keyPath]
        mutate(&properties)
        base[keyPath: keyPath] = properties
        return self
    }
}
