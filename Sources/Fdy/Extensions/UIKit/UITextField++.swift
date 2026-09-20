import UIKit

// MARK: - 属性
public extension UITextField {
    /// 判断当前文本内容是否为空
    /// - Returns: 是否满足条件
    var fdy_isEmpty: Bool {
        self.text == nil || self.text == ""
    }
}

// MARK: - 常用方法
public extension UITextField {
    /// 为输入框添加工具栏到 `inputAccessoryView`
    ///
    /// - Parameters:
    ///   - items: 工具栏中的按钮项数组
    ///   - height: 工具栏高度,默认为 `44`
    /// - Returns: 创建的 `UIToolbar` 实例
    @discardableResult
    func fdy_addToolbar(items: [UIBarButtonItem]?, height: CGFloat = 44) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.items = items
        toolbar.sizeToFit()

        // 强制设置高度(sizeToFit 可能忽略)
        let fixedHeight = NSLayoutConstraint(item: toolbar,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: height)
        fixedHeight.isActive = true

        self.inputAccessoryView = toolbar
        return toolbar
    }

    /// 用于 `UITextFieldDelegate` 的输入限制方法
    ///
    /// 支持最大字符数限制和正则表达式过滤
    ///
    /// - Parameters:
    ///   - range: 当前编辑范围(由 delegate 方法传入)
    ///   - text: 文本
    ///   - maxCharacters: 允许的最大字符数
    ///   - regex: 可选的正则表达式,用于限制输入字符类型(如仅数字字母)
    /// - Returns: `true` 表示允许输入,`false` 表示拒绝
    func fdy_inputRestrictions(
        shouldChangeTextIn range: NSRange,
        replacementText text: String,
        maxCharacters: Int,
        regex: String? = nil
    ) -> Bool {
        // 删除操作：总是允许
        if text.isEmpty {
            return true
        }

        // 正则校验(仅校验新增字符)
        if let regexPattern = regex, !text.fdy_isMatch(pattern: regexPattern) {
            return false
        }

        // 计算新文本
        let currentText = self.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return false }
        let newText = currentText.replacingCharacters(in: textRange, with: text)

        // 长度限制
        return newText.count <= maxCharacters
    }
}
