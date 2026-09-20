import UIKit

// MARK: - UIView
public extension UIView {
    /// 创建 `UIView`
    /// - Parameters:
    ///   - backgroundColor: 背景颜色,默认 `.clear`
    ///   - cornerRadius: 圆角半径,默认 `0`
    ///   - maskedCorners: 要应用圆角的角,默认四角全开(`.fdy_all`)
    ///   - cornerCurve: 圆角曲线,默认 `.circular`;产品里常改用 `.continuous`(连续曲率)
    /// - Returns: `UIView`
    static func fdy_view(
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 0,
        maskedCorners: CACornerMask = .fdy_all,
        cornerCurve: CALayerCornerCurve = .circular
    ) -> UIView {
        UIView.view()
            .fdy
            .backgroundColor(backgroundColor)
            .cornerRadius(cornerRadius)
            .maskedCorners(maskedCorners)
            .cornerCurve(cornerCurve)
            .masksToBounds(true)
            .build()
    }
}

// MARK: - UILabel
public extension UILabel {
    /// 创建 `UILabel`
    /// - Parameters:
    ///   - text: 文本,默认空串
    ///   - textColor: 文本颜色,默认 `.label`
    ///   - font: 字体,默认 `.preferredFont(forTextStyle: .body)`
    ///   - textAlignment: 文本对齐,默认 `.natural`
    ///   - numberOfLines: 行数上限,默认 `0`(不限制)
    ///   - lineBreakMode: 换行模式,默认 `.byTruncatingTail`
    ///   - scalesWithContentSizeCategory: 是否随「动态字体」缩放,默认 `true`
    /// - Returns: `UILabel`
    static func fdy_label(
        text: String = "",
        textColor: UIColor = .label,
        font: UIFont = .preferredFont(forTextStyle: .body),
        textAlignment: NSTextAlignment = .natural,
        numberOfLines: Int = 0,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        scalesWithContentSizeCategory: Bool = true
    ) -> UILabel {
        UILabel(fdy_text: text)
            .fdy
            .textColor(textColor)
            .font(font)
            .textAlignment(textAlignment)
            .numberOfLines(numberOfLines)
            .lineBreakMode(lineBreakMode)
            .adjustsFontForContentSizeCategory(scalesWithContentSizeCategory)
            .build()
    }
}

// MARK: - UIButton
public extension UIButton {
    /// 创建 `UIButton`(走 `UIButton.Configuration` 路线)
    ///
    /// - Parameters:
    ///   - title: 标题,默认空串
    ///   - titleColor: 标题颜色(亦作前景色/图标色),默认 `.label`
    ///   - font: 标题字体,默认 `.preferredFont(forTextStyle: .body)`
    ///   - image: 前景图片,默认 `nil`
    ///   - imagePlacement: 图片相对标题的位置,默认 `.leading`
    ///   - imagePadding: 图文间距,默认 `nil`(保持系统默认)
    ///   - backgroundColor: 背景颜色,默认 `.clear`
    ///   - cornerRadius: 背景圆角半径,默认 `0`(保持系统动态圆角)
    ///   - contentInsets: 内容内边距,默认 `nil`(保持系统默认)
    /// - Returns: `UIButton`
    /// - Note: 配置化按钮上传统 setter(`setTitle` / `setTitleColor` / `setImage`)不生效,
    ///   故本工厂全部经 `configuration` 写入。
    /// - Note: `titleColor` 落到 `baseForegroundColor`,它**同时决定图标着色** —— 需要图文异色请改用
    ///   `imageColorTransformer` 自行覆盖。
    /// - Note: `font` 经 `titleLabel.font` 写入(库内既有约定,实测在配置化按钮上生效),
    ///   但**不属于 `configuration`**,后续改动配置时可能被重置。
    /// - Note: **不动 `cornerStyle`**(保持 `plain()` 的 `.dynamic`)。`.dynamic` 并非忽略 `cornerRadius`,
    ///   只是会「空间不足时自适应」;需要严格固定圆角请自行设 `button.configuration?.cornerStyle = .fixed`。
    static func fdy_button(
        title: String = "",
        titleColor: UIColor = .label,
        font: UIFont = .preferredFont(forTextStyle: .body),
        image: UIImage? = nil,
        imagePlacement: NSDirectionalRectEdge = .leading,
        imagePadding: CGFloat? = nil,
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 0,
        contentInsets: NSDirectionalEdgeInsets? = nil
    ) -> UIButton {
        var configuration = UIButton.Configuration.plain()
            .fdy
            .title(title)
            .baseForegroundColor(titleColor)
            .baseBackgroundColor(backgroundColor)
            .image(image, placement: imagePlacement)
            .build()

        if let imagePadding {
            configuration = configuration.fdy.imagePadding(imagePadding).build()
        }

        if let contentInsets {
            configuration = configuration.fdy.contentInsets(contentInsets).build()
        }

        // 只设半径,**不动 `cornerStyle`**:`plain()` 默认 `.dynamic`,而 `.dynamic` 不是「忽略半径」——
        // SDK 头注释原文是「cornerStyle controls how background.cornerRadius is **interpreted**」,
        // 实测(进真实层级并 layout 之后读回)也确认显式半径未被系统改写。
        // 擅自改成 `.fixed` 会**改变调用方没要求的语义**(丢掉「空间不足时自适应」),
        // 需要固定圆角 / 胶囊圆角请自行设 `button.configuration?.cornerStyle`。
        if cornerRadius > 0 {
            configuration = configuration.fdy.backgroundCornerRadius(cornerRadius).build()
        }

        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = font
        return button
    }
}

// MARK: - UIImageView
public extension UIImageView {
    /// 创建 `UIImageView`
    /// - Parameters:
    ///   - image: 图片,默认 `nil`
    ///   - contentMode: 内容模式,默认 `.scaleAspectFill`
    ///   - tintColor: 着色,默认 `nil`(保持继承,不做覆盖)
    ///   - backgroundColor: 背景颜色,默认 `.clear`
    ///   - cornerRadius: 圆角半径,默认 `0`
    ///   - maskedCorners: 要应用圆角的角,默认四角全开(`.fdy_all`)
    /// - Returns: `UIImageView`
    static func fdy_imageView(
        image: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFill,
        tintColor: UIColor? = nil,
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 0,
        maskedCorners: CACornerMask = .fdy_all
    ) -> UIImageView {
        var wrapper = UIImageView.imageView()
            .fdy
            .image(image)
            .contentMode(contentMode)
            .backgroundColor(backgroundColor)
            .cornerRadius(cornerRadius)
            .maskedCorners(maskedCorners)
            .masksToBounds(true)

        // 传 `nil` 是「不覆盖」而非「清除」—— `tintColor` 置 nil 会退回系统查找,语义与「保持继承」不同
        if let tintColor {
            wrapper = wrapper.tintColor(tintColor)
        }

        return wrapper.build()
    }
}

// MARK: - UITextView
public extension UITextView {
    /// 创建 `UITextView`
    /// - Parameters:
    ///   - text: 文本,默认空串
    ///   - textColor: 文本颜色,默认 `.label`
    ///   - font: 字体,默认 `.preferredFont(forTextStyle: .body)`
    ///   - isEditable: 是否可编辑,默认 `true`
    ///   - isSelectable: 是否可选中,默认 `true`
    ///   - backgroundColor: 背景颜色,默认 `.clear`
    ///   - cornerRadius: 圆角半径,默认 `0`
    ///   - maskedCorners: 要应用圆角的角,默认四角全开(`.fdy_all`)
    /// - Returns: `UITextView`
    /// - Note: 复用 `UITextView.textView()` —— 它已关闭横/纵向滚动指示器。
    static func fdy_textView(
        text: String = "",
        textColor: UIColor = .label,
        font: UIFont = .preferredFont(forTextStyle: .body),
        isEditable: Bool = true,
        isSelectable: Bool = true,
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 0,
        maskedCorners: CACornerMask = .fdy_all
    ) -> UITextView {
        UITextView.textView()
            .fdy
            .text(text)
            .textColor(textColor)
            .font(font)
            .isEditable(isEditable)
            .isSelectable(isSelectable)
            .backgroundColor(backgroundColor)
            .cornerRadius(cornerRadius)
            .maskedCorners(maskedCorners)
            .masksToBounds(true)
            .build()
    }
}

// MARK: - UITextField
public extension UITextField {
    /// 创建 `UITextField`
    /// - Parameters:
    ///   - placeholder: 占位文本,默认空串(此时不装占位属性串)
    ///   - placeholderTextColor: 占位文本颜色,默认 `.placeholderText`
    ///   - text: 初始文本,默认 `nil`(保持系统默认的空值)
    ///   - textColor: 输入文本颜色,默认 `.label`
    ///   - font: 字体(占位与输入共用),默认 `.preferredFont(forTextStyle: .body)`
    ///   - backgroundColor: 背景颜色,默认 `.systemBackground`
    ///   - cornerRadius: 圆角半径,默认 `0`
    ///   - maskedCorners: 要应用圆角的角,默认四角全开(`.fdy_all`)
    ///   - leftPadding: 左侧内边距,默认 `0`(不设置)
    /// - Returns: `UITextField`
    /// - Note: 占位文本的颜色/字体经 `attributedPlaceholder` 实现 —— UIKit 没有单独的占位色属性。
    static func fdy_textField(
        placeholder: String = "",
        placeholderTextColor: UIColor = .placeholderText,
        text: String? = nil,
        textColor: UIColor = .label,
        font: UIFont = .preferredFont(forTextStyle: .body),
        backgroundColor: UIColor = .systemBackground,
        cornerRadius: CGFloat = 0,
        maskedCorners: CACornerMask = .fdy_all,
        leftPadding: CGFloat = 0
    ) -> UITextField {
        var wrapper = UITextField.textField()
            .fdy
            .textColor(textColor)
            .font(font)
            .backgroundColor(backgroundColor)
            .cornerRadius(cornerRadius)
            .maskedCorners(maskedCorners)
            .masksToBounds(true)

        if !placeholder.isEmpty {
            let attributedPlaceholder = placeholder.fdy_toNSMutableAttributedString()
                .fdy
                .addAttributes([
                    .foregroundColor: placeholderTextColor,
                    .font: font,
                ], for: placeholder.fdy_fullNSRange)
                .build()
            wrapper = wrapper.attributedPlaceholder(attributedPlaceholder)
        }

        if let text {
            wrapper = wrapper.text(text)
        }

        // 0 时条件跳过:`leftPadding(0)` 会占掉 `leftView`,让调用方后续自定义 leftView 失效
        if leftPadding > 0 {
            wrapper = wrapper.leftPadding(leftPadding)
        }

        return wrapper.build()
    }
}
