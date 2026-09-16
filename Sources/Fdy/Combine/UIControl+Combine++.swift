import Combine
import UIKit

// MARK: - UIControl 事件发布者
public extension UIControl {
    /// 通用事件发布者：监听指定的 `UIControl.Event`，取消订阅时自动解绑。
    ///
    /// - Parameter events: 要监听的控件事件（可多个，如 `[.touchDown, .touchUpInside]`）。
    /// - Returns: 发出 `UIControl` 自身的 `ControlEvent`。
    /// - Note: 事件源是**无界**的（UI 事件没有背压概念），但仍遵循 Combine 的 demand 契约：
    ///   下游未请求（`.none`）或需求已用尽时，事件被丢弃。
    func fdy_publisher(for events: UIControl.Event) -> ControlEvent<UIControl> {
        let publisher = SubscribePublisher<UIControl> { [weak self] (subscriber: AnySubscriber<UIControl, Never>) in
            guard let self else { return }
            let subscription = ControlEventSubscription { [weak self] target in
                self?.removeTarget(target, action: #selector(ClosureTarget.invoke), for: events)
            }
            subscription.deliver = { [weak self] in
                guard let self else { return .none }
                return subscriber.receive(self)
            }
            // 先交付 subscription（Combine 约定的顺序），再挂 target
            subscriber.receive(subscription: subscription)
            // 订阅方可能在 receive(subscription:) 内部就取消，此时不应再挂 target
            guard !subscription.cancelled else { return }
            self.addTarget(subscription.target, action: #selector(ClosureTarget.invoke), for: events)
        }.eraseToAnyPublisher()
        return ControlEvent(publisher)
    }

    /// 点击（`.touchUpInside`）。
    var fdy_tapPublisher: ControlEvent<Void> {
        ControlEvent(fdy_publisher(for: .touchUpInside).map { _ in () }.eraseToAnyPublisher())
    }

    /// 值变化（`.valueChanged`），发出 `UIControl` 自身。
    var fdy_valueChangedPublisher: ControlEvent<UIControl> {
        fdy_publisher(for: .valueChanged)
    }
}
