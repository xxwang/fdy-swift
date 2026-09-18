import CoreGraphics

// MARK: - 命名空间入口
//
// `CGPath` 是 Core Foundation 类型(非 `NSObject` 子类),须单独登记,否则 `.fdy` 不可用。
extension CGPath: FdyExtension {}

public extension CGPath {
    /// 创建当前路径的可变副本
    func fdy_toCGMutablePath() -> CGMutablePath {
        let copy = CGMutablePath()
        copy.addPath(self)
        return copy
    }
}
