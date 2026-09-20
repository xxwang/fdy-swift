import CoreGraphics
import QuartzCore

// MARK: - 命名空间入口
extension CGAffineTransform: FdyExtension {}

// MARK: - 类型转换
public extension CGAffineTransform {
    /// 将当前的 2D 仿射变换转换为等效的 3D 变换矩阵(`CATransform3D`)
    /// - Returns: 三维变换矩阵
    func fdy_toCATransform3D() -> CATransform3D {
        CATransform3DMakeAffineTransform(self)
    }
}
