import Combine
import UIKit

// MARK: - UITextField
public extension UITextField {
    /// 文本内容（**用户编辑与代码赋值均会发出**，订阅时立即重放当前值）。
    ///
    /// 两条**互补**通道合并而成，缺一即「半边失明」：
    /// - `publisher(for: \.text)`：KVO 只观察属性 setter，因此只覆盖**代码赋值**（`text = x`）；
    /// - `.editingChanged`：用户打字不经过 `setText:`（UIKit 直接写内部文本存储），只有事件通道能看到；
    /// - `removeDuplicates()`：`resignFirstResponder()` 时 UIKit 会把内部文本同步回属性，
    ///   同一值会再走一次 KVO —— 去重挡掉它，同时也阻断双向绑定的回声（见 `ControlProperty`）。
    ///
    /// - Note: 组字期（拼音未上屏）事件通道发出的是**含 marked text 的中间串**（如 `"nihao"`）。
    ///   需要上屏后的文本时请自行判 `markedTextRange == nil`。
    var fdy_textPublisher: ControlProperty<String?> {
        let assigned = publisher(for: \.text, options: [.initial, .new])
        let typed = fdy_publisher(for: .editingChanged).map { [weak self] _ in self?.text }
        return ControlProperty(
            values: assigned.merge(with: typed).removeDuplicates().eraseToAnyPublisher(),
            setter: { [weak self] in self?.text = $0 }
        )
    }

    /// 富文本内容（可读当前值、可绑定写回）。
    ///
    /// 与 `fdy_textPublisher` 同一构造：实测 `.editingChanged` 触发时 `attributedText`
    /// **已经是新值**，所以事件通道读 `attributedText` 是安全的。
    /// `NSAttributedString` 不是 `Equatable`，去重改用 `isEqual` 比较内容。
    var fdy_attributedTextPublisher: ControlProperty<NSAttributedString?> {
        let assigned = publisher(for: \.attributedText, options: [.initial, .new])
        let typed = fdy_publisher(for: .editingChanged).map { [weak self] _ in self?.attributedText }
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
