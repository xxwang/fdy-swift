import UIKit

// MARK: - 命名空间入口
extension UIListContentConfiguration: FdyExtension {}

// MARK: - 链式设置属性
public extension FdyWrapper where Base == UIListContentConfiguration {
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
    /// - Note: 与 ``text(_:)`` 是**同一个属性的两种载体**,后设者赢。
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

    /// 主/副文本是否并排显示
    /// - Parameter prefersSideBySideTextAndSecondaryText: 要设置的主/副文本是否并排显示
    /// - Returns: `Self`
    @discardableResult
    func prefersSideBySideTextAndSecondaryText(
        _ prefersSideBySideTextAndSecondaryText: Bool
    ) -> Self {
        base.prefersSideBySideTextAndSecondaryText = prefersSideBySideTextAndSecondaryText
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

    /// 主/副文本**横排**时的间距
    /// - Parameter textToSecondaryTextHorizontalPadding: 主次文本间的水平间距
    /// - Returns: `Self`
    @discardableResult
    func textToSecondaryTextHorizontalPadding(_ textToSecondaryTextHorizontalPadding: CGFloat) -> Self {
        base.textToSecondaryTextHorizontalPadding = textToSecondaryTextHorizontalPadding
        return self
    }

    /// 主/副文本**竖排**时的间距
    /// - Parameter textToSecondaryTextVerticalPadding: 主次文本间的垂直间距
    /// - Returns: `Self`
    @discardableResult
    func textToSecondaryTextVerticalPadding(_ textToSecondaryTextVerticalPadding: CGFloat) -> Self {
        base.textToSecondaryTextVerticalPadding = textToSecondaryTextVerticalPadding
        return self
    }

    /// 整体不透明度
    /// - Parameter alpha: 不透明度
    /// - Returns: `Self`
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }
}

// MARK: - 图像轴
// `imageProperties` 是嵌套 struct,按本库既有约定**拍平**成前缀方法
// (先例:`UIButton.Configuration+Chain.swift` 的 `imageColorTransformer` / `imagePadding`)。
public extension FdyWrapper where Base == UIListContentConfiguration {
    /// 图标的符号配置(字号、粗细、缩放等)
    /// - Parameter configuration: 配置
    /// - Returns: `Self`
    @discardableResult
    func imagePreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?) -> Self {
        updateImageProperties { $0.preferredSymbolConfiguration = configuration }
    }

    /// 图标着色
    ///
    /// - Parameter tintColor: 颜色
    /// - Returns: `Self`
    /// - Note: 传 `nil` 表示取默认派生色;非模板图不受影响。
    @discardableResult
    func imageTintColor(_ tintColor: UIColor?) -> Self {
        updateImageProperties { $0.tintColor = tintColor }
    }

    /// 图标着色变换器
    /// - Parameter transformer: 变换闭包
    /// - Returns: `Self`
    @discardableResult
    func imageTintColorTransformer(_ transformer: UIConfigurationColorTransformer?) -> Self {
        updateImageProperties { $0.tintColorTransformer = transformer }
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

    /// 图标预留的布局尺寸
    ///
    /// - Parameter reservedLayoutSize: 尺寸
    /// - Returns: `Self`
    /// - Note: 与 ``imageMaximumSize(_:)`` 不同 —— 这个是**参与布局**的占位尺寸,用于让不同尺寸的
    ///   图标在列表里左右对齐。
    @discardableResult
    func imageReservedLayoutSize(_ reservedLayoutSize: CGSize) -> Self {
        updateImageProperties { $0.reservedLayoutSize = reservedLayoutSize }
    }

    /// 图标是否忽略「智能反转」
    /// - Parameter ignores: 要设置的图标是否忽略「智能反转」
    /// - Returns: `Self`
    @discardableResult
    func imageAccessibilityIgnoresInvertColors(_ ignores: Bool) -> Self {
        updateImageProperties { $0.accessibilityIgnoresInvertColors = ignores }
    }

    /// 图标描边色(`iOS 18` 起,本包最低版本即 18,故无需可用性标注)
    /// - Parameter strokeColor: 颜色
    /// - Returns: `Self`
    @discardableResult
    func imageStrokeColor(_ strokeColor: UIColor?) -> Self {
        updateImageProperties { $0.strokeColor = strokeColor }
    }

    /// 图标描边色变换器
    /// - Parameter transformer: 变换闭包
    /// - Returns: `Self`
    @discardableResult
    func imageStrokeColorTransformer(_ transformer: UIConfigurationColorTransformer?) -> Self {
        updateImageProperties { $0.strokeColorTransformer = transformer }
    }

    /// 图标描边宽度
    /// - Parameter strokeWidth: 描边宽度
    /// - Returns: `Self`
    @discardableResult
    func imageStrokeWidth(_ strokeWidth: CGFloat) -> Self {
        updateImageProperties { $0.strokeWidth = strokeWidth }
    }
}

// MARK: - 主文本轴
public extension FdyWrapper where Base == UIListContentConfiguration {
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

    /// 主文本颜色变换器
    /// - Parameter transformer: 变换闭包
    /// - Returns: `Self`
    @discardableResult
    func textColorTransformer(_ transformer: UIConfigurationColorTransformer?) -> Self {
        updateTextProperties(\.textProperties) { $0.colorTransformer = transformer }
    }

    /// 主文本对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: `Self`
    @discardableResult
    func textAlignment(_ alignment: UIListContentConfiguration.TextProperties.TextAlignment) -> Self {
        updateTextProperties(\.textProperties) { $0.alignment = alignment }
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

    /// 主文本是否跟随「内容尺寸」无障碍设置自动放大字号
    /// - Parameter adjusts: 自适应开关
    /// - Returns: `Self`
    @discardableResult
    func textAdjustsFontForContentSizeCategory(_ adjusts: Bool) -> Self {
        updateTextProperties(\.textProperties) { $0.adjustsFontForContentSizeCategory = adjusts }
    }

    /// 主文本的大小写变换
    /// - Parameter transform: 要设置的主文本的大小写变换
    /// - Returns: `Self`
    @discardableResult
    func textTransform(_ transform: UIListContentConfiguration.TextProperties.TextTransform) -> Self {
        updateTextProperties(\.textProperties) { $0.transform = transform }
    }
}

// MARK: - 副文本轴
public extension FdyWrapper where Base == UIListContentConfiguration {
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

    /// 副文本颜色变换器
    /// - Parameter transformer: 变换闭包
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextColorTransformer(_ transformer: UIConfigurationColorTransformer?) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.colorTransformer = transformer }
    }

    /// 副文本对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextAlignment(_ alignment: UIListContentConfiguration.TextProperties.TextAlignment) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.alignment = alignment }
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

    /// 副文本是否跟随「内容尺寸」无障碍设置自动放大字号
    /// - Parameter adjusts: 自适应开关
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextAdjustsFontForContentSizeCategory(_ adjusts: Bool) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.adjustsFontForContentSizeCategory = adjusts }
    }

    /// 副文本的大小写变换
    /// - Parameter transform: 要设置的副文本的大小写变换
    /// - Returns: `Self`
    @discardableResult
    func secondaryTextTransform(_ transform: UIListContentConfiguration.TextProperties.TextTransform) -> Self {
        updateTextProperties(\.secondaryTextProperties) { $0.transform = transform }
    }
}

// MARK: - 方法
public extension FdyWrapper where Base == UIListContentConfiguration {
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
private extension FdyWrapper where Base == UIListContentConfiguration {
    /// 在 `imageProperties` 上做一次修改并写回
    /// - Parameter mutate: 接收 `inout` 图像属性对象的闭包
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
    ///   - mutate: 接收 `inout` 文本属性对象的闭包
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
