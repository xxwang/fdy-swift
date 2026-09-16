import Combine
import Foundation
import UIKit

// MARK: - 内部辅助

/// target-action 桥接：将 `UIControl` / `UIGestureRecognizer` 的回调转发为闭包。
/// 由订阅持有的 `AnyCancellable` 强引用，订阅取消时随 `removeTarget` 一起释放，无悬挂引用。
final class ClosureTarget: NSObject {
    /// 事件触发时调用。`ControlEventSubscription` 以**弱引用**回指订阅对象，避免强引用环。
    var onInvoke: (() -> Void)?

    init(onInvoke: (() -> Void)? = nil) {
        self.onInvoke = onInvoke
        super.init()
    }

    @objc func invoke(_ sender: Any) {
        onInvoke?()
    }
}

/// 控件事件的订阅：强持有 `target` 以保证其在订阅期间存活；取消时执行清理（如 `removeTarget`）。
/// 不直接依赖 `AnyCancellable`（本环境下其不遵循 `Subscription`），用最小 `Subscription` 实现。
///
/// 与初版的两点差别：
/// 1. **跟踪 demand** —— 只在下游仍有需求时投递，并把 `receive` 返回的新增 demand 计入（Combine 契约）。
///    初版 `request(_:)` 是空实现且返回值被丢弃，`demand == .none` 时依然会投递。
/// 2. **`cancel()` 语义完整** —— 置位取消标记、断开 `deliver`；清理闭包以 `target` 为入参注入，
///    避免 `target -> subscription` 的强引用环。
final class ControlEventSubscription: Subscription {
    let target = ClosureTarget()

    /// 投递一次事件，返回下游新增的 demand（通常为 `.none`）
    var deliver: (() -> Subscribers.Demand)?

    /// 订阅方是否已取消（供「先交付 subscription 再挂 target」时做竞态判断）
    var cancelled: Bool {
        isCancelled
    }

    private var demand: Subscribers.Demand = .none
    private var isCancelled = false
    private let cleanup: (ClosureTarget) -> Void

    init(cleanup: @escaping (ClosureTarget) -> Void) {
        self.cleanup = cleanup
        target.onInvoke = { [weak self] in self?.flush() }
    }

    func request(_ demand: Subscribers.Demand) {
        guard !isCancelled else { return }
        self.demand += demand
    }

    func cancel() {
        guard !isCancelled else { return }
        isCancelled = true
        target.onInvoke = nil
        deliver = nil // 断开对下游的强引用，避免取消后仍构成引用环
        cleanup(target)
    }

    private func flush() {
        guard !isCancelled, demand > 0 else { return }
        demand -= 1
        demand += deliver?() ?? .none
    }
}

// MARK: - 关联对象
//
// 关联对象统一走 `Core/Extensions/Foundation/NSObject++.swift` 的 `fdy_SetAO` / `fdy_GetAO`。
// 初版本文件内另有一套 `fdy_setAssociatedObject` / `fdy_getAssociatedObject`，注释称
// 「避免依赖 FdyCore」，但 `Package.swift` 只有单个 target `Fdy` —— `Core/` 与本目录同属一个模块，
// 该前提不成立，故删除重复实现（`fdy_GetAO` 另带泛型版本，取用时不必再手写 `as?` 转换）。

// MARK: - SubscribePublisher

/// 极简发布者：等价于 `AnyPublisher.init(_ subscribe:)` 的内部实现，
/// 用于以「subscribe 闭包」方式构造发布者而避开 `AnyPublisher` 两个 `init` 的重载歧义。
struct SubscribePublisher<Output>: Publisher {
    typealias Failure = Never

    private let subscribe: (AnySubscriber<Output, Failure>) -> Void

    init(_ subscribe: @escaping (AnySubscriber<Output, Failure>) -> Void) {
        self.subscribe = subscribe
    }

    func receive<S: Subscriber>(subscriber: S)
        where S.Failure == Failure, S.Input == Output
    {
        subscribe(AnySubscriber(subscriber))
    }
}
