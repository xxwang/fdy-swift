import UIKit

// MARK: - 剪贴板
public extension String {
    /// 将字符串复制到系统剪贴板
    func fdy_copyToPasteboard() {
        UIPasteboard.general.string = self
    }
}
