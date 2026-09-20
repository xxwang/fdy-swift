import UIKit

// MARK: - 链式设置
public extension FdyWrapper where Base: UIStepper {
    /// 当前值
    ///
    /// - Parameter value: 值
    /// - Returns: `Self`
    /// - Note: 赋值结果会被钳制到 `minimumValue...maximumValue`(不崩)。要精确落值请先设上下限。
    @discardableResult
    func value(_ value: Double) -> Self {
        base.value = value
        return self
    }

    /// 最小值(默认 `0`)
    ///
    /// - Parameter value: 值
    /// - Returns: `Self`
    /// - Note: 约束为**必须小于 `maximumValue`**;违反时本方法**静默忽略**,不抛异常也不崩。
    ///   想一次设好区间时按 `minimumValue` → `maximumValue` 的顺序,或反过来都行 ——
    ///   只要每一次赋值当下合法。
    @discardableResult
    func minimumValue(_ value: Double) -> Self {
        guard value < base.maximumValue else { return self }
        base.minimumValue = value
        return self
    }

    /// 最大值(默认 `100`)
    ///
    /// - Parameter value: 值
    /// - Returns: `Self`
    /// - Note: 约束为**必须大于 `minimumValue`**;违反时**静默忽略**。
    @discardableResult
    func maximumValue(_ value: Double) -> Self {
        guard value > base.minimumValue else { return self }
        base.maximumValue = value
        return self
    }

    /// 单步增量(默认 `1`)
    ///
    /// - Parameter value: 值
    /// - Returns: `Self`
    /// - Note: 约束为**必须大于 `0`**;非正数**静默忽略**(实测裸写会抛
    ///   `'stepValue must be greater than 0'` 并终止进程)。
    @discardableResult
    func stepValue(_ value: Double) -> Self {
        guard value > 0 else { return self }
        base.stepValue = value
        return self
    }

    /// 是否按住期间连续改值(默认 `true`)
    ///
    /// - Parameter enabled: 是否启用
    /// - Returns: `Self`
    /// - Note: 关掉后长按只走一步,适合需要精确点选的场景。
    @discardableResult
    func autorepeat(_ enabled: Bool) -> Self {
        base.autorepeat = enabled
        return self
    }

    /// 到达边界后是否回绕到另一端(默认 `false`)
    /// - Parameter enabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func wraps(_ enabled: Bool) -> Self {
        base.wraps = enabled
        return self
    }

    /// 是否在按住期间持续发 `.valueChanged`(默认 `true`)
    ///
    /// - Parameter enabled: 是否启用
    /// - Returns: `Self`
    /// - Note: 设为 `false` 时只在**手指抬起**那一刻发一次事件 —— 与 `autorepeat` 正交,
    ///   两者都为 `false` 时才是"一步一事件"。
    @discardableResult
    func continuous(_ enabled: Bool) -> Self {
        base.isContinuous = enabled
        return self
    }
}
