import Foundation

// MARK: - 运算方法
public extension String {
    /// 使用 `NSRegularExpression` 对象对当前字符串进行匹配
    /// - Parameter regex: 预编译的正则表达式对象
    /// - Returns: 是否存在匹配
    ///
    /// - Example:
    /// ```swift
    ///      let regex = try! NSRegularExpression(pattern: "world$")
    ///     "hello world".fdy_matches(regex)        // true
    /// ```
    func fdy_matches(_ regex: NSRegularExpression) -> Bool {
        let nsRange = NSRange(startIndex..., in: self)
        return regex.firstMatch(in: self, options: [], range: nsRange) != nil
    }
}
