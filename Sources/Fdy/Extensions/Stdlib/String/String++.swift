import Foundation

// MARK: - 命名空间入口
//
// `String` 是结构体,不继承 `extension NSObject: FdyExtension`,须单独登记。
// 漏登记的后果不是编译失败而是**类型错误**:`"abc".fdy` 会经 `NSString` 桥接解析成
// `FdyWrapper<NSString>`,能编译,但 `.build()` 返回 `NSString`。
extension String: FdyExtension {}

// MARK: - 说明
//
// 本文件刻意不提供链式 setter:`String` 的系统 API 已足够完整,库内另有 176 个 `fdy_` 方法,
// 再加一层链式只会造出第二套入口。需要「在副本上修改」时用 `with`:
//
//     let s = "abc".fdy.with { $0 += "!" }   // "abc!"
