import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UISegmentedControl {
    /// 选中的分段索引
    /// - Parameter index: 分段索引(设为 `UISegmentedControl.noSegment` 可取消选中)
    /// - Returns: `Self`
    @discardableResult
    func selectedSegmentIndex(_ index: Int) -> Self {
        base.selectedSegmentIndex = index
        return self
    }

    /// 背景图片(针对指定状态)
    /// - Parameters:
    ///   - image: 背景图片(可为 `nil` 以移除)
    ///   - state: 控件状态(如 `.normal`, `.selected`)
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        base.setBackgroundImage(image, for: state, barMetrics: .default)
        return self
    }

    /// 分段之间的分割线图片
    /// - Parameters:
    ///   - image: 分割线图片
    ///   - leftState: 左侧对应的状态
    ///   - rightState: 右侧对应的状态
    /// - Returns: `Self`
    @discardableResult
    func dividerImage(_ image: UIImage?, forLeftSegmentState leftState: UIControl.State, rightSegmentState rightState: UIControl.State) -> Self {
        base.setDividerImage(image, forLeftSegmentState: leftState, rightSegmentState: rightState, barMetrics: .default)
        return self
    }

    /// 是否为瞬时模式(按下即触发,不保持选中状态)
    /// - Parameter isMomentary: 是否瞬时
    /// - Returns: `Self`
    @discardableResult
    func isMomentary(_ isMomentary: Bool) -> Self {
        base.isMomentary = isMomentary
        return self
    }

    /// 是否根据内容自动调整分段宽度
    /// - Parameter enabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func apportionsSegmentWidthsByContent(_ enabled: Bool) -> Self {
        base.apportionsSegmentWidthsByContent = enabled
        return self
    }

    /// 分段的宽度
    /// - Parameters:
    ///   - width: 宽度(设为 `0` 表示自动)
    ///   - index: 分段索引
    /// - Returns: `Self`
    @discardableResult
    func width(_ width: CGFloat, forSegmentAt index: Int) -> Self {
        base.setWidth(width, forSegmentAt: index)
        return self
    }

    /// 分段标题的文本属性(如字体、颜色)
    /// - Parameters:
    ///   - attributes: 文本属性字典
    ///   - state: 控件状态(如 `.normal`, `.selected`)
    /// - Returns: `Self`
    @discardableResult
    func titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        base.setTitleTextAttributes(attributes, for: state)
        return self
    }

    /// 启用或禁用指定分段
    /// - Parameters:
    ///   - isEnabled: 是否启用
    ///   - index: 分段索引
    /// - Returns: `Self`
    @discardableResult
    func enabled(_ isEnabled: Bool, forSegmentAt index: Int) -> Self {
        base.setEnabled(isEnabled, forSegmentAt: index)
        return self
    }

    /// 选中段落的 `tintColor`
    /// - Parameter color: 颜色,传 `nil` 用系统默认
    /// - Returns: `Self`
    @discardableResult
    func selectedSegmentTintColor(_ color: UIColor?) -> Self {
        base.selectedSegmentTintColor = color
        return self
    }
}
