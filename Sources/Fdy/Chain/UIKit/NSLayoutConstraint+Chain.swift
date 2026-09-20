import UIKit

// MARK: - 链式设置
public extension FdyWrapper where Base: NSLayoutConstraint {
    /// 修改约束常量(最常用:动画中改间距)
    ///
    /// - Parameter constant: 约束常量
    /// - Returns: `Self`
    /// - Note: 改完**不会**自动触发布局,仍需在动画块里调 `layoutIfNeeded()`。
    ///   另外只有**已激活**的约束才参与布局,改一个没激活的约束不会有任何效果。
    @discardableResult
    func constant(_ constant: CGFloat) -> Self {
        base.constant = constant
        return self
    }

    /// 约束优先级
    ///
    /// - Parameter priority: 优先级
    /// - Returns: `Self`
    /// - Note: 常用档位 `required`(1000)/`defaultHigh`(750)/`defaultLow`(250)。把冲突约束降到
    ///   低优先级比删掉它更好 —— 删除会丢失约束关系,降低优先级只是让它在冲突时让步。
    @discardableResult
    func priority(_ priority: UILayoutPriority) -> Self {
        base.priority = priority
        return self
    }

    /// 激活 / 停用该约束
    ///
    /// - Parameter isActive: 要设置的激活 / 停用该约束,默认为 `true`
    /// - Returns: `Self`
    /// - Note: 写 `isActive` 等价于 `NSLayoutConstraint.activate(_:)` / `deactivate(_:)`,
    ///   会真的改视图上的约束集合;约束未加入任何视图时激活会**抛异常**(不是返回 false)。
    @discardableResult
    func active(_ isActive: Bool = true) -> Self {
        base.isActive = isActive
        return self
    }

    /// 调试用标识(出现在 unsatisfiable constraints 日志里)
    /// - Parameter identifier: 标识符
    /// - Returns: `Self`
    @discardableResult
    func identifier(_ identifier: String?) -> Self {
        base.identifier = identifier
        return self
    }

    /// 是否应被归档(用于状态恢复)
    /// - Parameter shouldBeArchived: 是否随会话归档
    /// - Returns: `Self`
    @discardableResult
    func shouldBeArchived(_ shouldBeArchived: Bool) -> Self {
        base.shouldBeArchived = shouldBeArchived
        return self
    }
}
