import UIKit

// MARK: - 命名空间入口
extension UIListSeparatorConfiguration: FdyExtension {}

// MARK: - 链式设置属性
public extension FdyWrapper where Base == UIListSeparatorConfiguration {
    /// 顶部指示线可见性
    /// - Parameter topSeparatorVisibility: 顶部指示线自动 / 显示 / 隐藏
    /// - Returns: `Self`
    @discardableResult
    func topSeparatorVisibility(_ topSeparatorVisibility: UIListSeparatorConfiguration.Visibility) -> Self {
        base.topSeparatorVisibility = topSeparatorVisibility
        return self
    }

    /// 底部指示线可见性
    /// - Parameter bottomSeparatorVisibility: 底部指示线自动 / 显示 / 隐藏
    /// - Returns: `Self`
    @discardableResult
    func bottomSeparatorVisibility(_ bottomSeparatorVisibility: UIListSeparatorConfiguration.Visibility) -> Self {
        base.bottomSeparatorVisibility = bottomSeparatorVisibility
        return self
    }

    /// 顶部指示线内边距
    /// - Parameter topSeparatorInsets: 要设置的顶部指示线内边距
    /// - Returns: `Self`
    @discardableResult
    func topSeparatorInsets(_ topSeparatorInsets: NSDirectionalEdgeInsets) -> Self {
        base.topSeparatorInsets = topSeparatorInsets
        return self
    }

    /// 底部指示线内边距
    /// - Parameter bottomSeparatorInsets: 要设置的底部指示线内边距
    /// - Returns: `Self`
    @discardableResult
    func bottomSeparatorInsets(_ bottomSeparatorInsets: NSDirectionalEdgeInsets) -> Self {
        base.bottomSeparatorInsets = bottomSeparatorInsets
        return self
    }

    /// 指示线颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func color(_ color: UIColor) -> Self {
        base.color = color
        return self
    }

    /// 多选态指示线颜色
    /// - Parameter multipleSelectionColor: 颜色
    /// - Returns: `Self`
    @discardableResult
    func multipleSelectionColor(_ multipleSelectionColor: UIColor) -> Self {
        base.multipleSelectionColor = multipleSelectionColor
        return self
    }

    /// 指示线视觉特效
    /// - Parameter visualEffect: 视觉效果
    /// - Returns: `Self`
    @discardableResult
    func visualEffect(_ visualEffect: UIVisualEffect?) -> Self {
        base.visualEffect = visualEffect
        return self
    }
}
