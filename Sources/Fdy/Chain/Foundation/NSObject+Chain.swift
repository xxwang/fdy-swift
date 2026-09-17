import Foundation

// MARK: - 命名空间入口
//
// `FdyExtension` 的 conformance 统一登记在**该类型的首个 Chain 文件**里：
// `NSObject` 在本文件、`Date` 在 `Date+Chain.swift`、`UIButton.Configuration` 在 `UIButton.Configuration+Chain.swift`。
// 类子类会继承 `NSObject` 这条，因此 `UIButton` / `UILabel` 等自动获得 `.fdy`。
extension NSObject: FdyExtension {}
