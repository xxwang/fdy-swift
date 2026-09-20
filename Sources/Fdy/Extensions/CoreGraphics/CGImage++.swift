import CoreGraphics
import UIKit

// MARK: - 命名空间入口
extension CGImage: FdyExtension {}

// MARK: - 类型转换
public extension CGImage {
    /// 将 `CGImage` 转换为 `UIImage`
    /// - Returns: 图片,不可用时返回 `nil`
    func fdy_toUIImage() -> UIImage? {
        return UIImage(cgImage: self)
    }
}
