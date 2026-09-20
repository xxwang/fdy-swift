import UIKit

// MARK: - 常用方法
public extension UICollectionViewCell {
    /// 获取当前`Cell`所属的 `UICollectionView`(通过向上遍历`superview`)
    /// - Returns: 集合视图,不可用时返回 `nil`
    var fdy_collectionView: UICollectionView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }

    /// 获取当前`Cell` 在 `UICollectionView` 中的 `IndexPath`
    /// - Returns: 索引路径,不可用时返回 `nil`
    var fdy_indexPath: IndexPath? {
        self.fdy_collectionView?.indexPath(for: self)
    }
}
