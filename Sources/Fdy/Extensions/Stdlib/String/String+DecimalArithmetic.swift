import Foundation

// MARK: - 高精度四则运算(基于 NSDecimalNumber)
public extension String {
    /// 加法：`self + other`
    ///
    /// - Parameter other: 另一个值
    /// - Returns: 结果字符串;`self` 或 `other` 不是合法十进制数字时返回 `nil`
    func fdy_add(_ other: String?) -> String? {
        self.fdy_performOperation(other) { $0.adding($1) }
    }

    /// 减法：`self - other`
    ///
    /// - Parameter other: 另一个值
    /// - Returns: 结果字符串;任一操作数不是合法十进制数字时返回 `nil`
    func fdy_subtract(_ other: String?) -> String? {
        self.fdy_performOperation(other) { $0.subtracting($1) }
    }

    /// 乘法：`self * other`
    ///
    /// - Parameter other: 另一个值
    /// - Returns: 结果字符串;任一操作数不是合法十进制数字时返回 `nil`
    func fdy_multiply(_ other: String?) -> String? {
        self.fdy_performOperation(other) { $0.multiplying(by: $1) }
    }

    /// 除法：`self / other`
    ///
    /// - Parameter other: 另一个值
    /// - Returns: 结果字符串;任一操作数不是合法十进制数字,**或除数为 `0`** 时返回 `nil`
    /// - Note: 除数为 `0` **不返回 `self`** —— 把失败伪装成成功比返回 `nil` 危险得多
    func fdy_divide(_ other: String?) -> String? {
        guard let divisor = Self.fdy_parsedDecimal(other), divisor != .zero else {
            return nil
        }
        return self.fdy_performOperation(other) { $0.dividing(by: $1) }
    }
}

// MARK: 私有辅助工具
public extension String {
    /// 把字符串解析为 `NSDecimalNumber`;非法输入（`nil` / 空串 / 非数字）返回 `nil`
    ///
    /// - Note: `NSDecimalNumber(string:)` 对非法输入**不抛异常**,而是返回 `NaN`,
    ///   所以这里用 `notANumber` 判定,把失败显式化 —— 否则 `NaN` 会一路流到四则运算里炸掉进程。
    private static func fdy_parsedDecimal(_ raw: String?) -> NSDecimalNumber? {
        guard let raw, !raw.isEmpty else { return nil }
        let number = NSDecimalNumber(string: raw)
        return number == .notANumber ? nil : number
    }

    private func fdy_performOperation(
        _ other: String?,
        _ operation: FdyFunc2<NSDecimalNumber, NSDecimalNumber, NSDecimalNumber>
    ) -> String? {
        guard let left = Self.fdy_parsedDecimal(self),
              let right = Self.fdy_parsedDecimal(other)
        else {
            return nil
        }
        return operation(left, right).stringValue
    }
}
