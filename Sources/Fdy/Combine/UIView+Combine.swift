import Combine
import UIKit

// MARK: - UIView 手势发布者
public extension UIView {
    /// 已添加手势的缓存键（避免重复添加同一手势）
    private nonisolated(unsafe) static var fdy_gestureCacheKey: UInt8 = 0

    private var fdy_gestureCache: [String: UIGestureRecognizer] {
        get {
            let cache: [String: UIGestureRecognizer] = fdy_GetAO(forKey: &Self.fdy_gestureCacheKey) ?? [:]
            return cache
        }
        set { fdy_SetAO(newValue, forKey: &Self.fdy_gestureCacheKey) }
    }

    /// 获取或创建并缓存手势识别器（同一 key 复用，不重复添加）
    private func fdy_cachedGesture<G: UIGestureRecognizer>(key: String, make: () -> G) -> G {
        if let existing = fdy_gestureCache[key] as? G {
            return existing
        }
        let recognizer = make()
        addGestureRecognizer(recognizer)
        var cache = fdy_gestureCache
        cache[key] = recognizer
        fdy_gestureCache = cache
        return recognizer
    }

    /// 将手势识别器包装为 `FdyControlEvent`（订阅取消时移除 target）
    ///
    /// - Note: 同一识别器上多个订阅者各挂一个 `ClosureTarget`，一次手势会向所有订阅者各投递一次。
    private func fdy_event<G: UIGestureRecognizer>(_ recognizer: G) -> FdyControlEvent<G> {
        let publisher = SubscribePublisher<G> { [recognizer] (subscriber: AnySubscriber<G, Never>) in
            let subscription = FdyControlEventSubscription { target in
                recognizer.removeTarget(target, action: #selector(ClosureTarget.invoke))
            }
            subscription.deliver = { [weak recognizer] in
                guard let recognizer else { return .none }
                return subscriber.receive(recognizer)
            }
            subscriber.receive(subscription: subscription)
            guard !subscription.cancelled else { return }
            recognizer.addTarget(subscription.target, action: #selector(ClosureTarget.invoke))
        }.eraseToAnyPublisher()
        return FdyControlEvent(publisher)
    }

    // MARK: 具体手势
    //
    // - Note: 以下每个访问器都会把 `isUserInteractionEnabled` 置为 `true`，
    //   并在首次访问时把识别器加入手势列表（不可撤销的写副作用）。
    //   若不需要该行为，请自行创建并 `addGestureRecognizer`。

    /// 点击手势
    ///
    /// - Parameter numberOfTaps: 需要的点击次数；不同次数各自缓存一个识别器，互不干扰
    ///   （初版固定按 `"tap"` 缓存，无法同时注册单击与双击）。
    func fdy_tapGesturePublisher(numberOfTaps: Int = 1) -> FdyControlEvent<UITapGestureRecognizer> {
        isUserInteractionEnabled = true
        return fdy_event(fdy_cachedGesture(key: "tap-\(numberOfTaps)") {
            let recognizer = UITapGestureRecognizer()
            recognizer.numberOfTapsRequired = numberOfTaps
            return recognizer
        })
    }

    /// 单击手势（等价于 `fdy_tapGesturePublisher(numberOfTaps: 1)`）
    var fdy_tapGesturePublisher: FdyControlEvent<UITapGestureRecognizer> {
        fdy_tapGesturePublisher()
    }

    /// 轻扫手势（可指定方向，不同方向各自缓存）
    func fdy_swipeGesturePublisher(_ direction: UISwipeGestureRecognizer.Direction = .right) -> FdyControlEvent<UISwipeGestureRecognizer> {
        isUserInteractionEnabled = true
        return fdy_event(fdy_cachedGesture(key: "swipe-\(direction.rawValue)") {
            let recognizer = UISwipeGestureRecognizer()
            recognizer.direction = direction
            return recognizer
        })
    }

    /// 长按手势
    var fdy_longPressGesturePublisher: FdyControlEvent<UILongPressGestureRecognizer> {
        isUserInteractionEnabled = true
        return fdy_event(fdy_cachedGesture(key: "longPress") { UILongPressGestureRecognizer() })
    }

    /// 拖动手势
    var fdy_panGesturePublisher: FdyControlEvent<UIPanGestureRecognizer> {
        isUserInteractionEnabled = true
        return fdy_event(fdy_cachedGesture(key: "pan") { UIPanGestureRecognizer() })
    }

    /// 捏合手势
    var fdy_pinchGesturePublisher: FdyControlEvent<UIPinchGestureRecognizer> {
        isUserInteractionEnabled = true
        return fdy_event(fdy_cachedGesture(key: "pinch") { UIPinchGestureRecognizer() })
    }

    /// 旋转手势
    var fdy_rotationGesturePublisher: FdyControlEvent<UIRotationGestureRecognizer> {
        isUserInteractionEnabled = true
        return fdy_event(fdy_cachedGesture(key: "rotation") { UIRotationGestureRecognizer() })
    }

    /// 屏幕边缘拖动手势
    var fdy_screenEdgePanGesturePublisher: FdyControlEvent<UIScreenEdgePanGestureRecognizer> {
        isUserInteractionEnabled = true
        return fdy_event(fdy_cachedGesture(key: "screenEdgePan") { UIScreenEdgePanGestureRecognizer() })
    }
}
