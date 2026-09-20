import CoreGraphics

// MARK: - 命名空间入口
extension CGPath: FdyExtension {}

public extension CGPath {
    /// 创建当前路径的可变副本
    /// - Returns: 可变路径
    func fdy_toCGMutablePath() -> CGMutablePath {
        let copy = CGMutablePath()
        copy.addPath(self)
        return copy
    }
}
