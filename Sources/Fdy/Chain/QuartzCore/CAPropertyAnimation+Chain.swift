import QuartzCore

// MARK: - 链式设置属性

/// 动画属性的公共面 —— 抽象基类不直接实例化,
/// 但 `where Base: CAPropertyAnimation` 对 `CABasicAnimation` / `CAKeyframeAnimation` /
/// `CASpringAnimation` 等子类**自动适用**,故本文件补齐后子类无需重复实现。
public extension FdyWrapper where Base: CAPropertyAnimation {
    /// 动画作用的属性路径(如 `"position"` / `"opacity"`)
    /// - Parameter keyPath: 属性路径,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func keyPath(_ keyPath: String?) -> Self {
        base.keyPath = keyPath
        return self
    }

    /// 动画值是否与当前值叠加(而非替换)
    /// - Parameter isAdditive: 是否叠加
    /// - Returns: `Self`
    @discardableResult
    func isAdditive(_ isAdditive: Bool) -> Self {
        base.isAdditive = isAdditive
        return self
    }

    /// 动画值是否累积
    /// - Parameter isCumulative: 要设置的动画值是否累积
    /// - Returns: `Self`
    @discardableResult
    func isCumulative(_ isCumulative: Bool) -> Self {
        base.isCumulative = isCumulative
        return self
    }

    /// 值函数(用于在多个动画值之间插值)
    /// - Parameter valueFunction: 值函数,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func valueFunction(_ valueFunction: CAValueFunction?) -> Self {
        base.valueFunction = valueFunction
        return self
    }
}
