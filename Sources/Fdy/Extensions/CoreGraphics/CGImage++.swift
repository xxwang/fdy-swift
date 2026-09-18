import CoreGraphics
import UIKit

// MARK: - 命名空间入口
//
// `CGImage` 是 Core Foundation 类型(非 `NSObject` 子类),须单独登记,否则 `.fdy` 不可用。
extension CGImage: FdyExtension {}

// MARK: - 类型转换
public extension CGImage {
    /// 将 `CGImage` 转换为 `UIImage`
    func fdy_toUIImage() -> UIImage? {
        return UIImage(cgImage: self)
    }
}
