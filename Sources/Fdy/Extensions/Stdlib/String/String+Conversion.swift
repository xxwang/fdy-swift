import Foundation

#if canImport(UIKit)
    import UIKit
#endif

// MARK: - 类型转换
public extension String {
    /// 将字符串转换为 `Bool`
    func fdy_bool() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    /// 转换为 `Int`
    ///
    /// - Note: 等价于 `Int(self) ?? 0`;解析失败时静默返回 `0`,无法与真实的 `"0"` 区分
    func fdy_Int() -> Int {
        Int(self) ?? 0
    }

    /// 转换为 `NSNumber`
    func fdy_NSNumber() -> NSNumber {
        NSNumber(value: Double(self) ?? 0)
    }

    /// 转换为 `NSDecimalNumber`
    func fdy_NSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(string: self)
    }

    /// 转换为 `Decimal`
    func fdy_Decimal() -> Decimal {
        return Decimal(string: self) ?? .zero
    }

    /// 将十六进制字符串（如 `"FF"` 或 `"#A1B2C3"`）转换为十进制 `Int`
    func fdy_hexInt() -> Int {
        let clean = self.hasPrefix("#") ? String(self.dropFirst()) : self
        return Int(clean, radix: 16) ?? 0
    }

    /// 尝试将字符串解析为 `Unicode` 码点并转换为 `Character`
    func fdy_Character() -> Character? {
        guard let intValue = Int(self),
              let scalar = UnicodeScalar(intValue) else { return nil }
        return Character(scalar)
    }

    /// 转换为字符数组
    func fdy_Characters() -> [Character] {
        Array(self)
    }

    /// 转换为 `UTF-8` 编码的 `Data`
    func fdy_Data() -> Data? {
        self.data(using: .utf8)
    }

    /// 尝试转换为 `URL`
    func fdy_URL() -> URL? {
        URL(string: self)
    }

    /// 尝试转换为 `URLRequest`
    func fdy_URLRequest() -> URLRequest? {
        guard let url = self.fdy_URL() else { return nil }
        return URLRequest(url: url)
    }

    /// 转换为 `Notification.Name`
    func fdy_NotificationName() -> Notification.Name {
        Notification.Name(self)
    }

    /// 转换为 `NSString`（桥接）
    func fdy_NSString() -> NSString {
        self as NSString
    }

    /// 转换为 `NSAttributedString`
    func fdy_NSAttributedString() -> NSAttributedString {
        NSAttributedString(string: self)
    }

    /// 转换为 `NSMutableAttributedString`
    func fdy_NSMutableAttributedString() -> NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }

    /// 将十六进制颜色字符串转换为 `UIColor`
    func fdy_hexColor() -> UIColor {
        UIColor(fdy_hex: self)
    }

    /// 从资源名加载 `UIImage`
    func fdy_UIImage() -> UIImage? {
        UIImage(named: self)
    }
}
