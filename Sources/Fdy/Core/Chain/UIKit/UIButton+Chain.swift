import UIKit

// MARK: - 链式方法(配置化)
//
// 这里只放「配置对象本身」的操作(整体替换 / 更新处理器 / 方向化布局)。
// 单项属性的链式设置见 `UIButton.Configuration+Chain.swift` —— 接收者是 `UIButton.Configuration`,
// 方法名与属性同名,可先 `.fdy` 链式改好再交回按钮。
//
// - Note: 按钮未持有配置时以 `.plain()` 兜底;`FdyFactory.plain()` / `.tinted()` 创建的按钮自带配置。
public extension FdyWrapper where Base: UIButton {
    /// 整体替换按钮的 `UIButton.Configuration`
    /// - Parameter configuration: 新的配置对象,传 `nil` 清除配置
    /// - Returns: `Self`
    @discardableResult
    func configuration(_ configuration: UIButton.Configuration) -> Self {
        base.configuration = configuration
        return self
    }

    /// 按钮配置更新处理器
    /// - Parameter handler: 处理器
    /// - Returns: `Self`
    @discardableResult
    func configurationUpdateHandler(_ handler: UIButton.ConfigurationUpdateHandler?) -> Self {
        base.configurationUpdateHandler = handler
        return self
    }

    /// 设置图片方向与图文间距
    ///
    /// - Note: 带 `switch` 分支,未套用 `updateConfiguration`。
    /// - Parameters:
    ///   - direction: 图片方向
    ///   - spacing: 间距
    /// - Returns: `Self`
    @discardableResult
    func layoutImage(direction: NSDirectionalRectEdge, spacing: CGFloat) -> Self {
        var config = base.configuration ?? UIButton.Configuration.plain()
        switch direction {
        case .top:
            config.imagePlacement = .top
            config.imagePadding = spacing
        case .bottom:
            config.imagePlacement = .bottom
            config.imagePadding = spacing
        case .leading:
            config.imagePlacement = .leading
            config.imagePadding = spacing
        case .trailing:
            config.imagePlacement = .trailing
            config.imagePadding = spacing
        default:
            break
        }
        base.configuration = config
        return self
    }
}

// MARK: - 链式方法(传统 API)
//
// 基于 `UIControl.State` 的传统 setter(以及 `UIControl` 原生的 `addAction`)。
// 其中 `backgroundImage` / `backgroundColor` / `contentEdgeInsets` 在按钮持有配置时自动改走
// `configuration` 路径 —— iOS 15 起这些传统属性会被 `UIButton.Configuration` 忽略。
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
    ///   配置化按钮的图文间距请改用 `imagePadding(_:)` 或 `layoutImage(direction:spacing:)`。
    /// - Parameter insets: 边距
    /// - Returns: `Self`
    @discardableResult
    func titleEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        base.titleEdgeInsets = insets
        return self
    }

    /// 设置图片边距
    ///
    /// - Note: iOS 15 起系统弃用 `imageEdgeInsets`,且按钮使用 `UIButton.Configuration` 时该属性会被忽略。
    ///   配置化按钮的图文间距请改用 `imagePadding(_:)` 或 `layoutImage(direction:spacing:)`。
    /// - Parameter insets: 边距
    /// - Returns: `Self`
    @discardableResult
    func imageEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        base.imageEdgeInsets = insets
        return self
    }
}
