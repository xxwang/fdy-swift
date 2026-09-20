import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIAccessibilityElement {
    /// 无障碍容器
    /// - Parameter accessibilityContainer: 承载该元素的容器,`nil` 表示 `accessibilityFrame` 用屏幕坐标系
    /// - Returns: `Self`
    ///
    /// - Note: 头文件声明为 `weak id`,Swift 侧导入为 **`AnyObject?`**(class-constrained)—— 传 `Any?` 编不过。
    @discardableResult
    func accessibilityContainer(_ accessibilityContainer: AnyObject?) -> Self {
        base.accessibilityContainer = accessibilityContainer
        return self
    }

    /// 是否为无障碍元素
    /// - Parameter isAccessibilityElement: 是否作为无障碍元素
    /// - Returns: `Self`
    @discardableResult
    func isAccessibilityElement(_ isAccessibilityElement: Bool) -> Self {
        base.isAccessibilityElement = isAccessibilityElement
        return self
    }

    /// 无障碍标签
    /// - Parameter accessibilityLabel: 要设置的无障碍标签
    /// - Returns: `Self`
    @discardableResult
    func accessibilityLabel(_ accessibilityLabel: String?) -> Self {
        base.accessibilityLabel = accessibilityLabel
        return self
    }

    /// 无障碍提示
    /// - Parameter accessibilityHint: 要设置的无障碍提示
    /// - Returns: `Self`
    @discardableResult
    func accessibilityHint(_ accessibilityHint: String?) -> Self {
        base.accessibilityHint = accessibilityHint
        return self
    }

    /// 无障碍值
    /// - Parameter accessibilityValue: 当前值(如「50%」)
    /// - Returns: `Self`
    @discardableResult
    func accessibilityValue(_ accessibilityValue: String?) -> Self {
        base.accessibilityValue = accessibilityValue
        return self
    }

    /// 无障碍区域
    /// - Parameter accessibilityFrame: 屏幕坐标系下的可点击区域
    /// - Returns: `Self`
    @discardableResult
    func accessibilityFrame(_ accessibilityFrame: CGRect) -> Self {
        base.accessibilityFrame = accessibilityFrame
        return self
    }

    /// 无障碍特征
    /// - Parameter accessibilityTraits: 元素语义(按钮 / 图片 / 已选中 等)
    /// - Returns: `Self`
    @discardableResult
    func accessibilityTraits(_ accessibilityTraits: UIAccessibilityTraits) -> Self {
        base.accessibilityTraits = accessibilityTraits
        return self
    }

    /// 相对容器坐标系的辅助功能边框
    /// - Parameter accessibilityFrameInContainerSpace: 矩形
    /// - Returns: `Self`
    @discardableResult
    func accessibilityFrameInContainerSpace(_ accessibilityFrameInContainerSpace: CGRect) -> Self {
        base.accessibilityFrameInContainerSpace = accessibilityFrameInContainerSpace
        return self
    }
}
