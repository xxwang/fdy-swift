import Combine
import UIKit

// MARK: - FdyControlProperty

/// 控件属性发布者（可读、可写）。
///
/// - 订阅时**立即重放当前值**，此后在属性变化（用户操作或代码赋值）时持续发出；
/// - 通过 `bind(from:)` 可将上游 publisher 的值写回控件，实现双向绑定。
///
/// 例（双向绑定）：
/// ```swift
/// // 读：用户输入 -> viewModel
/// textField.fdy_textPublisher
///     .compactMap { $0 }
///     .sink { viewModel.name = $0 }
///     .store(in: &cancellables)
///
/// // 写：viewModel -> 控件（无需 eraseToAnyPublisher）
/// textField.fdy_textPublisher.bind(from: viewModel.$name)
/// ```
public struct FdyControlProperty<Value>: Publisher {
    public typealias Output = Value
    public typealias Failure = Never

    private let values: AnyPublisher<Value, Never>
    private let setter: (Value) -> Void

    public func receive<S: Subscriber>(subscriber: S)
        where S.Failure == Failure, S.Input == Output
    {
        values.receive(subscriber: subscriber)
    }

    init(values: AnyPublisher<Value, Never>, setter: @escaping (Value) -> Void) {
        self.values = values
        self.setter = setter
    }

    /// 将上游 publisher 的值写回控件（绑定）。
    ///
    /// - Parameter source: 发送 `Value` 的 publisher（`Output` 须为 `Value`、`Failure` 须为 `Never`）。
    /// - Returns: 可取消的订阅，用于释放绑定。
    ///
    /// - Note: 形参是**泛型** `P: Publisher` 而非 `AnyPublisher`,因此 `Published.Publisher`、
    ///   `Subject`、`FdyControlEvent` 以及 `map`/`filter` 等中间流都可**直接传入**,
    ///   不需要 `.eraseToAnyPublisher()`。刻意收窄 `Failure == Never` —— `sink(receiveValue:)`
    ///   本就要求上游永不失败,放宽到有 `Failure` 的类型会强迫调用侧处理一个不存在完成事件。
    @discardableResult
    public func bind<P: Publisher>(from source: P) -> Cancellable
        where P.Output == Value, P.Failure == Never
    {
        source.sink { [setter] value in
            setter(value)
        }
    }
}
