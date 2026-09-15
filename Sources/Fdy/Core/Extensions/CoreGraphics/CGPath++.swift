import CoreGraphics

public extension CGPath {
    /// 创建当前路径的可变副本
    func fdy_cGMutablePath() -> CGMutablePath {
        let copy = CGMutablePath()
        copy.addPath(self)
        return copy
    }
}
