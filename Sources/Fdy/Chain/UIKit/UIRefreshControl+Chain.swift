import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIRefreshControl {
    /// 设置富文本标题
    /// - Parameters:
    ///   - title: 标题文本
    ///   - attributes: 富文本属性(如字体、颜色)
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String, attributes: [NSAttributedString.Key: Any] = [:]) -> Self {
        base.attributedTitle = NSAttributedString(string: title, attributes: attributes)
        return self
    }

    /// 绑定刷新事件回调
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 回调方法(需带 `@objc` 标记)
    /// - Returns: `Self`
    @discardableResult
    func addTarget(_ target: Any?, action: Selector) -> Self {
        base.addTarget(target, action: action, for: .valueChanged)
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension FdyWrapper where Base: UIRefreshControl {
    /// 开始刷新
    /// - Parameters:
    ///   - scrollView: 所属的 UIScrollView(如 UITableView / UICollectionView)
    ///   - animated: 是否动画滚动到刷新位置
    ///   - triggerRefreshHandler: 是否立即触发 `.valueChanged` 事件(默认 false)
    /// - Returns: `Self`
    @discardableResult
    func startRefreshing(in scrollView: UIScrollView, animated: Bool, triggerRefreshHandler: Bool = false) -> Self {
        if base.superview == nil || base.superview !== scrollView {
            scrollView.refreshControl = base
        }

        base.beginRefreshing()

        // 仅当当前未处于刷新偏移状态时,才调整 contentOffset
        let refreshOffset = -base.frame.height
        if scrollView.contentOffset.y > refreshOffset {
            let newOffset = CGPoint(x: scrollView.contentOffset.x, y: refreshOffset)
            scrollView.setContentOffset(newOffset, animated: animated)
        }

        if triggerRefreshHandler {
            base.sendActions(for: .valueChanged)
        }
        return self
    }

    /// 停止刷新
    /// - Parameter animated: 是否以动画方式恢复原始滚动位置
    /// - Returns: `Self`
    @discardableResult
    func stopRefreshing(animated: Bool = true) -> Self {
        base.endRefreshing()

        guard let scrollView = base.superview as? UIScrollView else { return self }

        // 仅当当前处于“被拉下”状态时才重置 contentOffset,回到真正的顶部(考虑 contentInset.top)
        let refreshOffset = -base.frame.height
        if scrollView.contentOffset.y <= refreshOffset {
            let topOffset = -scrollView.contentInset.top
            if animated {
                UIView.animate(withDuration: 0.25) {
                    scrollView.contentOffset.y = topOffset
                }
            } else {
                scrollView.contentOffset.y = topOffset
            }
        }
        return self
    }
}
