import CoreGraphics
import UIKit

// MARK: - 命名空间入口
extension CGColor: FdyExtension {}

// MARK: - 类型转换
public extension CGColor {
    /// 将 `CGColor` 转换为 `UIColor`
    /// - Returns: 颜色
    func fdy_toUIColor() -> UIColor {
        return UIColor(cgColor: self)
    }
}
