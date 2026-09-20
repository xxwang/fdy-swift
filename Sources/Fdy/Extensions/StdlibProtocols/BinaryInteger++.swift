import CoreGraphics
import Foundation

// MARK: - 类型转换
public extension BinaryInteger {
    /// 转换为 `Bool`
    /// - Returns: 是否满足条件
    func fdy_toBool() -> Bool {
        self > 0
    }

    // 刻意不提供 `fdy_Int()` / `fdy_Double()` / `fdy_CGFloat()` 一类转换方法:
    // 它们等价于 `Int(self)`、`Double(self)` 等系统构造器(后者更短),
    // 且与 `String.fdy_Int()`(解析失败返回 `0`,语义完全不同)同名,易混用。

    /// 转换为 `NSNumber`
    /// - Returns: 数值
    func fdy_toNSNumber() -> NSNumber {
        NSNumber(value: Double(self))
    }

    /// 转换为 `NSDecimalNumber`(通过 `Double` 中转,注意精度损失)
    /// - Returns: 十进制数
    func fdy_toNSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(string: self.fdy_toString())
    }

    /// 转换为 `Decimal`(经字符串中转,避免 `Decimal(Double(self))` 对大整数(>2^53)的精度丢失)
    /// - Returns: 十进制数
    func fdy_toDecimal() -> Decimal {
        Decimal(string: self.fdy_toString()) ?? .zero
    }

    /// 转换为十进制字符串表示
    /// - Returns: 处理后的字符串
    func fdy_toString() -> String {
        String(self)
    }

    /// 尝试将当前值解释为 `Unicode` 码点,并返回对应的 `Character`
    ///
    /// - Returns: 有效的 `Character`,若码点无效则返回 `nil`
    func fdy_toCharacter() -> Character? {
        guard let scalar = UnicodeScalar(Int(self)) else { return nil }
        return Character(scalar)
    }

    /// 创建一个 `CGPoint`,`x` 和 `y`坐标均设为当前值(转换为 `Double`)
    /// - Returns: 坐标点
    func fdy_toCGPoint() -> CGPoint {
        CGPoint(x: CGFloat(self), y: CGFloat(self))
    }

    /// 创建一个 `CGSize`,宽高均设为当前值(转换为 `CGFloat`)
    /// - Returns: 尺寸
    func fdy_toCGSize() -> CGSize {
        CGSize(width: CGFloat(self), height: CGFloat(self))
    }
}

// MARK: - 角度与弧度转换
public extension BinaryInteger {
    /// 将角度(单位：度)转换为弧度
    ///
    /// - Returns: 对应的弧度值(范围：0 到 2π)
    func fdy_radians() -> Double {
        Double(self) * .pi / 180.0
    }

    /// 将弧度转换为角度(单位：度)
    ///
    /// - Returns: 对应的角度值(范围：0 到 360)
    func fdy_degrees() -> Double {
        Double(self) * 180.0 / .pi
    }
}

// MARK: - 数值属性与操作
public extension BinaryInteger {
    /// 判断是否为奇数
    /// - Returns: 是否满足条件
    var fdy_isOdd: Bool {
        self & 1 == 1
    }

    /// 判断是否为偶数
    /// - Returns: 是否满足条件
    var fdy_isEven: Bool {
        self & 1 == 0
    }

    /// 格式化为人类可读的存储单位(如 KB, MB, GB)
    ///
    /// - Returns: 格式化字符串,如 `"1.50 MB"`
    func fdy_storageUnit() -> String {
        let units = ["bytes", "KB", "MB", "GB", "TB", "PB"]
        var value = Double(self)
        var index = 0
        while value >= 1024, index < units.count - 1 {
            value /= 1024
            index += 1
        }
        if index == 0 {
            return "\(Int(value)) \(units[index])"
        } else {
            return String(format: "%.2f %@", value, units[index])
        }
    }

    /// 转换为罗马数字(仅支持正整数)
    ///
    /// - Returns: 罗马数字字符串,若 ≤ 0 则返回 `nil`
    func fdy_romanNumeral() -> String? {
        guard self > 0 else { return nil }
        let values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        let numerals = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]

        var result = ""
        var remaining = Int(self)
        for (value, numeral) in zip(values, numerals) {
            while remaining >= value {
                result += numeral
                remaining -= value
            }
        }
        return result
    }
}

// MARK: - 时间
public extension BinaryInteger {
    /// 将整数解释为时间戳,并创建 `Date` 对象
    ///
    /// - Parameter isUnix: 若为 `true`,表示秒级 Unix 时间戳;若为 `false`,表示毫秒级
    /// - Returns: 对应的 `Date`
    func fdy_toDate(isUnix: Bool = true) -> Date {
        let interval = isUnix ? Double(self) : Double(self) / 1000.0
        return Date(timeIntervalSince1970: interval)
    }

    /// 将秒数格式化为播放时间字符串(如 "01:01:01")
    ///
    /// - Parameter component: 可选,指定只显示到某一级(如 `.minute` → "61:01")
    /// - Returns: 格式化的时间字符串
    func fdy_durationString(component: Calendar.Component? = nil) -> String {
        guard self > 0 else { return "00:00" }

        let totalSeconds = Int(self)
        let seconds = totalSeconds % 60

        if component == .second {
            return String(format: "%02d", seconds)
        }

        let totalMinutes = totalSeconds / 60
        let minutes = totalMinutes % 60

        if component == .minute {
            return String(format: "%02d:%02d", totalMinutes, seconds)
        }

        let hours = totalMinutes / 60
        if component == .hour || hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

// MARK: - 区间
public extension BinaryInteger {
    /// 创建从 `from` 到 `self` 的半开区间(左闭右开)
    ///
    /// - Parameter from: 起始值(包含)
    /// - Returns: `CountableRange<Int>`
    func fdy_range(from: some BinaryInteger) -> CountableRange<Int> {
        Int(from) ..< Int(self)
    }

    /// 创建从 `self` 到 `to` 的半开区间(左闭右开)
    ///
    /// - Parameter to: 结束值(不包含)
    /// - Returns: `CountableRange<Int>`
    func fdy_range(to: some BinaryInteger) -> CountableRange<Int> {
        Int(self) ..< Int(to)
    }
}
