import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UICommand {
    /// 标题
    /// - Parameter title: 要设置的标题
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String) -> Self {
        base.title = title
        return self
    }

    /// 图标
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 可发现性标题
    /// - Parameter discoverabilityTitle: 快捷键发现面板中的标题
    /// - Returns: `Self`
    @discardableResult
    func discoverabilityTitle(_ discoverabilityTitle: String?) -> Self {
        base.discoverabilityTitle = discoverabilityTitle
        return self
    }

    /// 属性
    /// - Parameter attributes: 菜单项语义(禁用 / 隐藏 / 破坏性操作)
    /// - Returns: `Self`
    @discardableResult
    func attributes(_ attributes: UIMenuElement.Attributes) -> Self {
        base.attributes = attributes
        return self
    }

    /// 状态
    /// - Parameter state: 选中状态(`.off` / `.on` / `.mixed`)
    /// - Returns: `Self`
    @discardableResult
    func state(_ state: UIMenuElement.State) -> Self {
        base.state = state
        return self
    }
}
