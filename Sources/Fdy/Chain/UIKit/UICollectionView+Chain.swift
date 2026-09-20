import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UICollectionView {
    ///  `delegate`,传 `nil` 可清空
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UICollectionViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    ///  `dataSource`,传 `nil` 可清空
    /// - Parameter dataSource: 数据源对象
    /// - Returns: `Self`
    @discardableResult
    func dataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        base.dataSource = dataSource
        return self
    }
}

// MARK: - 方法
public extension FdyWrapper where Base: UICollectionView {
    /// 注册 `Cell` 类(纯代码方式),支持链式调用
    /// - Parameter cell: `UICollectionViewCell` 的子类类型
    /// - Returns: `Self`
    @discardableResult
    func register(_ cell: (some UICollectionViewCell).Type) -> Self {
        base.register(cell, forCellWithReuseIdentifier: cell.fdy_identifier)
        return self
    }

    /// 使用 `Nib` 注册 `UICollectionViewCell`
    /// - Parameters:
    ///   - nib: `Nib` 对象
    ///   - cellType: `Cell` 类型
    /// - Returns: `Self`
    @discardableResult
    func register(nib: UINib?, forCellWithClass cellType: (some UICollectionViewCell).Type) -> Self {
        base.register(nib, forCellWithReuseIdentifier: cellType.fdy_identifier)
        return self
    }

    /// 自动从同名 `XIB` 注册 `Cell`(`XIB` 文件名需与类名一致)
    /// - Parameters:
    ///   - cellType: `Cell` 类型
    ///   - bundleClass: 用于定位 `Bundle` 的参考类(默认为当前类)
    /// - Returns: `Self`
    @discardableResult
    func register(nibWithCellClass cellType: (some UICollectionViewCell).Type, at bundleClass: AnyClass? = nil) -> Self {
        let bundle = bundleClass.map { Bundle(for: $0) } ?? Bundle(for: cellType)
        let nib = UINib(nibName: cellType.fdy_identifier, bundle: bundle)
        base.register(nib, forCellWithReuseIdentifier: cellType.fdy_identifier)
        return self
    }

    /// 使用类名注册补充视图(如 `Header`)
    /// - Parameters:
    ///   - kind: 视图种类(如 `UICollectionView.elementKindSectionHeader`)
    ///   - viewType: 视图类型
    /// - Returns: `Self`
    @discardableResult
    func register(supplementaryViewOfKind kind: String, withClass viewType: (some UICollectionReusableView).Type) -> Self {
        base.register(viewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.fdy_identifier)
        return self
    }

    /// 使用 `Nib` 注册补充视图
    /// - Parameters:
    ///   - nib: `Nib` 对象
    ///   - kind: 视图种类
    ///   - viewType: 视图类型
    /// - Returns: `Self`
    @discardableResult
    func register(
        nib: UINib?,
        forSupplementaryViewOfKind kind: String,
        withClass viewType: (some UICollectionReusableView).Type
    ) -> Self {
        base.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.fdy_identifier)
        return self
    }

    ///  `CollectionView` 布局,支持动画和完成回调
    /// - Parameters:
    ///   - layout: 布局对象
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    /// - Returns: `Self`
    @discardableResult
    func collectionViewLayout(
        _ layout: UICollectionViewLayout,
        animated: Bool = true,
        completion: FdyAction1<Bool>? = nil
    ) -> Self {
        base.setCollectionViewLayout(layout, animated: animated, completion: completion)
        return self
    }

    /// 滚动使指定区域可见
    /// - Parameters:
    ///   - rect: 可视区域
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollRectToVisible(_ rect: CGRect, animated: Bool = true) -> Self {
        base.scrollRectToVisible(rect, animated: animated)
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension FdyWrapper where Base: UICollectionView {
    /// 滚动到指定 `Item`
    /// - Parameters:
    ///   - indexPath: `Item`索引
    ///   - scrollPosition: 滚动位置
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToItem(
        _ indexPath: IndexPath,
        at scrollPosition: UICollectionView.ScrollPosition = .top,
        animated: Bool = true
    ) -> Self {
        guard
            indexPath.section >= 0,
            indexPath.item >= 0,
            indexPath.section < base.numberOfSections,
            indexPath.item < base.numberOfItems(inSection: indexPath.section)
        else {
            return self
        }
        base.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 预取数据源
    /// - Parameter prefetchDataSource: 遵循 `UICollectionViewDataSourcePrefetching` 的对象
    /// - Returns: `Self`
    @discardableResult
    func prefetchDataSource(_ prefetchDataSource: UICollectionViewDataSourcePrefetching?) -> Self {
        base.prefetchDataSource = prefetchDataSource
        return self
    }

    /// 是否启用预取
    /// - Parameter isPrefetchingEnabled: `true` 表示启用预取
    /// - Returns: `Self`
    @discardableResult
    func isPrefetchingEnabled(_ isPrefetchingEnabled: Bool) -> Self {
        base.isPrefetchingEnabled = isPrefetchingEnabled
        return self
    }

    /// 拖拽代理
    /// - Parameter dragDelegate: 遵循 `UICollectionViewDragDelegate` 的对象
    /// - Returns: `Self`
    @discardableResult
    func dragDelegate(_ dragDelegate: UICollectionViewDragDelegate?) -> Self {
        base.dragDelegate = dragDelegate
        return self
    }

    /// 放置代理
    /// - Parameter dropDelegate: 遵循 `UICollectionViewDropDelegate` 的对象
    /// - Returns: `Self`
    @discardableResult
    func dropDelegate(_ dropDelegate: UICollectionViewDropDelegate?) -> Self {
        base.dropDelegate = dropDelegate
        return self
    }

    /// 是否启用拖拽交互
    /// - Parameter dragInteractionEnabled: `true` 表示启用拖拽交互
    /// - Returns: `Self`
    @discardableResult
    func dragInteractionEnabled(_ dragInteractionEnabled: Bool) -> Self {
        base.dragInteractionEnabled = dragInteractionEnabled
        return self
    }

    /// 重排节奏
    /// - Parameter reorderingCadence: 要设置的重排节奏
    /// - Returns: `Self`
    @discardableResult
    func reorderingCadence(_ reorderingCadence: UICollectionView.ReorderingCadence) -> Self {
        base.reorderingCadence = reorderingCadence
        return self
    }

    /// 自适应尺寸的失效策略
    /// - Parameter selfSizingInvalidation: 要设置的自适应尺寸的失效策略
    /// - Returns: `Self`
    @discardableResult
    func selfSizingInvalidation(_ selfSizingInvalidation: UICollectionView.SelfSizingInvalidation) -> Self {
        base.selfSizingInvalidation = selfSizingInvalidation
        return self
    }

    /// 选中是否跟随焦点
    /// - Parameter selectionFollowsFocus: 要设置的选中是否跟随焦点
    /// - Returns: `Self`
    @discardableResult
    func selectionFollowsFocus(_ selectionFollowsFocus: Bool) -> Self {
        base.selectionFollowsFocus = selectionFollowsFocus
        return self
    }

    /// 是否允许获焦
    /// - Parameter allowsFocus: 是否允许获得焦点
    /// - Returns: `Self`
    @discardableResult
    func allowsFocus(_ allowsFocus: Bool) -> Self {
        base.allowsFocus = allowsFocus
        return self
    }

    /// 编辑态下是否允许获焦
    /// - Parameter allowsFocusDuringEditing: 要设置的编辑态下是否允许获焦
    /// - Returns: `Self`
    @discardableResult
    func allowsFocusDuringEditing(_ allowsFocusDuringEditing: Bool) -> Self {
        base.allowsFocusDuringEditing = allowsFocusDuringEditing
        return self
    }

    /// 是否处于编辑态
    /// - Parameter isEditing: `true` 表示处于编辑态
    /// - Returns: `Self`
    @discardableResult
    func isEditing(_ isEditing: Bool) -> Self {
        base.isEditing = isEditing
        return self
    }

    /// 编辑态下是否允许单选
    /// - Parameter allowsSelectionDuringEditing: 要设置的编辑态下是否允许单选
    /// - Returns: `Self`
    @discardableResult
    func allowsSelectionDuringEditing(_ allowsSelectionDuringEditing: Bool) -> Self {
        base.allowsSelectionDuringEditing = allowsSelectionDuringEditing
        return self
    }

    /// 编辑态下是否允许多选
    /// - Parameter allowsMultipleSelectionDuringEditing: 要设置的编辑态下是否允许多选
    /// - Returns: `Self`
    @discardableResult
    func allowsMultipleSelectionDuringEditing(_ allowsMultipleSelectionDuringEditing: Bool) -> Self {
        base.allowsMultipleSelectionDuringEditing = allowsMultipleSelectionDuringEditing
        return self
    }
}
