import UIKit

// MARK: - 链式设置
//
// `NSLayoutConstraint` 是可变对象,链式就地改 `base` 并返回 `self`。
//
// 本文件只做**实例**的链式包装;批量激活仍走系统 API
// (`NSLayoutConstraint.activate(_:)` / `deactivate(_:)`),库内不另设静态入口
// —— 静态入口会与 `FdyWrapper<<NSLayoutConstraint>.Type>` 的泛型形态打架,收益不抵复杂度。
public extension FdyWrapper where Base: NSLayoutConstraint {
    /// 修改约束常量(最常用:动画中改间距)
    ///
    /// - Note: 改完**不会**自动触发布局,仍需在动画块里调 `layoutIfNeeded()`。
    ///   另外只有**已激活**的约束才参与布局,改一个没激活的约束不会有任何效果。
    @discardableResult
    func constant(_ constant: CGFloat) -> Self {
        base.constant = constant
        return self
    }

    /// 约束优先级
    ///
    /// - Note: 常用档位 `required`(1000)/`defaultHigh`(750)/`defaultLow`(250)。把冲突约束降到
    ///   低优先级比删掉它更好 —— 删除会丢失约束关系,降低优先级只是让它在冲突时让步。
    @discardableResult
    func priority(_ priority: UILayoutPriority) -> Self {
        base.priority = priority
        return self
    }

    /// 激活 / 停用该约束
    ///
    /// - Note: 写 `isActive` 等价于 `NSLayoutConstraint.activate(_:)` / `deactivate(_:)`,
    ///   会真的改视图上的约束集合;约束未加入任何视图时激活会**抛异常**(不是返回 false)。
    @discardableResult
    func active(_ isActive: Bool = true) -> Self {
        base.isActive = isActive
        return self
    }

    /// 调试用标识(出现在 unsatisfiable constraints 日志里)
    @discardableResult
    func identifier(_ identifier: String?) -> Self {
        base.identifier = identifier
        return self
    }
}
