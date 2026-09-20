import UIKit

// MARK: - 自定义
public extension UIInterfaceOrientation {
    /// 是否为横屏方向(`left` 或 `right`)
    /// - Returns: 是否满足条件
    var fdy_isLandscape: Bool {
        self == .landscapeLeft || self == .landscapeRight
    }

    /// 转换为 `UIInterfaceOrientationMask`(用于判断支持性)
    /// - Returns: 界面方向掩码
    func fdy_interfaceOrientationMask() -> UIInterfaceOrientationMask {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        case .unknown: return []
        default: return []
        }
    }
}
