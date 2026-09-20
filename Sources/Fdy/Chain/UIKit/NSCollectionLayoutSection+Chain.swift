import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: NSCollectionLayoutSection {
    /// 内容内边距
    /// - Parameter contentInsets: 要设置的内容内边距
    /// - Returns: `Self`
    @discardableResult
    func contentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        base.contentInsets = contentInsets
        return self
    }

    /// 组间距
    /// - Parameter interGroupSpacing: 要设置的组间距
    /// - Returns: `Self`
    @discardableResult
    func interGroupSpacing(_ interGroupSpacing: CGFloat) -> Self {
        base.interGroupSpacing = interGroupSpacing
        return self
    }

    /// 正交滚动行为
    /// - Parameter orthogonalScrollingBehavior: 该分组横向滚动时系统的吸附 / 分页策略
    /// - Returns: `Self`
    @discardableResult
    func orthogonalScrollingBehavior(
        _ orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    ) -> Self {
        base.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        return self
    }

    /// 边界附加元素
    /// - Parameter boundarySupplementaryItems: 组级别的 header / footer
    /// - Returns: `Self`
    @discardableResult
    func boundarySupplementaryItems(
        _ boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem]
    ) -> Self {
        base.boundarySupplementaryItems = boundarySupplementaryItems
        return self
    }

    /// 可见元素失效回调
    /// - Parameter visibleItemsInvalidationHandler: 每次布局变化时回调(常用于自定义吸附)
    /// - Returns: `Self`
    @discardableResult
    func visibleItemsInvalidationHandler(
        _ visibleItemsInvalidationHandler: NSCollectionLayoutSectionVisibleItemsInvalidationHandler?
    ) -> Self {
        base.visibleItemsInvalidationHandler = visibleItemsInvalidationHandler
        return self
    }

    /// 装饰元素
    /// - Parameter decorationItems: 要设置的装饰元素
    /// - Returns: `Self`
    @discardableResult
    func decorationItems(_ decorationItems: [NSCollectionLayoutDecorationItem]) -> Self {
        base.decorationItems = decorationItems
        return self
    }

    /// 内容内边距的参照系
    /// - Parameter contentInsetsReference: 要设置的内容内边距的参照系
    /// - Returns: `Self`
    @discardableResult
    func contentInsetsReference(_ contentInsetsReference: UIContentInsetsReference) -> Self {
        base.contentInsetsReference = contentInsetsReference
        return self
    }

    /// 附加视图内边距的参照系
    /// - Parameter supplementaryContentInsetsReference: 要设置的附加视图内边距的参照系
    /// - Returns: `Self`
    @discardableResult
    func supplementaryContentInsetsReference(
        _ supplementaryContentInsetsReference: UIContentInsetsReference
    ) -> Self {
        base.supplementaryContentInsetsReference = supplementaryContentInsetsReference
        return self
    }
}
