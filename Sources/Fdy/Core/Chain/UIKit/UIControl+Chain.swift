import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIControl {
    /// 设置控件启用状态
    /// - Parameter isEnabled: 是否启用
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        base.isEnabled = isEnabled
        return self
    }

    /// 设置选中状态
    /// - Parameter isSelected: 是否选中
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func isSelected(_ isSelected: Bool) -> Self {
        base.isSelected = isSelected
        return self
    }

    /// 设置高亮状态
    /// - Parameter isHighlighted: 是否高亮
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func isHighlighted(_ isHighlighted: Bool) -> Self {
        base.isHighlighted = isHighlighted
        return self
    }

    /// 设置内容垂直对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func contentVerticalAlignment(_ contentVerticalAlignment: UIControl.ContentVerticalAlignment) -> Self {
        base.contentVerticalAlignment = contentVerticalAlignment
        return self
    }

    /// 设置内容水平对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func contentHorizontalAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        base.contentHorizontalAlignment = alignment
        return self
    }

    /// 设置点击是否直接把菜单作为主操作
    ///
    /// - Note: 需先挂上菜单(`UIButton` 用 `fdy.menu(_:)`)。
    /// - Parameter showsMenuAsPrimaryAction: 是否把菜单作为主操作
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func showsMenuAsPrimaryAction(_ showsMenuAsPrimaryAction: Bool) -> Self {
        base.showsMenuAsPrimaryAction = showsMenuAsPrimaryAction
        return self
    }

    /// 设置是否启用上下文菜单交互
    ///
    /// - Note: 挂上 `menu` 后 UIKit 会自动开启;仅在手动接管时需要显式设置。
    /// - Parameter isContextMenuInteractionEnabled: 是否启用
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func isContextMenuInteractionEnabled(_ isContextMenuInteractionEnabled: Bool) -> Self {
        base.isContextMenuInteractionEnabled = isContextMenuInteractionEnabled
        return self
    }

    /// 设置悬停提示文本(iPadOS / macOS)
    ///
    /// - Note: 设置后 `toolTip` 的读回值取决于运行环境 —— 实测模拟器上(含直接写属性)
    ///   读回仍为 `nil`,`toolTipInteraction` 未创建;需在真机 / 指针环境下才有实际效果。
    /// - Parameter toolTip: 提示文本,传 `nil` 清除
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func toolTip(_ toolTip: String?) -> Self {
        base.toolTip = toolTip
        return self
    }

    /// 设置 SF Symbol 的动画效果是否启用(iOS 17+)
    /// - Parameter isSymbolAnimationEnabled: 是否启用
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func isSymbolAnimationEnabled(_ isSymbolAnimationEnabled: Bool) -> Self {
        base.isSymbolAnimationEnabled = isSymbolAnimationEnabled
        return self
    }
}

// MARK: - 链式方法
public extension FdyWrapper where Base: UIControl {
    /// 链式添加 `target-action`
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 方法选择器
    ///   - event: 事件类型,默认为 `.touchUpInside`
    /// - Returns: 当前实例
    @discardableResult
    func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        base.addTarget(target, action: action, for: event)
        return self
    }

    /// 链式移除 `target-action`
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 方法选择器
    ///   - event: 事件类型,默认为 `.touchUpInside`
    /// - Returns: 当前实例
    @discardableResult
    func removeTarget(_ target: Any?, action: Selector?, for event: UIControl.Event = .touchUpInside) -> Self {
        base.removeTarget(target, action: action, for: event)
        return self
    }

    /// 链式移除指定的 `UIAction`
    /// - Parameters:
    ///   - action: 要移除的 `UIAction`
    ///   - event: 事件类型,默认为 `.touchUpInside`
    /// - Returns: 当前实例
    @discardableResult
    func removeAction(_ action: UIAction, for event: UIControl.Event = .touchUpInside) -> Self {
        base.removeAction(action, for: event)
        return self
    }

    /// 按标识符链式移除 `UIAction`
    ///
    /// - Note: 与 `removeAction(_:for:)` 的区别是只需 `UIAction.identifier`,不必持有对象本身。
    /// - Parameters:
    ///   - identifier: 动作标识符
    ///   - event: 事件类型,默认为 `.touchUpInside`
    /// - Returns: 当前实例
    @discardableResult
    func removeAction(
        identifiedBy identifier: UIAction.Identifier,
        for event: UIControl.Event = .touchUpInside
    ) -> Self {
        base.removeAction(identifiedBy: identifier, for: event)
        return self
    }

    /// 主动派发指定事件(会触发该事件上已注册的 target-action 与 action)
    /// - Parameter event: 事件类型
    /// - Returns: 当前实例
    @discardableResult
    func sendActions(for event: UIControl.Event) -> Self {
        base.sendActions(for: event)
        return self
    }

    /// 触发控件的主操作(iOS 17.4+)
    ///
    /// - Note: 按钮会执行其 `primaryAction` 并派发 `.primaryActionTriggered`。
    /// - Returns: 当前实例
    @discardableResult
    func performPrimaryAction() -> Self {
        base.performPrimaryAction()
        return self
    }
}
