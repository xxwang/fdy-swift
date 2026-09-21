import Foundation

public extension UUID {
    /// 生成一个新的 UUID 字符串(大写,含连字符)
    /// - Returns: 形如 "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
    static func fdy_string() -> String {
        UUID().uuidString
    }

    /// 生成一个新的 UUID 字符串(大写,已去除连字符)
    /// - Returns: 形如 "E621E1F8C36C495A93FC0C247A3E6E5F"
    static func fdy_compactString() -> String {
        UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
}
