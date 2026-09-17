import UIKit

// MARK: - 链式方法(配置化)
//
// 按钮侧的配置入口(整体替换 / 更新处理器 / 自动更新开关 / 主动请求刷新)。
// 单项属性与图文布局的链式设置见 `UIButton.Configuration+Chain.swift` —— 接收者是 `UIButton.Configuration`,
// 方法名与属性同名,可先 `.fdy` 链式改好再交回按钮。
public extension FdyWrapper where Base: UIButton {
    /// 整体替换按钮的 `UIButton.Configuration`
    ///
    /// - Note: 参数**非可选**,不提供「传 `nil` 清除配置」的入口 ——
    ///   按钮已设 `configurationUpdateHandler` 时把它置 `nil` 会抛
    ///   `NSInternalInconsistencyException: Updated configuration was nil for configuration: (null)`。
    /// - Parameter configuration: 新的配置对象
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

    /// 设置状态变化时是否自动更新配置
    ///
    /// - Note: 默认 `true`。置 `false` 后 UIKit 不再自动派生状态样式,
    ///   需自行调用 `setNeedsUpdateConfiguration()` 才会刷新。
    /// - Parameter automaticallyUpdatesConfiguration: 是否自动更新
    /// - Returns: `Self`
    @discardableResult
    func automaticallyUpdatesConfiguration(_ automaticallyUpdatesConfiguration: Bool) -> Self {
        base.automaticallyUpdatesConfiguration = automaticallyUpdatesConfiguration
        return self
    }

    /// 请求按钮更新其配置
    ///
    /// - Note: 更新在**下一个布局周期**执行 —— 需让 runloop 转一圈才能读到新值。
    /// - Returns: `Self`
    @discardableResult
    func setNeedsUpdateConfiguration() -> Self {
        base.setNeedsUpdateConfiguration()
        return self
    }
}

// MARK: - 链式方法(菜单与指针)
//
// 按钮的角色、菜单与指针交互属性(iOS 14 起引入,与 `UIControl.State` 无关)。
// `menu` 只负责挂菜单,「点击直接弹菜单」需配合 `UIControl` 侧的 `showsMenuAsPrimaryAction(_:)`。
public extension FdyWrapper where Base: UIButton {
    /// 设置按钮角色
    ///
    /// - Note: 影响键盘快捷键与菜单项的强调方式(`.primary` / `.cancel` / `.destructive`)。
    /// - Parameter role: 角色,默认 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func role(_ role: UIButton.Role) -> Self {
        base.role = role
        return self
    }

    /// 设置按钮附带的菜单
    ///
    /// - Note: 传入非 `nil` 时按钮会自动启用 `contextMenuInteraction`;
    ///   要让**点击**直接弹出菜单,需配合 `fdy.showsMenuAsPrimaryAction(true)`。
    /// - Parameter menu: 菜单,传 `nil` 清除
    /// - Returns: `Self`
    @discardableResult
    func menu(_ menu: UIMenu?) -> Self {
        base.menu = menu
        return self
    }

    /// 设置菜单元素的排序策略
    /// - Parameter preferredMenuElementOrder: 排序策略
    /// - Returns: `Self`
    @discardableResult
    func preferredMenuElementOrder(_ preferredMenuElementOrder: UIContextMenuConfiguration.ElementOrder) -> Self {
        base.preferredMenuElementOrder = preferredMenuElementOrder
        return self
    }

    /// 设置主操作是否切换选中态
    ///
    /// - Note: 与菜单无关的普通按钮上,主操作会直接切换 `isSelected`;
    ///   有菜单且 `showsMenuAsPrimaryAction` 为 `true` 时表现为「选项选择」。
    /// - Parameter changesSelectionAsPrimaryAction: 是否切换选中态
    /// - Returns: `Self`
    @discardableResult
    func changesSelectionAsPrimaryAction(_ changesSelectionAsPrimaryAction: Bool) -> Self {
        base.changesSelectionAsPrimaryAction = changesSelectionAsPrimaryAction
        return self
    }

    /// 设置是否启用按钮内置的指针交互(iPadOS)
    /// - Parameter isEnabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func isPointerInteractionEnabled(_ isEnabled: Bool) -> Self {
        base.isPointerInteractionEnabled = isEnabled
        return self
    }

    /// 设置指针效果的自定义提供者
    /// - Parameter provider: 提供者,传 `nil` 用系统默认效果
    /// - Returns: `Self`
    @discardableResult
    func pointerStyleProvider(_ provider: UIButton.PointerStyleProvider?) -> Self {
        base.pointerStyleProvider = provider
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

    /// 设置按钮在指定状态下的标题阴影颜色
    ///
    /// - Note: 纯传统路径 —— `UIButton.Configuration` 无对应项,配置化按钮上不生效。
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func titleShadowColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        base.setTitleShadowColor(color, for: state)
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

    /// 设置按钮在指定状态下图标的符号配置(仅 SF Symbol 生效)
    ///
    /// - Note: 纯传统路径 —— 配置化按钮请改用配置侧的 `fdy.preferredSymbolConfigurationForImage(_:)`。
    /// - Parameters:
    ///   - configuration: 符号配置,可为 `nil` 用默认
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func preferredSymbolConfiguration(
        _ configuration: UIImage.SymbolConfiguration?,
        for state: UIControl.State = .normal
    ) -> Self {
        base.setPreferredSymbolConfiguration(configuration, forImageIn: state)
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
    ///   配置化按钮的图文间距请在配置侧设置(`fdy.imagePadding(_:)` / `fdy.layoutImage(direction:spacing:)`)。
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
    ///   配置化按钮的图文间距请在配置侧设置(`fdy.imagePadding(_:)` / `fdy.layoutImage(direction:spacing:)`)。
    /// - Parameter insets: 边距
    /// - Returns: `Self`
    @discardableResult
    func imageEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        base.imageEdgeInsets = insets
        return self
    }
}
