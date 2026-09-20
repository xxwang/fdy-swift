import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UITextView {
    /// 是否可编辑
    /// - Parameter isEditable: 是否可以编辑
    /// - Returns: `Self`
    @discardableResult
    func isEditable(_ isEditable: Bool) -> Self {
        base.isEditable = isEditable
        return self
    }

    /// 清空文本内容
    /// - Returns: `Self`
    @discardableResult
    func clear() -> Self {
        base.attributedText = NSAttributedString()
        return self
    }

    /// 纯文本内容
    /// - Parameter text: 要设置的内容
    /// - Returns: `Self`
    @discardableResult
    func text(_ text: String) -> Self {
        base.text = text
        return self
    }

    /// 富文本内容
    /// - Parameter attributedText: 要设置的富文本内容
    /// - Returns: `Self`
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString) -> Self {
        base.attributedText = attributedText
        return self
    }

    /// 文本对齐方式
    /// - Parameter alignment: 要设置的对齐方式
    /// - Returns: `Self`
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        base.textAlignment = alignment
        return self
    }

    /// 文本颜色
    /// - Parameter color: 要设置的颜色
    /// - Returns: `Self`
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        base.textColor = color
        return self
    }

    /// 字体
    /// - Parameter font: 要设置的字体
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        base.font = font
        return self
    }

    /// 代理,传 `nil` 可清空
    /// - Parameter delegate: 要设置的代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UITextViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 键盘类型
    /// - Parameter type: 要设置的键盘类型
    /// - Returns: `Self`
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Self {
        base.keyboardType = type
        return self
    }

    /// `Return`键类型
    /// - Parameter type: 要设置的类型
    /// - Returns: `Self`
    @discardableResult
    func returnKeyType(_ type: UIReturnKeyType) -> Self {
        base.returnKeyType = type
        return self
    }

    /// 是否自动启用/禁用 `Return`键(基于内容是否为空)
    /// - Parameter enabled: 是否开启
    /// - Returns: `Self`
    @discardableResult
    func enablesReturnKeyAutomatically(_ enabled: Bool) -> Self {
        base.enablesReturnKeyAutomatically = enabled
        return self
    }

    /// 文本容器外边距
    /// - Parameter inset: 外边距
    /// - Returns: `Self`
    @discardableResult
    func textContainerInset(_ inset: UIEdgeInsets) -> Self {
        base.textContainerInset = inset
        return self
    }

    /// 行片段左右内边距(通常设为 0 以贴边)
    /// - Parameter padding: 内边距
    /// - Returns: `Self`
    @discardableResult
    func lineFragmentPadding(_ padding: CGFloat) -> Self {
        base.textContainer.lineFragmentPadding = padding
        return self
    }

    /// 是否可选择文本
    /// - Parameter selectable: 是否可选择
    /// - Returns: `Self`
    @discardableResult
    func isSelectable(_ selectable: Bool) -> Self {
        base.isSelectable = selectable
        return self
    }

    /// 数据检测类型(自动识别电话、链接等)
    /// - Parameter types: 检测类型,如 `.link` / `.phoneNumber`
    /// - Returns: `Self`
    @discardableResult
    func dataDetectorTypes(_ types: UIDataDetectorTypes) -> Self {
        base.dataDetectorTypes = types
        return self
    }

    /// 是否允许编辑文本属性(加粗/斜体等)
    /// - Parameter allows: 是否允许
    /// - Returns: `Self`
    @discardableResult
    func allowsEditingTextAttributes(_ allows: Bool) -> Self {
        base.allowsEditingTextAttributes = allows
        return self
    }

    /// 链接文本属性(颜色、下划线等)
    /// - Parameter attributes: 链接属性字典
    /// - Returns: `Self`
    @discardableResult
    func linkTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        base.linkTextAttributes = attributes
        return self
    }

    /// 输入辅助视图(如工具栏)
    /// - Parameter accessoryView: 辅助视图
    /// - Returns: `Self`
    @discardableResult
    func inputAccessoryView(_ accessoryView: UIView?) -> Self {
        base.inputAccessoryView = accessoryView
        return self
    }

    /// 自定义输入视图(替代系统键盘)
    /// - Parameter inputView: 自定义输入视图
    /// - Returns: `Self`
    @discardableResult
    func inputView(_ inputView: UIView?) -> Self {
        base.inputView = inputView
        return self
    }

    /// 当前输入属性(字体、颜色等)
    /// - Parameter attributes: 属性字典
    /// - Returns: `Self`
    @discardableResult
    func typingAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        base.typingAttributes = attributes
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension FdyWrapper where Base: UITextView {
    /// 滚动到文本开头(按 UTF-16 计算,emoji 安全)
    /// - Returns: `Self`
    @discardableResult
    func scrollToTextStart() -> Self {
        let length = base.textStorage.length
        guard length > 0 else { return self }
        base.scrollRangeToVisible(NSRange(location: 0, length: 1))
        return self
    }

    /// 滚动到文本结尾(按 UTF-16 计算,emoji 安全)
    /// - Returns: `Self`
    @discardableResult
    func scrollToTextEnd() -> Self {
        let length = base.textStorage.length
        guard length > 0 else { return self }
        base.scrollRangeToVisible(NSRange(location: max(0, length - 1), length: 1))
        return self
    }

    /// 自动调整视图大小以适应内容(常用于动态高度`TextView`)
    /// - Returns: `Self`
    @discardableResult
    func wrapToContent() -> Self {
        base.contentInset = .zero
        base.scrollIndicatorInsets = .zero
        base.contentOffset = .zero
        base.textContainerInset = .zero
        base.textContainer.lineFragmentPadding = 0
        base.sizeToFit()
        return self
    }

    /// 是否启用查找交互
    /// - Parameter isFindInteractionEnabled: `true` 表示启用查找交互
    /// - Returns: `Self`
    @discardableResult
    func isFindInteractionEnabled(_ isFindInteractionEnabled: Bool) -> Self {
        base.isFindInteractionEnabled = isFindInteractionEnabled
        return self
    }

    /// 边框样式
    /// - Parameter borderStyle: 要设置的边框样式
    /// - Returns: `Self`
    @discardableResult
    func borderStyle(_ borderStyle: UITextView.BorderStyle) -> Self {
        base.borderStyle = borderStyle
        return self
    }

    /// 是否使用标准文本缩放
    /// - Parameter usesStandardTextScaling: 是否使用标准文字缩放
    /// - Returns: `Self`
    @discardableResult
    func usesStandardTextScaling(_ usesStandardTextScaling: Bool) -> Self {
        base.usesStandardTextScaling = usesStandardTextScaling
        return self
    }

    /// 高亮文本属性
    /// - Parameter textHighlightAttributes: 富文本属性,传 `nil` 恢复默认
    /// - Returns: `Self`
    @discardableResult
    func textHighlightAttributes(_ textHighlightAttributes: [NSAttributedString.Key: Any]?) -> Self {
        base.textHighlightAttributes = textHighlightAttributes
        return self
    }

    /// 写作工具行为
    /// - Parameter writingToolsBehavior: 要设置的写作工具行为
    /// - Returns: `Self`
    @discardableResult
    func writingToolsBehavior(_ writingToolsBehavior: UIWritingToolsBehavior) -> Self {
        base.writingToolsBehavior = writingToolsBehavior
        return self
    }

    /// 写作工具的结果类型
    /// - Parameter allowedWritingToolsResultOptions: 要设置的写作工具的结果类型
    /// - Returns: `Self`
    @discardableResult
    func allowedWritingToolsResultOptions(
        _ allowedWritingToolsResultOptions: UIWritingToolsResultOptions
    ) -> Self {
        base.allowedWritingToolsResultOptions = allowedWritingToolsResultOptions
        return self
    }

    /// 文本格式化面板的配置
    /// - Parameter textFormattingConfiguration: 配置,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func textFormattingConfiguration(
        _ textFormattingConfiguration: UITextFormattingViewController.Configuration?
    ) -> Self {
        base.textFormattingConfiguration = textFormattingConfiguration
        return self
    }
}

// MARK: - iOS 26.0 新增属性

public extension FdyWrapper where Base: UITextView {
    /// 全部选中区间
    ///
    /// - Parameter selectedRanges: 选中区间数组（按 UTF-16 单元,与 `NSRange` 口径一致）
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func selectedRanges(_ selectedRanges: [NSRange]) -> Self {
        base.selectedRanges = selectedRanges
        return self
    }
}
