import Foundation

#if canImport(UIKit)
    import UIKit
#endif

// MARK: - 类型转换
public extension String {
    /// 将字符串转换为 `Bool`
    /// - Returns: 是否满足条件
    func fdy_toBool() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    /// 转换为 `Int`
    ///
    /// - Returns: 计算结果
    /// - Note: 等价于 `Int(self) ?? 0`;解析失败时静默返回 `0`,无法与真实的 `"0"` 区分
    func fdy_toInt() -> Int {
        Int(self) ?? 0
    }

    /// 转换为 `Double`
    ///
    /// - Returns: 计算结果
    /// - Note: 等价于 `Double(self) ?? 0`;解析失败时静默返回 `0`，无法与真实的 `"0"` 区分。
    ///   需要区分「解析失败」时请直接用 `Double(self)`（返回 `Double?`）。
    func fdy_toDouble() -> Double {
        Double(self) ?? 0
    }

    /// 转换为 `Float`
    ///
    /// - Returns: 计算结果
    /// - Note: 等价于 `Float(self) ?? 0`;解析失败时静默返回 `0`。
    ///   需要区分「解析失败」时请直接用 `Float(self)`（返回 `Float?`）。
    func fdy_toFloat() -> Float {
        Float(self) ?? 0
    }

    /// 转换为 `NSNumber`
    ///
    /// - Returns: 数值
    /// - Note: 旧实现是 `NSNumber(value: Double(self) ?? 0)` —— **绕道 `Double` 会丢精度**。
    ///   实测 `"1234567890123456789".fdy_toNSNumber()` 读回 `1.234567890123457e+18`，
    ///   19 位整数被压成 17 位有效数字。现改为：可整数化的走 `Int64`，其余走 `Decimal`，
    ///   两者都不损失有效数字。
    /// - Note: 无法解析时返回 `0`（与原语义一致）。
    func fdy_toNSNumber() -> NSNumber {
        if let intValue = Int64(self) {
            return NSNumber(value: intValue)
        }
        let decimal = NSDecimalNumber(string: self)
        return decimal == .notANumber ? NSNumber(value: 0) : decimal
    }

    /// 转换为 `NSDecimalNumber`
    /// - Returns: 十进制数
    func fdy_toNSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(string: self)
    }

    /// 转换为 `Decimal`
    /// - Returns: 十进制数
    func fdy_toDecimal() -> Decimal {
        return Decimal(string: self) ?? .zero
    }

    /// 将十六进制字符串（如 `"FF"` 或 `"#A1B2C3"`）转换为十进制 `Int`
    /// - Returns: 计算结果
    func fdy_hexInt() -> Int {
        let clean = self.hasPrefix("#") ? String(self.dropFirst()) : self
        return Int(clean, radix: 16) ?? 0
    }

    /// 尝试将字符串解析为 `Unicode` 码点并转换为 `Character`
    /// - Returns: 字符,不可用时返回 `nil`
    func fdy_toCharacter() -> Character? {
        guard let intValue = Int(self),
              let scalar = UnicodeScalar(intValue) else { return nil }
        return Character(scalar)
    }

    /// 转换为字符数组
    /// - Returns: 字符数组
    func fdy_toCharacters() -> [Character] {
        Array(self)
    }

    /// 转换为 `UTF-8` 编码的 `Data`
    /// - Returns: 数据,不可用时返回 `nil`
    func fdy_toData() -> Data? {
        self.data(using: .utf8)
    }

    /// 尝试转换为 `URL`
    /// - Returns: URL,不可用时返回 `nil`
    func fdy_toURL() -> URL? {
        URL(string: self)
    }

    /// 尝试转换为 `URLRequest`
    /// - Returns: 请求,不可用时返回 `nil`
    func fdy_toURLRequest() -> URLRequest? {
        guard let url = self.fdy_toURL() else { return nil }
        return URLRequest(url: url)
    }

    /// 转换为 `Notification.Name`
    /// - Returns: 通知名
    func fdy_toNotificationName() -> Notification.Name {
        Notification.Name(self)
    }

    /// 转换为 `NSString`（桥接）
    /// - Returns: 字符串
    func fdy_toNSString() -> NSString {
        self as NSString
    }

    /// 转换为 `NSAttributedString`
    /// - Returns: 富文本
    func fdy_toNSAttributedString() -> NSAttributedString {
        NSAttributedString(string: self)
    }

    /// 转换为 `NSMutableAttributedString`
    /// - Returns: 可变富文本
    func fdy_toNSMutableAttributedString() -> NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }

    /// 将十六进制颜色字符串转换为 `UIColor`
    /// - Returns: 颜色
    func fdy_hexColor() -> UIColor {
        UIColor(fdy_hex: self)
    }

    /// 从资源名加载 `UIImage`
    /// - Returns: 图片,不可用时返回 `nil`
    func fdy_toUIImage() -> UIImage? {
        UIImage(named: self)
    }
}
