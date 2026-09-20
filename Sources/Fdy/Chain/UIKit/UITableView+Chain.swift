import UIKit

// MARK: - Cell 注册与复用
public extension FdyWrapper where Base: UITableView {
    /// 使用类名注册`纯代码` `Cell`
    /// - Parameter cellType: `Cell` 类型(需继承 `UITableViewCell`)
    /// - Returns: `Self`
    @discardableResult
    func register(withCellClass cellType: (some UITableViewCell).Type) -> Self {
        base.register(cellType, forCellReuseIdentifier: cellType.fdy_identifier)
        return self
    }

    /// 使用 `Nib` 注册 `Cell`
    /// - Parameters:
    ///   - nib: Nib 对象(可为 nil)
    ///   - cellType: Cell 类型
    /// - Returns: `Self`
    @discardableResult
    func register(nib: UINib?, withCellClass cellType: (some UITableViewCell).Type) -> Self {
        base.register(nib, forCellReuseIdentifier: cellType.fdy_identifier)
        return self
    }

    /// 自动从同名 `XIB` 注册 `Cell`(`XIB` 文件名必须与类名一致)
    /// - Parameters:
    ///   - cellType: `Cell` 类型
    ///   - bundleClass: 用于定位 `Bundle` 的参考类(默认使用 `Cell` 所在 `Bundle`)
    /// - Returns: `Self`
    @discardableResult
    func register(nibWithCellClass cellType: (some UITableViewCell).Type, at bundleClass: AnyClass? = nil) -> Self {
        let bundle = bundleClass.map { Bundle(for: $0) } ?? Bundle(for: cellType)
        let nib = UINib(nibName: cellType.fdy_identifier, bundle: bundle)
        base.register(nib, forCellReuseIdentifier: cellType.fdy_identifier)
        return self
    }

    /// 使用类名注册 `Header/Footer View`(纯代码)
    /// - Parameter viewType: 回调闭包
    /// - Returns: `Self`
    @discardableResult
    func register(withHeaderFooterViewClass viewType: (some UITableViewHeaderFooterView).Type) -> Self {
        base.register(viewType, forHeaderFooterViewReuseIdentifier: viewType.fdy_identifier)
        return self
    }

    /// 使用 `Nib` 注册 `Header/Footer View`
    /// - Parameters:
    ///   - nib: 要注册的界面文件
    ///   - viewType: 回调闭包
    /// - Returns: `Self`
    @discardableResult
    func register(
        nib: UINib?,
        withHeaderFooterViewClass viewType: (some UITableViewHeaderFooterView).Type
    ) -> Self {
        base.register(nib, forHeaderFooterViewReuseIdentifier: viewType.fdy_identifier)
        return self
    }
}

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UITableView {
    ///  `delegate`,传 `nil` 可清空
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UITableViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    ///  `dataSource`,传 `nil` 可清空
    /// - Parameter dataSource: 数据源对象
    /// - Returns: `Self`
    @discardableResult
    func dataSource(_ dataSource: UITableViewDataSource?) -> Self {
        base.dataSource = dataSource
        return self
    }

    /// 链式注册 `Cell`(纯代码)
    /// - Parameter cellType: `UITableViewCell`子类
    /// - Returns: `Self`
    @discardableResult
    func register(_ cellType: (some UITableViewCell).Type) -> Self {
        self.register(withCellClass: cellType)
        return self
    }

    /// 行高(若使用自动布局,请设为 `UITableView.automaticDimension`)
    /// - Parameter height: 行高
    /// - Returns: `Self`
    @discardableResult
    func rowHeight(_ height: CGFloat) -> Self {
        base.rowHeight = height
        return self
    }

    /// 段头高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func sectionHeaderHeight(_ height: CGFloat) -> Self {
        base.sectionHeaderHeight = height
        return self
    }

    /// 段尾高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func sectionFooterHeight(_ height: CGFloat) -> Self {
        base.sectionFooterHeight = height
        return self
    }

    /// 预估行高(提升滚动性能)
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func estimatedRowHeight(_ height: CGFloat) -> Self {
        base.estimatedRowHeight = height
        return self
    }

    /// 预估段头高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        base.estimatedSectionHeaderHeight = height
        return self
    }

    /// 预估段尾高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        base.estimatedSectionFooterHeight = height
        return self
    }

    /// 是否让 `Cell` 的 `layoutMargins` 跟随` readable width`(影响 iOS 8+ 的左右留白)
    /// - Parameter enabled: 是否开启
    /// - Returns: `Self`
    @discardableResult
    func cellLayoutMarginsFollowReadableWidth(_ enabled: Bool) -> Self {
        base.cellLayoutMarginsFollowReadableWidth = enabled
        return self
    }

    /// 分割线样式
    /// - Parameter style: 分割线样式
    /// - Returns: `Self`
    @discardableResult
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        base.separatorStyle = style
        return self
    }

    /// 表格头部视图(`tableHeaderView`)
    /// - Parameter view: 列表头部视图;传 `nil` 即移除
    /// - Returns: `Self`
    @discardableResult
    func tableHeaderView(_ view: UIView?) -> Self {
        base.tableHeaderView = view
        return self
    }

    /// 表格尾部视图(`tableFooterView`)
    /// - Parameter view: 列表尾部视图;传 `nil` 即移除
    /// - Returns: `Self`
    @discardableResult
    func tableFooterView(_ view: UIView?) -> Self {
        base.tableFooterView = view
        return self
    }

    /// 段头顶部额外间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func sectionHeaderTopPadding(_ padding: CGFloat) -> Self {
        base.sectionHeaderTopPadding = padding
        return self
    }
}

// MARK: - 链式方法
public extension FdyWrapper where Base: UITableView {
    /// 滚动到最近选中的行
    /// - Parameters:
    ///   - position: 位置
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToNearestSelectedRow(at position: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        base.scrollToNearestSelectedRow(at: position, animated: animated)
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension FdyWrapper where Base: UITableView {
    /// 滚动到指定 `IndexPath`
    /// - Parameters:
    ///   - indexPath: 目标`IndexPath`
    ///   - position: 位置
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollTo(_ indexPath: IndexPath, at position: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        guard
            indexPath.section >= 0,
            indexPath.row >= 0,
            indexPath.section < base.numberOfSections,
            indexPath.row < base.numberOfRows(inSection: indexPath.section)
        else { return self }
        base.scrollToRow(at: indexPath, at: position, animated: animated)
        return self
    }

    /// 预取数据源
    /// - Parameter prefetchDataSource: 遵循 `UITableViewDataSourcePrefetching` 的对象
    /// - Returns: `Self`
    @discardableResult
    func prefetchDataSource(_ prefetchDataSource: UITableViewDataSourcePrefetching?) -> Self {
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
    /// - Parameter dragDelegate: 遵循 `UITableViewDragDelegate` 的对象
    /// - Returns: `Self`
    @discardableResult
    func dragDelegate(_ dragDelegate: UITableViewDragDelegate?) -> Self {
        base.dragDelegate = dragDelegate
        return self
    }

    /// 放置代理
    /// - Parameter dropDelegate: 遵循 `UITableViewDropDelegate` 的对象
    /// - Returns: `Self`
    @discardableResult
    func dropDelegate(_ dropDelegate: UITableViewDropDelegate?) -> Self {
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

    /// 填充行高度
    /// - Parameter fillerRowHeight: 要设置的填充行高度
    /// - Returns: `Self`
    @discardableResult
    func fillerRowHeight(_ fillerRowHeight: CGFloat) -> Self {
        base.fillerRowHeight = fillerRowHeight
        return self
    }

    /// 自适应尺寸的失效策略
    /// - Parameter selfSizingInvalidation: 要设置的自适应尺寸的失效策略
    /// - Returns: `Self`
    @discardableResult
    func selfSizingInvalidation(_ selfSizingInvalidation: UITableView.SelfSizingInvalidation) -> Self {
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

    /// 内容抗拉伸元素
    /// - Parameter contentHuggingElements: 要设置的内容抗拉伸元素
    /// - Returns: `Self`
    @discardableResult
    func contentHuggingElements(_ contentHuggingElements: UITableViewContentHuggingElements) -> Self {
        base.contentHuggingElements = contentHuggingElements
        return self
    }
}
