import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIMenuElement {
    /// 副标题,传 `nil` 可清空
    ///
    /// - Parameter subtitle: 副标题
    /// - Returns: `Self`
    /// - Note: `iOS 15.0` 起可用,低于新增 API 门槛(`iOS 18.0`),按约定**不加** `@available`。
    @discardableResult
    func subtitle(_ subtitle: String?) -> Self {
        base.subtitle = subtitle
        return self
    }

    /// 图标的首选显示策略(如 `.automatic` / `.hidden`)
    ///
    /// - Parameter preferredImageVisibility: 首选图标可见性
    /// - Returns: `Self`
    /// - Note: 标注为 `iOS 27.0` 起可用 —— 高于新增 API 门槛(`iOS 18.0`),必须标注。
    ///   类型名用 **`UIMenuElement.ImageVisibility`** —— 头文件里写的是
    ///   `UIMenuElementImageVisibility`,Swift 侧**已重命名**成嵌套类型
    ///   (同 ``UIDragInteraction/liftBehavior(_:)`` 的坑)。
    @available(iOS 27.0, *)
    @discardableResult
    func preferredImageVisibility(_ preferredImageVisibility: UIMenuElement.ImageVisibility) -> Self {
        base.preferredImageVisibility = preferredImageVisibility
        return self
    }

    /// 高亮状态变化回调,传 `nil` 可清空
    ///
    /// - Parameter handler: 回调闭包
    /// - Returns: `Self`
    /// - Note: 标注为 `iOS 27.0` 起可用,必须标注。
    @available(iOS 27.0, *)
    @discardableResult
    func highlightStateUpdateHandler(_ handler: ((UIMenuElement, Bool) -> Void)?) -> Self {
        base.highlightStateUpdateHandler = handler
        return self
    }
}
