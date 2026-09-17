import Combine
import UIKit

// MARK: - UILabel
public extension UILabel {
    /// 文本内容（**只有代码赋值会发出**，订阅时立即重放当前值）。
    ///
    /// `UILabel` 没有用户输入，KVO 已覆盖全部变更来源，故不合并事件通道。
    /// `removeDuplicates()` 使「赋同一个值」不再重复发出，与其余 `FdyControlProperty` 语义一致。
    var fdy_textPublisher: FdyControlProperty<String?> {
        FdyControlProperty(
            values: publisher(for: \.text, options: [.initial, .new]).removeDuplicates().eraseToAnyPublisher(),
            setter: { [weak self] in self?.text = $0 }
        )
    }

    /// 富文本内容（可读当前值、可绑定写回）。
    ///
    /// `NSAttributedString` 不是 `Equatable`，去重改用 `isEqual` 比较内容。
    var fdy_attributedTextPublisher: FdyControlProperty<NSAttributedString?> {
        FdyControlProperty(
            values: publisher(for: \.attributedText, options: [.initial, .new]).removeDuplicates { lhs, rhs in
                switch (lhs, rhs) {
                case (nil, nil): true
                case let (l?, r?): l.isEqual(r)
                default: false
                }
            }.eraseToAnyPublisher(),
            setter: { [weak self] in self?.attributedText = $0 }
        )
    }
}
