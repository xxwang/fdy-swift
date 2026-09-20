import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIAction {
    /// 标题
    /// - Parameter title: 要设置的标题
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String) -> Self {
        base.title = title
        return self
    }

    /// 图标,传 `nil` 可清空
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 「聚焦搜索/发现」时可读的说明文本,传 `nil` 可清空
    /// - Parameter discoverabilityTitle: 快捷键发现面板中的标题
    /// - Returns: `Self`
    @discardableResult
    func discoverabilityTitle(_ discoverabilityTitle: String?) -> Self {
        base.discoverabilityTitle = discoverabilityTitle
        return self
    }

    /// 菜单元素属性(如 `.destructive` / `.disabled`),可传数组组合
    /// - Parameter attributes: 属性字典
    /// - Returns: `Self`
    @discardableResult
    func attributes(_ attributes: UIMenuElement.Attributes) -> Self {
        base.attributes = attributes
        return self
    }

    /// 选中态(如 `.on`),配合可选中菜单项使用
    /// - Parameter state: 状态
    /// - Returns: `Self`
    @discardableResult
    func state(_ state: UIMenuElement.State) -> Self {
        base.state = state
        return self
    }
}
