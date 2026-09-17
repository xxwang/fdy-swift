import Combine
import UIKit

// MARK: - UISlider
public extension UISlider {
    /// 滑块当前值（可读当前值、可绑定写回）。
    ///
    /// 两条**互补**通道合并而成：
    /// - `publisher(for: \.value)`：覆盖**代码赋值**（`value = x`）；
    /// - `.valueChanged`：覆盖用户拖拽与 UIKit 内部调整路径（实测 `accessibilityIncrement()` 改了值、
    ///   发了事件，而 KVO 没发）；
    /// - `removeDuplicates()`：两通道可能对同一次变更各发一次（如 `value = x` 后补发事件），去重兜底。
    ///
    /// - Note: `setValue(_:animated:)` **两个通道都不发**（是独立方法，不走属性 setter），
    ///   需要通知订阅者时改用 `fdy_setValue(_:animated:)`。
    var fdy_valuePublisher: FdyControlProperty<Float> {
        let assigned = publisher(for: \.value, options: [.initial, .new])
        let used = fdy_publisher(for: .valueChanged).map { [weak self] _ in self?.value ?? 0 }
        return FdyControlProperty(
            values: assigned.merge(with: used).removeDuplicates().eraseToAnyPublisher(),
            setter: { [weak self] in self?.value = $0 }
        )
    }

    /// 带动画/不带动画地设置值，并**补发 `.valueChanged`**。
    ///
    /// 原生 `setValue(_:animated:)` 实测既不触发 KVO 也不发事件（`animated: false` 同样如此，
    /// 与动画无关），订阅者会一直持有过期值。本方法在其后补发事件，
    /// 因而合并通道（`fdy_valuePublisher`）能收到新值：
    /// ```swift
    /// slider.fdy_setValue(0.9, animated: true)   // 订阅者能收到 0.9
    /// ```
    /// - Note: 事件会被**所有** `.valueChanged` 监听者收到（含接入方自己 `addTarget` 的）。
    func fdy_setValue(_ value: Float, animated: Bool) {
        setValue(value, animated: animated)
        sendActions(for: .valueChanged)
    }
}
