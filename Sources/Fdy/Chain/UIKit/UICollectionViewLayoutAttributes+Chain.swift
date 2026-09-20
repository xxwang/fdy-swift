import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UICollectionViewLayoutAttributes {
    /// 位置与尺寸
    /// - Parameter frame: 元素在集合视图坐标系下的矩形
    /// - Returns: `Self`
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        base.frame = frame
        return self
    }

    /// 中心点
    /// - Parameter center: 中心点(由 `size` 反推 `frame`)
    /// - Returns: `Self`
    @discardableResult
    func center(_ center: CGPoint) -> Self {
        base.center = center
        return self
    }

    /// 尺寸
    /// - Parameter size: 尺寸(由 `center` 反推 `frame`)
    /// - Returns: `Self`
    @discardableResult
    func size(_ size: CGSize) -> Self {
        base.size = size
        return self
    }

    ///  3D 变换
    /// - Parameter transform3D: 作用于该元素的 3D 变换
    /// - Returns: `Self`
    @discardableResult
    func transform3D(_ transform3D: CATransform3D) -> Self {
        base.transform3D = transform3D
        return self
    }

    /// 透明度
    /// - Parameter alpha: 透明度(0~1)
    /// - Returns: `Self`
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }

    /// 索引路径
    /// - Parameter indexPath: 要设置的索引路径
    /// - Returns: `Self`
    @discardableResult
    func indexPath(_ indexPath: IndexPath) -> Self {
        base.indexPath = indexPath
        return self
    }

    /// 布局属性的边界矩形
    ///
    /// - Parameter bounds: 边界矩形(`origin` 须为 `.zero`)
    /// - Returns: `Self`
    /// - Warning: `origin` **必须是 `.zero`** —— UIKit 在 setter 内做断言,传非零 `origin`
    ///   会直接抛 `NSInternalInconsistencyException`(模拟器实测)。需要偏移请走 `center` / `frame`。
    /// - Note: `frame` 的 getter 会按 `transform3D` 重算,`bounds` 与 `frame` 语义不同
    @discardableResult
    func bounds(_ bounds: CGRect) -> Self {
        base.bounds = bounds
        return self
    }

    /// 二维仿射变换
    /// - Parameter transform: 仿射变换
    /// - Returns: `Self`
    @discardableResult
    func transform(_ transform: CGAffineTransform) -> Self {
        base.transform = transform
        return self
    }
}
