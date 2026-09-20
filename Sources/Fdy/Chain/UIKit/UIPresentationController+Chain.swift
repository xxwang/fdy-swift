import UIKit

public extension FdyWrapper where Base: UIPresentationController {
    /// 弹窗背后的视觉效果
    ///
    /// - Parameter backgroundEffect: 视觉效果,传 `nil` 清除
    /// - Returns: `Self`
    @available(iOS 26.1, *)
    @discardableResult
    func backgroundEffect(_ backgroundEffect: UIVisualEffect?) -> Self {
        base.backgroundEffect = backgroundEffect
        return self
    }
}
