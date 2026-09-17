import Combine
import UIKit

// MARK: - UISegmentedControl
public extension UISegmentedControl {
    /// 当前选中项索引（可读当前值、可绑定写回）。
    ///
    /// 两条**互补**通道合并而成：`publisher(for: \.selectedSegmentIndex)` 覆盖代码赋值，
    /// `.valueChanged` 覆盖用户点选；`removeDuplicates()` 兜底同值重发。
    ///
    /// - Note: 无选中项时 `selectedSegmentIndex` 为 `-1`，订阅初值会发出 `-1`。
    var fdy_selectedSegmentIndexPublisher: FdyControlProperty<Int> {
        let assigned = publisher(for: \.selectedSegmentIndex, options: [.initial, .new])
        let used = fdy_publisher(for: .valueChanged).map { [weak self] _ in self?.selectedSegmentIndex ?? -1 }
        return FdyControlProperty(
            values: assigned.merge(with: used).removeDuplicates().eraseToAnyPublisher(),
            setter: { [weak self] in self?.selectedSegmentIndex = $0 }
        )
    }
}
