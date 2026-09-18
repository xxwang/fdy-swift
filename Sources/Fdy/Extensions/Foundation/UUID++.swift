import Foundation

// MARK: - 命名空间入口
//
// `UUID` 是结构体,不继承 `extension NSObject: FdyExtension`,须单独登记,否则 `.fdy` 不可用。
extension UUID: FdyExtension {}

// MARK: - 自定义
public extension UUID {
    /// 返回一个`UUID`字符串
    func fdy_String() -> String {
        return self.uuidString
    }
}
