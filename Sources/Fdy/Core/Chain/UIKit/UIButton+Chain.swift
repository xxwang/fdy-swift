import UIKit

// MARK: - 链式方法(传统 API)
//
// 本文件只保留基于 `UIControl.State` 的传统 setter(以及 `UIControl` 原生的 `addAction`),
// 不读写 `UIButton.Configuration`。配置化 API 见 `UIButton+Configuration+Chain.swift`(方法名带 `bc_` 前缀)。
public extension FdyWrapper where Base: UIButton {
    /// 添加一个 `UIAction`
    /// - Parameters:
    ///   - action: `UIAction` 对象
    ///   - controlEvents: 事件类型
    /// - Returns: `Self`
    @discardableResult
    func addAction(_ action: UIAction, for controlEvents: UIControl.Event = .touchUpInside) -> Self {
        base.addAction(action, for: controlEvents)
        return self
    }

    /// 设置按钮在指定状态下的普通文本标题
    /// - Parameters:
    ///   - title: 标题字符串
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String, for state: UIControl.State = .normal) -> Self {
        base.setTitle(title, for: state)
        return self
    }

    /// 设置按钮在指定状态下的富文本标题
    /// - Parameters:
    ///   - attributedTitle: 富文本对象,可为 `nil` 清除标题
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func attributedTitle(_ attributedTitle: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        base.setAttributedTitle(attributedTitle, for: state)
        return self
    }

    /// 设置按钮在指定状态下的标题颜色
    /// - Parameters:
    ///   - color: 标题颜色
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        base.setTitleColor(color, for: state)
        return self
    }

    /// 设置按钮标题的字体
    /// - Parameter font: 要应用的字体
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        base.titleLabel?.font = font
        return self
    }

    /// 设置按钮在指定状态下的前景图片
    /// - Parameters:
    ///   - image: 图片对象,可为 `nil` 清除图片
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        base.setImage(image, for: state)
        return self
    }

    /// 设置按钮在指定状态下的背景图片
    ///
    /// - Note: 按钮持有 `UIButton.Configuration`(如 `FdyFactory.plain()` / `.tinted()` 创建的按钮)时,
    ///   传统 `setBackgroundImage(_:for:)` 会被 `configuration.background` 覆盖而无效,此方法自动改走配置路径。
    /// - Parameters:
    ///   - image: 背景图片,可为 `nil` 清除背景
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        if var configuration = base.configuration {
            configuration.background.image = image
            base.configuration = configuration
            return self
        }
        base.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置按钮在指定状态下的纯色背景(通过生成纯色图片实现)
    ///
    /// - Note: 按钮持有 `UIButton.Configuration`(如 `FdyFactory.plain()` / `.tinted()` 创建的按钮)时,
    ///   传统 `setBackgroundImage(_:for:)` 会被 `configuration.background` 覆盖而无效,
    ///   此方法自动改走配置路径(设置 `configuration.background.backgroundColor`)。
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        if var configuration = base.configuration {
            configuration.baseBackgroundColor = color
            configuration.background.backgroundColor = color
            base.configuration = configuration
            return self
        }

        if let image = UIImage(color: color)?.resizableImage(withCapInsets: .zero) {
            base.setBackgroundImage(image, for: state)
        } else {
            base.backgroundColor = color
        }
        return self
    }

    /// 设置按钮的纯色背景
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        base.backgroundColor = color
        return self
    }

    /// 设置内容边距
    ///
    /// - Note: iOS 15 起系统弃用 `contentEdgeInsets`。按钮持有 `UIButton.Configuration`
    ///   (如 `FdyFactory.plain()` / `.tinted()` 创建的按钮)时,原属性会被忽略,此方法自动改走 `configuration.contentInsets`。
    /// - Parameter insets: 边距
    /// - Returns: `Self`
    @available(iOS, deprecated: 15.0, message: "配置化按钮请改用 bc_contentInsets(_:)")
    @discardableResult
    func contentEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        if var configuration = base.configuration {
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: insets.top,
                leading: insets.left,
                bottom: insets.bottom,
                trailing: insets.right
            )
            base.configuration = configuration
            return self
        }
        base.contentEdgeInsets = insets
        return self
    }

    /// 设置标题边距
    ///
    /// - Note: iOS 15 起系统弃用 `titleEdgeInsets`,且按钮使用 `UIButton.Configuration` 时该属性会被忽略。
    ///   配置化按钮的图文间距请改用 `bc_imagePadding(_:)` 或 `bc_layoutImage(direction:spacing:)`。
    /// - Parameter insets: 边距
    /// - Returns: `Self`
    @available(iOS, deprecated: 15.0, message: "配置化按钮请改用 bc_imagePadding(_:) / bc_layoutImage(direction:spacing:)")
    @discardableResult
    func titleEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        base.titleEdgeInsets = insets
        return self
    }

    /// 设置图片边距
    ///
    /// - Note: iOS 15 起系统弃用 `imageEdgeInsets`,且按钮使用 `UIButton.Configuration` 时该属性会被忽略。
    ///   配置化按钮的图文间距请改用 `bc_imagePadding(_:)` 或 `bc_layoutImage(direction:spacing:)`。
    /// - Parameter insets: 边距
    /// - Returns: `Self`
    @available(iOS, deprecated: 15.0, message: "配置化按钮请改用 bc_imagePadding(_:) / bc_layoutImage(direction:spacing:)")
    @discardableResult
    func imageEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        base.imageEdgeInsets = insets
        return self
    }
}
