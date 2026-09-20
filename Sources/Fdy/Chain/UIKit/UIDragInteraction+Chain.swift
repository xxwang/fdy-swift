import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIDragInteraction {
    /// 是否允许与其他手势识别器同时识别
    /// - Parameter allowsSimultaneousRecognitionDuringLift: 抬手期间是否允许并行识别
    /// - Returns: `Self`
    @discardableResult
    func allowsSimultaneousRecognitionDuringLift(_ allowsSimultaneousRecognitionDuringLift: Bool) -> Self {
        base.allowsSimultaneousRecognitionDuringLift = allowsSimultaneousRecognitionDuringLift
        return self
    }

    /// 是否启用(关闭后拖拽不再触发)
    /// - Parameter isEnabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        base.isEnabled = isEnabled
        return self
    }

    /// 是否在「抬起判定延迟」结束前就允许指针拖拽
    ///
    /// - Parameter allowsPointerDragBeforeLiftDelay: 是否允许在抬指延迟前拖拽
    /// - Returns: `Self`
    /// - Note: 标注为 `iOS 27.0` 起可用 —— 高于新增 API 门槛(`iOS 18.0`),必须标注。
    ///   反证实测见 `.build/structprobe/batch4_negative.swift`:去掉标注后编译报
    ///   `'allowsPointerDragBeforeLiftDelay' is only available in iOS 27.0 or newer`。
    @available(iOS 27.0, *)
    @discardableResult
    func allowsPointerDragBeforeLiftDelay(_ allowsPointerDragBeforeLiftDelay: Bool) -> Self {
        base.allowsPointerDragBeforeLiftDelay = allowsPointerDragBeforeLiftDelay
        return self
    }

    /// 抬起手势的判定行为
    ///
    /// - Parameter liftBehavior: 要设置的抬起手势的判定行为
    /// - Returns: `Self`
    /// - Note: 标注为 `iOS 27.0` 起可用,同 ``allowsPointerDragBeforeLiftDelay(_:)``。
    ///   类型名用 **`UIDragInteraction.LiftBehavior`** —— 头文件里写的是 `UIDragLiftBehavior`,
    ///   但 Swift 侧**已重命名**成嵌套类型,照抄头文件名会报
    ///   `'UIDragLiftBehavior' has been renamed to 'UIDragInteraction.LiftBehavior'`(① 实测抓到)。
    @available(iOS 27.0, *)
    @discardableResult
    func liftBehavior(_ liftBehavior: UIDragInteraction.LiftBehavior) -> Self {
        base.liftBehavior = liftBehavior
        return self
    }
}
