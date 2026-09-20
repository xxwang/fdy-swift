import UIKit

// MARK: - 链式变换
public extension FdyWrapper where Base == UIColor {
    /// 调整透明度,返回新颜色
    ///
    /// - Parameter alpha: 不透明度
    /// - Returns: `Self`
    /// - Note: 即 `fdy_alpha(_:)`。入参会被 `UIColor` 内部裁剪到 `0...1`。
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base = base.fdy_alpha(alpha)
        return self
    }

    /// 提亮,返回新颜色
    ///
    /// - Parameter amount: 幅度,默认为 `0.2`
    /// - Returns: `Self`
    /// - Note: 即 `fdy_lighten(by:)`,默认幅度 `0.2`。
    @discardableResult
    func lighten(by amount: CGFloat = 0.2) -> Self {
        base = base.fdy_lighten(by: amount)
        return self
    }

    /// 压暗,返回新颜色
    ///
    /// - Parameter amount: 幅度,默认为 `0.2`
    /// - Returns: `Self`
    /// - Note: 即 `fdy_darken(by:)`,默认幅度 `0.2`。
    @discardableResult
    func darken(by amount: CGFloat = 0.2) -> Self {
        base = base.fdy_darken(by: amount)
        return self
    }

    /// 把饱和度抬到不低于给定值,返回新颜色
    ///
    /// - Parameter minSaturation: 最低饱和度
    /// - Returns: `Self`
    /// - Note: 即 `fdy_withMinSaturation(_:)`。用于灰阶色需要"看得出是彩的"的场合。
    @discardableResult
    func minSaturation(_ minSaturation: CGFloat) -> Self {
        base = base.fdy_withMinSaturation(minSaturation)
        return self
    }

    /// 取补色(色环上转 180°),返回新颜色
    ///
    /// - Returns: `Self`
    /// - Note: 即 `fdy_complementary`。与 `fdy_complementary(for:)`(静态版,失败返回 `nil`)不同,
    ///   本属性对无法解析的颜色会原样返回,因此链式版不会中断。
    @discardableResult
    func complementary() -> Self {
        base = base.fdy_complementary
        return self
    }
}
