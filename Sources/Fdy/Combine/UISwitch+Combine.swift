import Combine
import UIKit

// MARK: - UISwitch
public extension UISwitch {
    /// 开关状态（可读当前值、可绑定写回）。
    ///
    /// 两条**互补**通道合并而成：`publisher(for: \.isOn)` 覆盖代码赋值，
    /// `.valueChanged` 覆盖用户点击与 UIKit 内部调整路径；`removeDuplicates()` 兜底同值重发。
    ///
    /// - Returns: 控件属性发布者
    /// - Note: `setOn(_:animated:)` **两个通道都不发**，需要通知订阅者时改用 `fdy_setOn(_:animated:)`。
    var fdy_isOnPublisher: FdyControlProperty<Bool> {
        let assigned = publisher(for: \.isOn, options: [.initial, .new])
        let used = fdy_publisher(for: .valueChanged).map { [weak self] _ in self?.isOn ?? false }
        return FdyControlProperty(
            values: assigned.merge(with: used).removeDuplicates().eraseToAnyPublisher(),
            setter: { [weak self] in self?.isOn = $0 }
        )
    }

    /// 带动画/不带动画地设置开关，并**补发 `.valueChanged`**（原生 `setOn(_:animated:)` 不发任何通知）。
    /// - Parameters:
    ///   - isOn: 开关状态
    ///   - animated: 是否启用动画
    func fdy_setOn(_ isOn: Bool, animated: Bool) {
        setOn(isOn, animated: animated)
        sendActions(for: .valueChanged)
    }
}
