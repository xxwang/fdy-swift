import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UILabel {
    /// 文字内容
    /// - Parameter text: 文字内容
    /// - Returns: `Self`
    @discardableResult
    func text(_ text: String?) -> Self {
        base.text = text
        return self
    }

    /// 富文本文字
    /// - Parameter attributedText: 富文本文字
    /// - Returns: `Self`
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString?) -> Self {
        base.attributedText = attributedText
        return self
    }

    /// 文字行数
    /// - Parameter lines: 行数
    /// - Returns: `Self`
    @discardableResult
    func numberOfLines(_ lines: Int) -> Self {
        base.numberOfLines = lines
        return self
    }

    /// 换行模式
    /// - Parameter mode: 换行模式
    /// - Returns: `Self`
    @discardableResult
    func lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        base.lineBreakMode = mode
        return self
    }

    /// 文字对齐方式
    /// - Parameter alignment: 文字对齐方式
    /// - Returns: `Self`
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        base.textAlignment = alignment
        return self
    }

    /// 文本颜色
    /// - Parameter color: 文字颜色
    /// - Returns: `Self`
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        base.textColor = color
        return self
    }

    /// 文本高亮颜色
    /// - Parameter color: 高亮文字颜色
    /// - Returns: `Self`
    @discardableResult
    func highlightedTextColor(_ color: UIColor) -> Self {
        base.highlightedTextColor = color
        return self
    }

    /// 字体
    /// - Parameter font: 字体大小
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        base.font = font
        return self
    }

    /// 是否调整字体大小以适配宽度
    /// - Parameter adjusts: 是否调整字体大小
    /// - Returns: `Self`
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        base.adjustsFontSizeToFitWidth = adjusts
        return self
    }

    /// 是否响应系统字体大小(动态字体需要开启)
    /// - Parameter adjustsFontForContentSizeCategory: 是否响应系统字体大小
    /// - Returns: `Self`
    @discardableResult
    func adjustsFontForContentSizeCategory(_ adjustsFontForContentSizeCategory: Bool) -> Self {
        base.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        return self
    }

    /// 文本布局的最大宽度
    /// - Parameter width: 宽度
    /// - Returns: `Self`
    @discardableResult
    func preferredMaxLayoutWidth(_ width: CGFloat) -> Self {
        base.preferredMaxLayoutWidth = width
        return self
    }

    /// 字号自动缩放的最小比例(取值 `(0, 1]`)
    /// - Parameter scale: 最小缩放因子,取值范围 (0, 1]
    /// - Returns: `Self`
    @discardableResult
    func minimumScaleFactor(_ scale: CGFloat) -> Self {
        base.minimumScaleFactor = scale
        return self
    }

    /// 高亮状态
    /// - Parameter highlighted: 是否高亮
    /// - Returns: `Self`
    @discardableResult
    func isHighlighted(_ highlighted: Bool) -> Self {
        base.isHighlighted = highlighted
        return self
    }

    /// 文本阴影颜色(区别于 `UIView` 的图层阴影 `shadowColor`)
    /// - Parameter color: 阴影颜色
    /// - Returns: `Self`
    @discardableResult
    func textShadowColor(_ color: UIColor) -> Self {
        base.shadowColor = color
        return self
    }

    /// 文本阴影偏移(区别于 `UIView` 的图层阴影 `shadowOffset`)
    /// - Parameter offset: 阴影偏移量
    /// - Returns: `Self`
    @discardableResult
    func textShadowOffset(_ offset: CGSize) -> Self {
        base.shadowOffset = offset
        return self
    }

    /// 基线调整模式
    /// - Parameter adjustment: 基线调整模式
    /// - Returns: `Self`
    @discardableResult
    func baselineAdjustment(_ adjustment: UIBaselineAdjustment) -> Self {
        base.baselineAdjustment = adjustment
        return self
    }
}

// MARK: - 链式设置属性(自定义)
public extension FdyWrapper where Base: UILabel {
    /// 特定范围的字体
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 设置字体的文本范围
    /// - Returns: `Self`
    @discardableResult
    func attributedFont(_ font: UIFont, for range: NSRange) -> Self {
        base.attributedText = base.attributedText?
            .fdy
            .toMutable()
            .font(font, for: range)
            .build()
        return self
    }

    /// 特定区域的文字颜色
    ///
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - range: 设置颜色的文本范围
    /// - Returns: `Self`
    @discardableResult
    func attributedColor(_ color: UIColor, for range: NSRange) -> Self {
        base.attributedText = base.attributedText?
            .fdy
            .toMutable()
            .foregroundColor(color, for: range)
            .build()
        return self
    }

    /// 行间距
    ///
    /// - Parameter spacing: 行间距
    /// - Returns: `Self`
    @discardableResult
    func lineSpacing(_ spacing: CGFloat) -> Self {
        base.attributedText = base.attributedText?
            .fdy
            .toMutable()
            .lineSpacing(spacing, for: (base.text ?? "").fdy_fullNSRange)
            .build()
        return self
    }

    /// 字间距
    ///
    /// - Parameter spacing: 字间距
    /// - Returns: `Self`
    @discardableResult
    func wordSpacing(_ spacing: CGFloat) -> Self {
        base.attributedText = base.attributedText?
            .fdy
            .toMutable()
            .characterSpacing(spacing, for: base.text?.fdy_fullNSRange)
            .build()
        return self
    }

    /// 特定范围的下划线(样式默认为 `.single`)
    ///
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - style: 下划线样式(默认`.single`)
    ///   - range: 设置下划线的文本范围
    /// - Returns: `Self`
    @discardableResult
    func attributedUnderLine(
        _ color: UIColor,
        style: NSUnderlineStyle = .single,
        for range: NSRange
    ) -> Self {
        base.attributedText = base.attributedText?
            .fdy
            .toMutable()
            .underline(color: color, style: style, for: range)
            .build()
        return self
    }

    /// 特定范围的删除线
    ///
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - range: 设置删除线的文本范围
    /// - Returns: `Self`
    @discardableResult
    func attributedDeleteLine(_ color: UIColor, for range: NSRange) -> Self {
        base.attributedText = base.attributedText?
            .fdy
            .toMutable()
            .strikethrough(color: color, for: range)
            .build()
        return self
    }

    /// 首行缩进
    ///
    /// - Parameter indent: 首行缩进的宽度
    /// - Returns: `Self`
    @discardableResult
    func attributedFirstLineHeadIndent(_ indent: CGFloat) -> Self {
        base.attributedText = base.attributedText?
            .fdy
            .toMutable()
            .firstLineHeadIndent(indent)
            .build()
        return self
    }

    /// 特定范围的倾斜效果
    ///
    /// - Parameters:
    ///   - inclination: 倾斜度
    ///   - range: 设置倾斜效果的文本范围
    /// - Returns: `Self`
    @discardableResult
    func attributedObliqueness(_ inclination: Float = 0, for range: NSRange) -> Self {
        base.attributedText = base.attributedText?
            .fdy
            .toMutable()
            .obliqueness(inclination, for: range)
            .build()
        return self
    }

    /// 往字符串中插入图片(属性字符串)
    /// - Parameters:
    ///   - image: 要插入的图片对象若为 `nil`,则不执行任何操作
    ///   - bounds: 图片的显示区域(相对于文本基线)若为 `.zero`,将自动根据字体大小垂直居中对齐
    ///   - index: 插入位置(UTF-16 索引,默认为 0,即开头)
    /// - Returns: `Self`
    @discardableResult
    func attachment(
        _ image: UIImage?,
        bounds: CGRect = .zero,
        at index: Int = 0
    ) -> Self {
        base.attributedText = base.attributedText?
            .fdy
            .toMutable()
            .attachment(image, bounds: bounds, at: index)
            .build()
        return self
    }

    /// 断行策略
    /// - Parameter lineBreakStrategy: 要设置的断行策略
    /// - Returns: `Self`
    @discardableResult
    func lineBreakStrategy(_ lineBreakStrategy: NSParagraphStyle.LineBreakStrategy) -> Self {
        base.lineBreakStrategy = lineBreakStrategy
        return self
    }

    /// 活力效果(vibrancy)
    /// - Parameter preferredVibrancy: 首选鲜艳度
    /// - Returns: `Self`
    @discardableResult
    func preferredVibrancy(_ preferredVibrancy: UILabelVibrancy) -> Self {
        base.preferredVibrancy = preferredVibrancy
        return self
    }

    /// 截断时是否允许展开显示完整文本(macCatalyst 生效)
    /// - Parameter showsExpansionTextWhenTruncated: 截断时是否显示展开提示
    /// - Returns: `Self`
    @discardableResult
    func showsExpansionTextWhenTruncated(_ showsExpansionTextWhenTruncated: Bool) -> Self {
        base.showsExpansionTextWhenTruncated = showsExpansionTextWhenTruncated
        return self
    }
}
