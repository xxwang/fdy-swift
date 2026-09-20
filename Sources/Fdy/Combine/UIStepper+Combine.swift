import Combine
import UIKit

// MARK: - UIStepper
public extension UIStepper {
    /// 当前步进值（可读当前值、可绑定写回）。
    ///
    /// 两条**互补**通道合并而成：`publisher(for: \.value)` 覆盖代码赋值，
    /// `.valueChanged` 覆盖用户点击 +/- 与长按连续步进；`removeDuplicates()` 兜底同值重发。
    /// - Returns: 控件属性发布者
    var fdy_valuePublisher: FdyControlProperty<Double> {
        let assigned = publisher(for: \.value, options: [.initial, .new])
        let used = fdy_publisher(for: .valueChanged).map { [weak self] _ in self?.value ?? 0 }
        return FdyControlProperty(
            values: assigned.merge(with: used).removeDuplicates().eraseToAnyPublisher(),
            setter: { [weak self] in self?.value = $0 }
        )
    }
}
