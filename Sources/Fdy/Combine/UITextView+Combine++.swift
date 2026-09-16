import Combine
import UIKit

// MARK: - UITextView
public extension UITextView {
    /// 文本内容（**用户编辑与代码赋值均会发出**，订阅时立即重放当前值）。
    ///
    /// 两条**互补**通道合并而成：
    /// - `publisher(for: \.text)`：只覆盖**代码赋值**（`tv.text = x`）；
    /// - `textDidChangeNotification`：`UITextView` 不是 `UIControl`，没有 `.editingChanged` 可用，
    ///   用户打字走这条通知（实测逐键触发、含组字期；TextKit 直接写 `NSTextStorage`，KVO 全程 0 次）；
    /// - `removeDuplicates()`：同上，配合 `ControlProperty` 阻断回声。
    var fdy_textPublisher: ControlProperty<String?> {
        let assigned = publisher(for: \.text, options: [.initial, .new])
        let typed = NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self)
            .map { [weak self] _ in self?.text }
        return ControlProperty(
            values: assigned.merge(with: typed).removeDuplicates().eraseToAnyPublisher(),
            setter: { [weak self] in self?.text = $0 }
        )
    }

    /// 富文本内容（可读当前值、可绑定写回）。
    ///
    /// `NSAttributedString` 不是 `Equatable`，去重改用 `isEqual` 比较内容。
    var fdy_attributedTextPublisher: ControlProperty<NSAttributedString?> {
        let assigned = publisher(for: \.attributedText, options: [.initial, .new])
        let typed = NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self)
            .map { [weak self] _ in self?.attributedText }
        return ControlProperty(
            values: assigned.merge(with: typed).removeDuplicates { lhs, rhs in
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
