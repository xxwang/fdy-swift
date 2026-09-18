import Foundation

// MARK: - 命名空间入口
//
// `FdyExtension` 的 conformance 登记在本类型的首个 Chain 文件里(`Date` 例外,登记点与链式文件分开)。
// 继承 `NSObject` 的类自动获得 `.fdy`;结构体与 Core Foundation 类型必须逐条登记 —— 漏登记即对外不可达。
extension NSObject: FdyExtension {}
