import CoreGraphics
import Foundation

// MARK: - 类型转换
public extension BinaryFloatingPoint {
    /// 将当前浮点数值转换为布尔值
    func fdy_toBool() -> Bool {
        self > 0
    }

    // 刻意不提供 `fdy_Int()` / `fdy_Double()` / `fdy_CGFloat()` 一类转换方法:
    // 它们等价于 `Int(self)`、`Double(self)` 等系统构造器(后者更短),且与 `String.fdy_Int()` 同名易混。

    /// 将当前值包装为 `NSNumber` 对象
    func fdy_toNSNumber() -> NSNumber {
        NSNumber(value: Double(self))
    }

    /// 将当前值转换为 `NSDecimalNumber`
    func fdy_toNSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(string: self.fdy_toString())
    }

    /// 将当前值转换为 `Decimal`
    func fdy_toDecimal() -> Decimal {
        self.fdy_toNSDecimalNumber().decimalValue
    }

    /// 将当前值转换为字符串表示
    func fdy_toString() -> String {
        String(describing: self)
    }

    /// 将当前值转换为 `CGPoint`,`x` 和 `y` 坐标均使用该值
    func fdy_toCGPoint() -> CGPoint {
        let v = CGFloat(self)
        return CGPoint(x: v, y: v)
    }

    /// 将当前值转换为 `CGSize`,`width` 和 `height` 均使用该值
    func fdy_toCGSize() -> CGSize {
        let v = CGFloat(self)
        return CGSize(width: v, height: v)
    }
}

// MARK: - 角度与弧度转换
public extension BinaryFloatingPoint {
    /// 将角度(单位：度)转换为弧度
    ///
    /// - Returns: 对应的弧度值(范围通常为 `0` 到 `2π`,但支持任意输入)
    func fdy_radians() -> Self {
        self * (.pi / 180)
    }

    /// 将弧度转换为角度(单位：度)
    ///
    /// - Returns: 对应的角度值
    func fdy_degrees() -> Self {
        self * (180 / .pi)
    }
}

// MARK: - 基础数值操作
public extension BinaryFloatingPoint {
    /// 返回当前值的绝对值
    func fdy_abs() -> Self {
        Swift.abs(self)
    }

    /// 对当前值向上取整(向正无穷方向)
    func fdy_ceil() -> Self {
        Foundation.ceil(self)
    }

    /// 对当前值向下取整(向负无穷方向)
    func fdy_floor() -> Self {
        Foundation.floor(self)
    }

    /// 将当前值四舍五入为最接近的整数,并转换为 `Int`
    /// - Returns: 四舍五入后的 `Int` 值
    func fdy_roundToInt() -> Int {
        Foundation.lround(Double(self))
    }
}

// MARK: - 小数精度控制
public extension BinaryFloatingPoint {
    /// 截断小数部分,保留指定的小数位数(向零取整)
    ///
    /// - Parameter places: 要保留的小数位数,必须 ≥ 0若为负数,返回原值
    /// - Returns: 截断后的值
    ///
    /// - Example:
    ///   ```swift
    ///     let value: Double = 5.6789
    ///     print(value.fdy_truncate(places: 2)) // 5.67
    ///
    ///     let negative: Double = -5.6789
    ///     print(negative.fdy_truncate(places: 2)) // -5.67
    ///     ```
    func fdy_truncate(places: Int) -> Self {
        guard places >= 0 else { return self }
        let multiplier = Self(pow(10, Double(places)))
        return (self * multiplier).rounded(.towardZero) / multiplier
    }

    /// 对当前值四舍五入到指定的小数位数
    ///
    /// - Parameter places: 要保留的小数位数,必须 ≥ 0若为负数,返回原值
    /// - Returns: 四舍五入后的值
    ///
    /// - Example:
    ///   ```swift
    ///     let value: Double = 5.6789
    ///     print(value.fdy_round(places: 2)) // 5.68
    ///     ```
    func fdy_round(places: Int) -> Self {
        guard places >= 0 else { return self }
        let multiplier = Self(pow(10, Double(places)))
        return (self * multiplier).rounded() / multiplier
    }

    /// 按指定舍入规则对当前值舍入到指定小数位数
    ///
    /// - Parameters:
    ///   - places: 要保留的小数位数(≥ 0)
    ///   - rule: 舍入规则,如 `.up`, `.down`, `.towardZero` 等
    /// - Returns: 舍入后的值
    ///
    /// - Example:
    ///   ```swift
    ///     let value: Double = 5.671
    ///     print(value.fdy_rounded(places: 2, rule: .down)) // 5.67
    ///     ```
    func fdy_rounded(places: Int, rule: FloatingPointRoundingRule) -> Self {
        guard places >= 0 else { return self }
        let multiplier = Self(pow(10, Double(places)))
        return (self * multiplier).rounded(rule) / multiplier
    }
}
