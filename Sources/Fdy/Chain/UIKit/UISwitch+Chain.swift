import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UISwitch {
    /// 开关的开启/关闭状态
    ///
    /// - Parameter isOn: `true` 表示开启,`false` 表示关闭
    /// - Returns: `Self`
    @discardableResult
    func isOn(_ isOn: Bool) -> Self {
        base.isOn = isOn
        return self
    }

    /// 开关处于“开启”状态时的背景颜色(即轨道颜色)
    ///
    /// - Parameter color: 开启时的颜色,传入 `nil` 将使用系统默认色
    /// - Returns: `Self`
    @discardableResult
    func onTintColor(_ color: UIColor?) -> Self {
        base.onTintColor = color
        return self
    }

    /// 滑块`thumb`的颜色
    ///
    /// - Parameter color: 滑块颜色,传入 `nil` 将使用系统默认色
    /// - Returns: `Self`
    @discardableResult
    func thumbTintColor(_ color: UIColor?) -> Self {
        base.thumbTintColor = color
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension FdyWrapper where Base: UISwitch {
    /// 切换当前开关状态(开 ↔ 关),可选带动画
    ///
    /// - Parameter animated: 是否启用切换动画默认为 `true`
    /// - Returns: `Self`
    @discardableResult
    func toggle(_ animated: Bool = true) -> Self {
        base.setOn(!base.isOn, animated: animated)
        return self
    }

    /// 「开」状态的图片
    /// - Parameter image: 图片,传 `nil` 用系统默认
    /// - Returns: `Self`
    @discardableResult
    func onImage(_ image: UIImage?) -> Self {
        base.onImage = image
        return self
    }

    /// 「关」状态的图片
    /// - Parameter image: 图片,传 `nil` 用系统默认
    /// - Returns: `Self`
    @discardableResult
    func offImage(_ image: UIImage?) -> Self {
        base.offImage = image
        return self
    }

    /// 开关样式
    /// - Parameter preferredStyle: 要设置的开关样式
    /// - Returns: `Self`
    @discardableResult
    func preferredStyle(_ preferredStyle: UISwitch.Style) -> Self {
        base.preferredStyle = preferredStyle
        return self
    }
}
