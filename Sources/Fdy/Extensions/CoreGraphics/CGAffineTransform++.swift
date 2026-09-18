import CoreGraphics
import QuartzCore

// MARK: - 命名空间入口
//
// `CGAffineTransform` 是结构体,不继承 `extension NSObject: FdyExtension`,须单独登记,否则 `.fdy` 不可用。
extension CGAffineTransform: FdyExtension {}

// MARK: - 类型转换
public extension CGAffineTransform {
    /// 将当前的 2D 仿射变换转换为等效的 3D 变换矩阵(`CATransform3D`)
    func fdy_toCATransform3D() -> CATransform3D {
        CATransform3DMakeAffineTransform(self)
    }
}
