import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UITableViewCell {
    /// 单元格的选中样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        base.selectionStyle = style
        return self
    }

    /// 选中状态
    ///
    /// - Parameters:
    ///   - isSelected: 是否处于选中态
    ///   - animated: 是否启用动画,默认为 `false`
    /// - Returns: `Self`
    /// - Note: 直接写 `isSelected` 等价于 `animated: false`;`animated: true` 的动画只在 cell 已上屏时可见。
    @discardableResult
    func isSelected(_ isSelected: Bool, animated: Bool = false) -> Self {
        base.setSelected(isSelected, animated: animated)
        return self
    }

    /// 高亮状态
    /// - Parameters:
    ///   - isHighlighted: 是否处于高亮态
    ///   - animated: 是否启用动画,默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func isHighlighted(_ isHighlighted: Bool, animated: Bool = false) -> Self {
        base.setHighlighted(isHighlighted, animated: animated)
        return self
    }

    /// 切换编辑模式(显示插入/删除/排序控件)
    ///
    /// - Parameters:
    ///   - isEditing: 是否处于编辑态
    ///   - animated: 是否启用动画,默认为 `false`
    /// - Returns: `Self`
    /// - Note: 这里只是改 cell 自身状态;整个 tableView 的编辑开关仍要在 `UITableView` 上调。
    @discardableResult
    func isEditing(_ isEditing: Bool, animated: Bool = false) -> Self {
        base.setEditing(isEditing, animated: animated)
        return self
    }

    /// 内容配置(`iOS 14` 起取代 `textLabel` / `detailTextLabel` / `imageView`)
    /// - Parameter configuration: 回调闭包
    /// - Returns: `Self`
    @discardableResult
    func contentConfiguration(_ configuration: (any UIContentConfiguration)?) -> Self {
        base.contentConfiguration = configuration
        return self
    }

    /// 是否由系统按 `configurationState` 自动刷新内容配置
    ///
    /// - Parameter automaticallyUpdates: 是否自动更新
    /// - Returns: `Self`
    /// - Note: 关掉后必须自己调 ``updateConfiguration()``,否则选中/高亮态下配置不会重算。
    @discardableResult
    func automaticallyUpdatesContentConfiguration(_ automaticallyUpdates: Bool) -> Self {
        base.automaticallyUpdatesContentConfiguration = automaticallyUpdates
        return self
    }

    /// 配置刷新回调
    ///
    /// - Parameter handler: 回调闭包
    /// - Returns: `Self`
    /// - Note: 在 ``automaticallyUpdatesContentConfiguration(_:)`` 为 `true` 时由系统调用;
    ///   关掉自动刷新后该闭包不会自己触发,需配合 ``updateConfiguration()`` 使用。
    @discardableResult
    func configurationUpdateHandler(
        _ handler: UITableViewCell.ConfigurationUpdateHandler?
    ) -> Self {
        base.configurationUpdateHandler = handler
        return self
    }

    /// 背景配置(`iOS 14` 起取代 ``backgroundView(_:)``)
    ///
    /// - Parameter configuration: 配置
    /// - Returns: `Self`
    /// - Note: **与 ``backgroundView(_:)`` 互斥,后设者赢** —— 先设 config 再设 view,
    ///   读回 `backgroundConfiguration` 会变成 `nil`(实测)。
    @discardableResult
    func backgroundConfiguration(_ configuration: UIBackgroundConfiguration?) -> Self {
        base.backgroundConfiguration = configuration
        return self
    }

    /// 是否由系统按 `configurationState` 自动刷新背景配置
    /// - Parameter automaticallyUpdates: 是否自动更新
    /// - Returns: `Self`
    @discardableResult
    func automaticallyUpdatesBackgroundConfiguration(_ automaticallyUpdates: Bool) -> Self {
        base.automaticallyUpdatesBackgroundConfiguration = automaticallyUpdates
        return self
    }

    /// 普通态背景视图
    ///
    /// - Parameter backgroundView: 视图
    /// - Returns: `Self`
    /// - Note: **与 ``backgroundConfiguration(_:)`` 互斥,后设者赢** —— 设了本项会把
    ///   `backgroundConfiguration` 清成 `nil`(实测),不是"未定义行为"。
    @discardableResult
    func backgroundView(_ backgroundView: UIView?) -> Self {
        base.backgroundView = backgroundView
        return self
    }

    /// 选中态背景视图
    /// - Parameter selectedBackgroundView: 视图
    /// - Returns: `Self`
    @discardableResult
    func selectedBackgroundView(_ selectedBackgroundView: UIView?) -> Self {
        base.selectedBackgroundView = selectedBackgroundView
        return self
    }

    /// 多选态背景视图
    ///
    /// - Parameter view: 视图
    /// - Returns: `Self`
    /// - Note: 仅在 tableView 处于**编辑模式且允许多选**时才替代 ``selectedBackgroundView(_:)``。
    @discardableResult
    func multipleSelectionBackgroundView(_ view: UIView?) -> Self {
        base.multipleSelectionBackgroundView = view
        return self
    }

    /// 配件类型(右侧箭头 / 勾选 / 详情按钮等)
    ///
    /// - Parameter accessoryType: 附件类型
    /// - Returns: `Self`
    /// - Note: 一旦设了 ``accessoryView(_:)``,本项对右侧配件即失效。
    @discardableResult
    func accessoryType(_ accessoryType: UITableViewCell.AccessoryType) -> Self {
        base.accessoryType = accessoryType
        return self
    }

    /// 自定义右侧配件视图(设了它等于忽略 ``accessoryType(_:)``)
    /// - Parameter accessoryView: 视图
    /// - Returns: `Self`
    @discardableResult
    func accessoryView(_ accessoryView: UIView?) -> Self {
        base.accessoryView = accessoryView
        return self
    }

    /// 编辑模式下的配件类型(**只在编辑模式生效**)
    /// - Parameter editingAccessoryType: 编辑态下的附件类型
    /// - Returns: `Self`
    @discardableResult
    func editingAccessoryType(_ editingAccessoryType: UITableViewCell.AccessoryType) -> Self {
        base.editingAccessoryType = editingAccessoryType
        return self
    }

    /// 编辑模式下的自定义配件视图(**只在编辑模式生效**)
    /// - Parameter editingAccessoryView: 视图
    /// - Returns: `Self`
    @discardableResult
    func editingAccessoryView(_ editingAccessoryView: UIView?) -> Self {
        base.editingAccessoryView = editingAccessoryView
        return self
    }

    /// 内容缩进层级
    ///
    /// - Parameter indentationLevel: 要设置的内容缩进层级
    /// - Returns: `Self`
    /// - Note: 实测**不会**把负值归零(传 `-3` 读回 `-3`)—— 想要合法层级得自己拦;
    ///   每级实际缩进宽度见 ``indentationWidth(_:)``。
    @discardableResult
    func indentationLevel(_ indentationLevel: Int) -> Self {
        base.indentationLevel = indentationLevel
        return self
    }

    /// 每级缩进的宽度(默认 `10`)
    ///
    /// - Parameter indentationWidth: 缩进宽度
    /// - Returns: `Self`
    /// - Note: 实测**不做**下限钳位(传 `5` 读回 `5.0`),别指望系统兜底。
    @discardableResult
    func indentationWidth(_ indentationWidth: CGFloat) -> Self {
        base.indentationWidth = indentationWidth
        return self
    }

    /// 本 cell 的分隔线内边距
    ///
    /// - Parameter separatorInset: 内边距
    /// - Returns: `Self`
    /// - Note: 读回值**不等于**传入值 —— UIKit 会自行校正(实测 `left` 传 `16` 读回 `24`),
    ///   且校正规则随系统版本变(26.5 上 `right` 会被顶到 `16`,18.0 上原样保留)。
    ///   **只作用于本 cell,不影响 tableView 的 `separatorInset`**;要全局统一应改 tableView。
    @discardableResult
    func separatorInset(_ separatorInset: UIEdgeInsets) -> Self {
        base.separatorInset = separatorInset
        return self
    }

    /// 是否显示排序控件
    ///
    /// - Parameter showsReorderControl: 是否显示重排控件
    /// - Returns: `Self`
    /// - Note: 只表达「允许显示」;真正显示还需 tableView 处于编辑模式且 dataSource 声明了可移动。
    @discardableResult
    func showsReorderControl(_ showsReorderControl: Bool) -> Self {
        base.showsReorderControl = showsReorderControl
        return self
    }

    /// 编辑模式下是否整体缩进
    /// - Parameter shouldIndentWhileEditing: 要设置的编辑模式下是否整体缩进
    /// - Returns: `Self`
    @discardableResult
    func shouldIndentWhileEditing(_ shouldIndentWhileEditing: Bool) -> Self {
        base.shouldIndentWhileEditing = shouldIndentWhileEditing
        return self
    }

    /// 焦点样式(焦点引擎相关)
    /// - Parameter focusStyle: 聚焦样式
    /// - Returns: `Self`
    @discardableResult
    func focusStyle(_ focusStyle: UITableViewCell.FocusStyle) -> Self {
        base.focusStyle = focusStyle
        return self
    }

    /// 拖拽过程中是否响应点击
    /// - Parameter userInteractionEnabled: 要设置的拖拽过程中是否响应点击
    /// - Returns: `Self`
    @discardableResult
    func userInteractionEnabledWhileDragging(_ userInteractionEnabled: Bool) -> Self {
        base.userInteractionEnabledWhileDragging = userInteractionEnabled
        return self
    }
}

// MARK: - 方法
public extension FdyWrapper where Base: UITableViewCell {
    /// 主动触发一次配置刷新
    ///
    /// - Returns: `Self`
    /// - Note: 仅在 ``automaticallyUpdatesContentConfiguration(_:)`` /
    ///   ``automaticallyUpdatesBackgroundConfiguration(_:)`` 为 `false` 时才有必要手动调用。
    @discardableResult
    func updateConfiguration() -> Self {
        base.setNeedsUpdateConfiguration()
        return self
    }
}
