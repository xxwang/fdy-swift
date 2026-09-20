import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UISearchBar {
    /// 占位符文本
    /// - Parameter placeholder: 占位文本
    /// - Returns: `Self`
    @discardableResult
    func placeholder(_ placeholder: String?) -> Self {
        base.placeholder = placeholder
        return self
    }

    /// 搜索栏样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func searchBarStyle(_ style: UISearchBar.Style) -> Self {
        base.searchBarStyle = style
        return self
    }

    /// 文本框背景颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func searchTextFieldBackgroundColor(_ color: UIColor?) -> Self {
        base.searchTextField.backgroundColor = color
        return self
    }

    /// 搜索文本的字体和颜色(通过 `searchTextField` 的 `attributedPlaceholder` 或直接设置)
    /// - Parameter attributes: 属性
    /// - Returns: `Self`
    @discardableResult
    func textAttributes(_ attributes: [NSAttributedString.Key: Any]?) -> Self {
        base.searchTextField.attributedPlaceholder = attributes.map {
            NSAttributedString(string: base.placeholder ?? "", attributes: $0)
        }
        return self
    }

    /// 代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: (any UISearchBarDelegate)?) -> Self {
        base.delegate = delegate
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension FdyWrapper where Base: UISearchBar {
    /// 清空搜索文本
    /// - Returns: `Self`
    @discardableResult
    func clear() -> Self {
        base.searchTextField.attributedText = nil
        return self
    }

    /// 启用/禁用搜索栏,禁用时同时把 `alpha` 置为 0.5 作为视觉反馈
    /// - Parameter isEnabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        base.isUserInteractionEnabled = isEnabled
        base.alpha = isEnabled ? 1.0 : 0.5
        return self
    }

    /// 搜索栏背景图片
    /// - Parameter image: 背景图片,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ image: UIImage?) -> Self {
        base.backgroundImage = image
        return self
    }

    /// 作用域栏背景图片
    /// - Parameter image: 背景图片,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func scopeBarBackgroundImage(_ image: UIImage?) -> Self {
        base.scopeBarBackgroundImage = image
        return self
    }

    /// 输入辅助视图
    /// - Parameter inputAccessoryView: 辅助视图,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func inputAccessoryView(_ inputAccessoryView: UIView?) -> Self {
        base.inputAccessoryView = inputAccessoryView
        return self
    }

    /// 搜索栏的 `tintColor`
    /// - Parameter color: 颜色,传 `nil` 用系统默认
    /// - Returns: `Self`
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        base.tintColor = color
        return self
    }

    /// 搜索框背景的偏移量
    /// - Parameter searchFieldBackgroundPositionAdjustment: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func searchFieldBackgroundPositionAdjustment(
        _ searchFieldBackgroundPositionAdjustment: UIOffset
    ) -> Self {
        base.searchFieldBackgroundPositionAdjustment = searchFieldBackgroundPositionAdjustment
        return self
    }

    /// 搜索文本的偏移量
    /// - Parameter searchTextPositionAdjustment: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func searchTextPositionAdjustment(_ searchTextPositionAdjustment: UIOffset) -> Self {
        base.searchTextPositionAdjustment = searchTextPositionAdjustment
        return self
    }

    /// 是否启用「注视即口述」
    /// - Parameter isLookToDictateEnabled: 是否启用注视听写
    /// - Returns: `Self`
    @discardableResult
    func isLookToDictateEnabled(_ isLookToDictateEnabled: Bool) -> Self {
        base.isLookToDictateEnabled = isLookToDictateEnabled
        return self
    }
}
