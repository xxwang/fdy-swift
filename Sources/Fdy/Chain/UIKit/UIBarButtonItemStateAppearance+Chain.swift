import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIBarButtonItemStateAppearance {
    /// 该状态下标题的文本属性
    /// - Parameter titleTextAttributes: 标题文本属性
    /// - Returns: `Self`
    @discardableResult
    func titleTextAttributes(_ titleTextAttributes: [NSAttributedString.Key: Any]) -> Self {
        base.titleTextAttributes = titleTextAttributes
        return self
    }

    /// 该状态下标题的位置偏移
    /// - Parameter titlePositionAdjustment: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func titlePositionAdjustment(_ titlePositionAdjustment: UIOffset) -> Self {
        base.titlePositionAdjustment = titlePositionAdjustment
        return self
    }

    /// 该状态下的背景图片,传 `nil` 可清空
    /// - Parameter backgroundImage: 图片
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> Self {
        base.backgroundImage = backgroundImage
        return self
    }

    /// 该状态下背景图片的位置偏移
    /// - Parameter backgroundImagePositionAdjustment: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func backgroundImagePositionAdjustment(_ backgroundImagePositionAdjustment: UIOffset) -> Self {
        base.backgroundImagePositionAdjustment = backgroundImagePositionAdjustment
        return self
    }
}
