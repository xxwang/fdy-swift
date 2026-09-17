import Foundation

// MARK: - 类型转换
public extension Bool {
    /// 将布尔值转换为对应的整数值
    func fdy_Int() -> Int {
        return self ? 1 : 0
    }

    /// 将布尔值转换为对应的浮点数值
    func fdy_Float() -> Float {
        return self ? 1.0 : 0.0
    }

    /// 将布尔值转换为对应的双精度浮点数值
    func fdy_Double() -> Double {
        return self ? 1.0 : 0.0
    }

    /// 将布尔值转换为其标准字符串表示形式
    func fdy_String() -> String {
        return self ? "true" : "false"
    }
}
