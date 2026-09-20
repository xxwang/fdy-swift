import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIKeyCommand {
    /// 标题(显示在快捷键发现面板/菜单里)
    /// - Parameter title: 标题
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

    /// 选中态(如 `.on`)
    /// - Parameter state: 状态
    /// - Returns: `Self`
    @discardableResult
    func state(_ state: UIMenuElement.State) -> Self {
        base.state = state
        return self
    }

    /// 是否优先于系统行为(如空格/方向键的默认滚动)
    ///
    /// - Parameter wantsPriorityOverSystemBehavior: 是否优先于系统手势
    /// - Returns: `Self`
    /// - Note: `iOS 15.0` 起可用,低于新增 API 门槛(`iOS 18.0`),按约定**不加** `@available`。
    @discardableResult
    func wantsPriorityOverSystemBehavior(_ wantsPriorityOverSystemBehavior: Bool) -> Self {
        base.wantsPriorityOverSystemBehavior = wantsPriorityOverSystemBehavior
        return self
    }

    /// 是否允许系统自动本地化标题
    ///
    /// - Parameter allowsAutomaticLocalization: 是否允许自动本地化
    /// - Returns: `Self`
    /// - Note: `iOS 15.0` 起可用,同上不加标注。
    @discardableResult
    func allowsAutomaticLocalization(_ allowsAutomaticLocalization: Bool) -> Self {
        base.allowsAutomaticLocalization = allowsAutomaticLocalization
        return self
    }

    /// 是否允许系统在 RTL 语言下自动镜像
    ///
    /// - Parameter allowsAutomaticMirroring: 是否允许自动镜像
    /// - Returns: `Self`
    /// - Note: `iOS 15.0` 起可用,同上不加标注。
    @discardableResult
    func allowsAutomaticMirroring(_ allowsAutomaticMirroring: Bool) -> Self {
        base.allowsAutomaticMirroring = allowsAutomaticMirroring
        return self
    }
}
