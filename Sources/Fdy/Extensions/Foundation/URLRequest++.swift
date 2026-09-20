import Foundation

// MARK: - 命名空间入口
extension URLRequest: FdyExtension {}

// MARK: - 构造方法
public extension URLRequest {
    /// 使用 URL 字符串安全初始化 `URLRequest`
    ///
    /// - Parameter string: URL 字符串
    init?(fdy_string string: String) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url)
    }
}
