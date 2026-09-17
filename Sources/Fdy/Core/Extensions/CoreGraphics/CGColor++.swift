import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGColor {
    /// 将 `CGColor` 转换为 `UIColor`
    func fdy_UIColor() -> UIColor {
        return UIColor(cgColor: self)
    }
}
