import UIKit

// MARK: - 链式方法(配置化)
public extension FdyWrapper where Base: UIButton {
    /// 整体替换按钮的 `UIButton.Configuration`
    ///
    /// - Parameter configuration: 新的配置对象
    /// - Returns: `Self`
    /// - Note: 参数**非可选**,不提供「传 `nil` 清除配置」的入口 ——
    ///   按钮已设 `configurationUpdateHandler` 时把它置 `nil` 会抛
    ///   `NSInternalInconsistencyException: Updated configuration was nil for configuration: (null)`。
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

    /// 状态变化时是否自动更新配置
    ///
    /// - Parameter automaticallyUpdatesConfiguration: 是否自动更新
    /// - Returns: `Self`
    /// - Note: 默认 `true`。置 `false` 后 UIKit 不再自动派生状态样式,
    ///   需自行调用 `setNeedsUpdateConfiguration()` 才会刷新。
    @discardableResult
    func automaticallyUpdatesConfiguration(_ automaticallyUpdatesConfiguration: Bool) -> Self {
        base.automaticallyUpdatesConfiguration = automaticallyUpdatesConfiguration
        return self
    }

    /// 请求按钮更新其配置
    ///
    /// - Returns: `Self`
    /// - Note: 更新在**下一个布局周期**执行 —— 需让 runloop 转一圈才能读到新值。
    @discardableResult
    func setNeedsUpdateConfiguration() -> Self {
        base.setNeedsUpdateConfiguration()
        return self
    }
}

// MARK: - 链式方法(菜单与指针)
public extension FdyWrapper where Base: UIButton {
    /// 按钮角色
    ///
    /// - Parameter role: 角色,默认 `.normal`
    /// - Returns: `Self`
    /// - Note: 影响键盘快捷键与菜单项的强调方式(`.primary` / `.cancel` / `.destructive`)。
    @discardableResult
    func role(_ role: UIButton.Role) -> Self {
        base.role = role
        return self
    }

    /// 按钮附带的菜单
    ///
    /// - Parameter menu: 菜单,传 `nil` 清除
    /// - Returns: `Self`
    /// - Note: 传入非 `nil` 时按钮会自动启用 `contextMenuInteraction`;
    ///   要让**点击**直接弹出菜单,需配合 `fdy.showsMenuAsPrimaryAction(true)`。
    @discardableResult
    func menu(_ menu: UIMenu?) -> Self {
        base.menu = menu
        return self
    }

    /// 菜单元素的排序策略
    /// - Parameter preferredMenuElementOrder: 排序策略
    /// - Returns: `Self`
    @discardableResult
    func preferredMenuElementOrder(_ preferredMenuElementOrder: UIContextMenuConfiguration.ElementOrder) -> Self {
        base.preferredMenuElementOrder = preferredMenuElementOrder
        return self
    }

    /// 主操作是否切换选中态
    ///
    /// - Parameter changesSelectionAsPrimaryAction: 是否切换选中态
    /// - Returns: `Self`
    /// - Note: 与菜单无关的普通按钮上,主操作会直接切换 `isSelected`;
    ///   有菜单且 `showsMenuAsPrimaryAction` 为 `true` 时表现为「选项选择」。
    @discardableResult
    func changesSelectionAsPrimaryAction(_ changesSelectionAsPrimaryAction: Bool) -> Self {
        base.changesSelectionAsPrimaryAction = changesSelectionAsPrimaryAction
        return self
    }

    /// 是否启用按钮内置的指针交互(iPadOS)
    /// - Parameter isPointerInteractionEnabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func isPointerInteractionEnabled(_ isPointerInteractionEnabled: Bool) -> Self {
        base.isPointerInteractionEnabled = isPointerInteractionEnabled
        return self
    }

    /// 指针效果的自定义提供者
    /// - Parameter provider: 提供者,传 `nil` 用系统默认效果
    /// - Returns: `Self`
    @discardableResult
    func pointerStyleProvider(_ provider: UIButton.PointerStyleProvider?) -> Self {
        base.pointerStyleProvider = provider
        return self
    }
}

// MARK: - 链式方法(传统 API)
// 基于 `UIControl.State` 的传统 setter(以及 `UIControl` 原生的 `addAction`)。
// iOS 15 起按钮持有 `UIButton.Configuration` 时传统 setter 大多失效 —— 其中 `backgroundImage(_:for:)` /
// `backgroundColor(_:for:)` / `contentEdgeInsets(_:)` 已改为自动走 `configuration` 路径;
// 其余方法在配置化按钮上的实际表现**逐条实测**并注明在各方法注释里(`title` / `titleColor` / `image` 无效,`font` 有效)。
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

    /// 按钮在指定状态下的普通文本标题
    /// - Parameters:
    ///   - title: 标题字符串
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    /// - Note: 配置化按钮上不生效(实测 `setTitle` 后 `configuration.title` 与 `titleLabel.text` 均不变)
    @discardableResult
    func title(_ title: String, for state: UIControl.State = .normal) -> Self {
        base.setTitle(title, for: state)
        return self
    }

    /// 按钮在指定状态下的富文本标题
    /// - Parameters:
    ///   - attributedTitle: 富文本对象,可为 `nil` 清除标题
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    /// - Note: 同 ``title(_:for:)``,配置化按钮上不生效
    @discardableResult
    func attributedTitle(_ attributedTitle: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        base.setAttributedTitle(attributedTitle, for: state)
        return self
    }

    /// 按钮在指定状态下的标题颜色
    /// - Parameters:
    ///   - color: 标题颜色
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    /// - Note: 配置化按钮上不生效(实测 `setTitleColor` 后 `titleLabel.textColor` 未变)
    @discardableResult
    func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        base.setTitleColor(color, for: state)
        return self
    }

    /// 按钮在指定状态下的标题阴影颜色
    ///
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    /// - Note: 纯传统路径 —— `UIButton.Configuration` 无对应项,配置化按钮上不生效。
    @discardableResult
    func titleShadowColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        base.setTitleShadowColor(color, for: state)
        return self
    }

    /// 按钮标题的字体
    /// - Parameter font: 要应用的字体
    /// - Returns: `Self`
    /// - Note: 直接写 `titleLabel.font`;配置化按钮上同样生效(实测),但不属于 `configuration`,改配置后可能被重置
    @discardableResult
    func font(_ font: UIFont) -> Self {
        base.titleLabel?.font = font
        return self
    }

    /// 按钮在指定状态下的前景图片
    /// - Parameters:
    ///   - image: 图片对象,可为 `nil` 清除图片
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    /// - Note: 配置化按钮上不生效,请改用配置侧 `configuration.image`
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        base.setImage(image, for: state)
        return self
    }

    /// 按钮在指定状态下图标的符号配置(仅 SF Symbol 生效)
    ///
    /// - Parameters:
    ///   - configuration: 符号配置,可为 `nil` 用默认
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    /// - Note: 纯传统路径 —— 配置化按钮请改用配置侧的 `fdy.preferredSymbolConfigurationForImage(_:)`。
    @discardableResult
    func preferredSymbolConfiguration(
        _ configuration: UIImage.SymbolConfiguration?,
        for state: UIControl.State = .normal
    ) -> Self {
        base.setPreferredSymbolConfiguration(configuration, forImageIn: state)
        return self
    }

    /// 按钮在指定状态下的背景图片
    ///
    /// - Parameters:
    ///   - image: 背景图片,可为 `nil` 清除背景
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    /// - Note: 按钮持有 `UIButton.Configuration`(如 `FdyFactory.plain()` / `.tinted()` 创建的按钮)时,
    ///   传统 `setBackgroundImage(_:for:)` 会被 `configuration.background` 覆盖而无效,此方法自动改走配置路径。
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

    /// 按钮在指定状态下的纯色背景(通过生成纯色图片实现)
    ///
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    /// - Note: 按钮持有 `UIButton.Configuration`(如 `FdyFactory.plain()` / `.tinted()` 创建的按钮)时,
    ///   传统 `setBackgroundImage(_:for:)` 会被 `configuration.background` 覆盖而无效,
    ///   此方法自动改走配置路径(设置 `configuration.background.backgroundColor`)。
    @discardableResult
    func backgroundColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        if var configuration = base.configuration {
            configuration.baseBackgroundColor = color
            configuration.background.backgroundColor = color
            base.configuration = configuration
            return self
        }

        if let image = UIImage(fdy_color: color)?.resizableImage(withCapInsets: .zero) {
            base.setBackgroundImage(image, for: state)
        } else {
            base.backgroundColor = color
        }
        return self
    }

    /// 按钮的纯色背景(直接写 `backgroundColor`)
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    /// - Note: 无配置感知;配置化按钮请用 ``backgroundColor(_:for:)`` 走配置路径
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        base.backgroundColor = color
        return self
    }

    /// 内容边距
    ///
    /// - Parameter insets: 边距
    /// - Returns: `Self`
    /// - Note: iOS 15 起系统弃用 `contentEdgeInsets`。按钮持有 `UIButton.Configuration`
    ///   (如 `FdyFactory.plain()` / `.tinted()` 创建的按钮)时,原属性会被忽略,此方法自动改走 `configuration.contentInsets`。
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

    /// 标题边距
    ///
    /// - Parameter insets: 边距
    /// - Returns: `Self`
    /// - Note: iOS 15 起系统弃用 `titleEdgeInsets`,且按钮使用 `UIButton.Configuration` 时该属性会被忽略。
    ///   配置化按钮的图文间距请在配置侧设置(`fdy.imagePadding(_:)` / `fdy.layoutImage(direction:spacing:)`)。
    @discardableResult
    func titleEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        base.titleEdgeInsets = insets
        return self
    }

    /// 图片边距
    ///
    /// - Parameter insets: 边距
    /// - Returns: `Self`
    /// - Note: iOS 15 起系统弃用 `imageEdgeInsets`,且按钮使用 `UIButton.Configuration` 时该属性会被忽略。
    ///   配置化按钮的图文间距请在配置侧设置(`fdy.imagePadding(_:)` / `fdy.layoutImage(direction:spacing:)`)。
    @discardableResult
    func imageEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        base.imageEdgeInsets = insets
        return self
    }
}
