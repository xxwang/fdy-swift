import Foundation

// MARK: - 命名空间入口
//
// `URLRequest` 是结构体,不继承 `extension NSObject: FdyExtension`,须单独登记,否则 `.fdy` 不可用。
extension URLRequest: FdyExtension {}

// MARK: - 构造方法
public extension URLRequest {
    /// 使用 URL 字符串安全初始化 `URLRequest`
    ///
    /// - Parameter string: URL 字符串
    /// - Returns: 成功返回 `URLRequest`,否则返回 `nil`
    init?(fdy_string string: String) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url)
    }
}
