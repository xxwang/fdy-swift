import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIColorWell {
    /// 标题
    /// - Parameter title: 要设置的标题
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        base.title = title
        return self
    }

    /// 是否支持透明度
    /// - Parameter supportsAlpha: `true` 表示支持透明度
    /// - Returns: `Self`
    @discardableResult
    func supportsAlpha(_ supportsAlpha: Bool) -> Self {
        base.supportsAlpha = supportsAlpha
        return self
    }

    /// 当前颜色
    /// - Parameter selectedColor: 颜色
    /// - Returns: `Self`
    @discardableResult
    func selectedColor(_ selectedColor: UIColor?) -> Self {
        base.selectedColor = selectedColor
        return self
    }
}

public extension FdyWrapper where Base: UIColorWell {
    /// 是否支持吸管取色
    ///
    /// - Parameter supportsEyedropper: `true` 支持
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func supportsEyedropper(_ supportsEyedropper: Bool) -> Self {
        base.supportsEyedropper = supportsEyedropper
        return self
    }

    /// 线性曝光上限
    ///
    /// - Parameter maximumLinearExposure: 上限值
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func maximumLinearExposure(_ maximumLinearExposure: CGFloat) -> Self {
        base.maximumLinearExposure = maximumLinearExposure
        return self
    }
}
