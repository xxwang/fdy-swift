import Combine
import UIKit

// MARK: - UIScrollView 滚动事件发布者（delegate 代理）

/// `UIScrollViewDelegate` 代理：接管滚动回调并转发给原有的 `delegate`，
/// 同时通过 `PassthroughSubject` 对外暴露各滚动事件，供 Combine 订阅。
///
/// - Note: 仅本文件使用，故声明为 `private`，不作为模块 API 暴露（初版为 internal 且无前缀）。
/// - Note: `originalDelegate` 是 `weak` —— 原 delegate 被释放后转发链自然断开，
///   不会造成泄漏，但原 delegate 此后也收不到回调。
private final class FdyScrollViewDelegateProxy: NSObject, UIScrollViewDelegate {
    weak var originalDelegate: UIScrollViewDelegate?

    let didScroll = PassthroughSubject<Void, Never>()
    let willBeginDragging = PassthroughSubject<Void, Never>()
    /// 载荷为 `willDecelerate`
    let didEndDragging = PassthroughSubject<Bool, Never>()
    let willBeginDecelerating = PassthroughSubject<Void, Never>()
    let didEndDecelerating = PassthroughSubject<Void, Never>()
    let didEndScrollingAnimation = PassthroughSubject<Void, Never>()
    let didZoom = PassthroughSubject<Void, Never>()
    let didChangeAdjustedContentInset = PassthroughSubject<Void, Never>()

    /// 未由本代理实现的 delegate 方法，转发给原 delegate
    override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        return originalDelegate?.responds(to: aSelector) ?? false
    }

    /// 只有原 delegate 确实响应时才转发。
    ///
    /// 初版无条件返回 `originalDelegate`：原 delegate 不响应该 selector、或在
    /// `responds(to:)` 与转发之间被释放（`weak`）时，消息会落到代理身上，
    /// 最终以「原 delegate 的身份」抛出 `unrecognized selector`，错误归属误导排查。
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let originalDelegate, originalDelegate.responds(to: aSelector) {
            return originalDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll.send(())
        originalDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDragging.send(())
        originalDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging.send(decelerate)
        originalDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        willBeginDecelerating.send(())
        originalDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating.send(())
        originalDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimation.send(())
        originalDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        didZoom.send(())
        originalDelegate?.scrollViewDidZoom?(scrollView)
    }

    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        didChangeAdjustedContentInset.send(())
        originalDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}

public extension UIScrollView {
    private nonisolated(unsafe) static var fdy_delegateProxyKey: UInt8 = 0

    /// 懒加载、缓存并（必要时）**重新接管** delegate 代理。
    ///
    /// 首次访问会把当前 `delegate` 记为转发目标并顶替之。若此后接入方又自行设置了
    /// `scrollView.delegate = X`，代理会被静默顶掉 —— 因此缓存命中时会检查「我现在还是不是
    /// delegate」，不是则把当前 delegate 记为新的转发目标并重新接管，使 8 个 publisher 自动恢复。
    /// 初版没有这一步：代理被顶掉后再次访问只会拿到「已不是 delegate 的缓存代理」，
    /// 所有 publisher 永久失效，且无任何报错。
    private var fdy_delegateProxy: FdyScrollViewDelegateProxy {
        if let existing = fdy_GetAO(forKey: &Self.fdy_delegateProxyKey) as? FdyScrollViewDelegateProxy {
            let isAlreadyAttached = (delegate as AnyObject?) === existing
            if !isAlreadyAttached {
                existing.originalDelegate = delegate
                delegate = existing
            }
            return existing
        }
        let proxy = FdyScrollViewDelegateProxy()
        proxy.originalDelegate = delegate
        delegate = proxy
        fdy_SetAO(proxy, forKey: &Self.fdy_delegateProxyKey)
        return proxy
    }

    /// 滚动中（contentOffset 变化）
    var fdy_didScrollPublisher: FdyControlEvent<Void> {
        FdyControlEvent(fdy_delegateProxy.didScroll.eraseToAnyPublisher())
    }

    /// 即将开始拖拽
    var fdy_willBeginDraggingPublisher: FdyControlEvent<Void> {
        FdyControlEvent(fdy_delegateProxy.willBeginDragging.eraseToAnyPublisher())
    }

    /// 结束拖拽（丢弃 `willDecelerate`，需要该值请用
    /// `fdy_didEndDraggingWithDecelerationPublisher`）
    var fdy_didEndDraggingPublisher: FdyControlEvent<Void> {
        FdyControlEvent(fdy_delegateProxy.didEndDragging.map { _ in () }.eraseToAnyPublisher())
    }

    /// 结束拖拽，载荷为 `willDecelerate`（是否将继续减速）
    var fdy_didEndDraggingWithDecelerationPublisher: FdyControlEvent<Bool> {
        FdyControlEvent(fdy_delegateProxy.didEndDragging.eraseToAnyPublisher())
    }

    /// 即将开始减速
    var fdy_willBeginDeceleratingPublisher: FdyControlEvent<Void> {
        FdyControlEvent(fdy_delegateProxy.willBeginDecelerating.eraseToAnyPublisher())
    }

    /// 结束减速
    var fdy_didEndDeceleratingPublisher: FdyControlEvent<Void> {
        FdyControlEvent(fdy_delegateProxy.didEndDecelerating.eraseToAnyPublisher())
    }

    /// 滚动动画结束
    var fdy_didEndScrollingAnimationPublisher: FdyControlEvent<Void> {
        FdyControlEvent(fdy_delegateProxy.didEndScrollingAnimation.eraseToAnyPublisher())
    }

    /// 缩放中
    var fdy_didZoomPublisher: FdyControlEvent<Void> {
        FdyControlEvent(fdy_delegateProxy.didZoom.eraseToAnyPublisher())
    }

    /// 调整内容缩进变化
    var fdy_didChangeAdjustedContentInsetPublisher: FdyControlEvent<Void> {
        FdyControlEvent(fdy_delegateProxy.didChangeAdjustedContentInset.eraseToAnyPublisher())
    }

    /// 滚动位置（**值流**，可读可绑定写回）：订阅时立即重放当前偏移，此后每次变化都发出。
    ///
    /// 实测 `contentOffset` 的 KVO 连 `setContentOffset(_:animated:)` 的动画内部路径都可靠
    /// （逐帧回调），因此不再需要事件通道对照 —— 这一点与 `UISlider.value` 恰好相反，
    /// 说明「KVO 是否可靠」是逐类结论，不能类推。
    var fdy_contentOffsetPublisher: FdyControlProperty<CGPoint> {
        FdyControlProperty(
            values: publisher(for: \.contentOffset, options: [.initial, .new])
                .removeDuplicates()
                .eraseToAnyPublisher(),
            setter: { [weak self] in self?.contentOffset = $0 }
        )
    }
}
