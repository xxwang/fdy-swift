import Foundation

// MARK: - 命名空间入口
//
// `Bool` 是结构体,不继承 `extension NSObject: FdyExtension`,须单独登记,否则 `.fdy` 不可用。
extension Bool: FdyExtension {}

// MARK: - 类型转换
public extension Bool {
    /// 将布尔值转换为对应的整数值
    func fdy_toInt() -> Int {
        return self ? 1 : 0
    }

    /// 将布尔值转换为对应的浮点数值
    func fdy_toFloat() -> Float {
        return self ? 1.0 : 0.0
    }

    /// 将布尔值转换为对应的双精度浮点数值
    func fdy_toDouble() -> Double {
        return self ? 1.0 : 0.0
    }

    /// 将布尔值转换为其标准字符串表示形式
    func fdy_toString() -> String {
        return self ? "true" : "false"
    }
}
