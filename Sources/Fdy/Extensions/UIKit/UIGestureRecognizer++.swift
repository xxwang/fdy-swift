import UIKit

// MARK: - 事件回调处理
extension UIGestureRecognizer {
    /// 关联属性键
    private enum FdyKeys {
        static var recognized: UInt8 = 0
        static var stateChanged: UInt8 = 0
    }

    /// 手势识别成功时触发的闭包
    var fdy_recognizedBlock: FdyAction1<UIGestureRecognizer>? {
        get { return self.fdy_GetAO(forKey: &FdyKeys.recognized) }
        set { self.fdy_SetAO(newValue, forKey: &FdyKeys.recognized) }
    }

    /// 手势状态变化时触发的闭包
    var fdy_stateChangedBlock: FdyAction1<UIGestureRecognizer.State>? {
        get { return self.fdy_GetAO(forKey: &FdyKeys.stateChanged) }
        set { self.fdy_SetAO(newValue, forKey: &FdyKeys.stateChanged) }
    }

    /// 处理手势状态变化
    @objc func stateChangeHandler() {
        // 状态回调
        self.fdy_stateChangedBlock?(state)

        if state == .recognized {
            // 手势识别回调
            self.fdy_recognizedBlock?(self)
        }
    }
}

// MARK: - 属性
public extension UIGestureRecognizer {
    /// 视图是否启用了用户交互
    /// - Returns: 是否满足条件
    var fdy_canRecognizeGesture: Bool {
        self.view?.isUserInteractionEnabled == true
    }

    /// 获取手势在所属视图中的触摸位置
    /// - Returns: 坐标点
    var fdy_locationInView: CGPoint {
        guard let view = self.view else { return .zero }
        return self.location(in: view)
    }
}
