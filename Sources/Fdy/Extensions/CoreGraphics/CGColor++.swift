import CoreGraphics
import UIKit

// MARK: - 命名空间入口
//
// `CGColor` 是 Core Foundation 类型(非 `NSObject` 子类),须单独登记,否则 `.fdy` 不可用。
extension CGColor: FdyExtension {}

// MARK: - 类型转换
public extension CGColor {
    /// 将 `CGColor` 转换为 `UIColor`
    func fdy_toUIColor() -> UIColor {
        return UIColor(cgColor: self)
    }
}
