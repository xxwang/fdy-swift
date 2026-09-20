import Foundation

// MARK: - 命名空间入口
extension Optional: FdyExtension {}

// MARK: - 可选值状态判断属性
public extension Optional {
    /// 判断可选值是否为 `nil`
    ///
    /// - Returns: 若为 `nil` 返回 `true`,否则 `false`
    var fdy_isNil: Bool {
        self == nil
    }

    /// 判断可选值是否不为 `nil`
    ///
    /// - Returns: 若有值返回 `true`,否则 `false`
    var fdy_isNotNil: Bool {
        self != nil
    }
}

// MARK: - 可选集合的空值判断扩展
public extension Optional where Wrapped: Collection {
    /// 判断可选集合是否为 `nil` 或内容为空
    ///
    /// - Returns: 若值为 `nil` 或调用 `isEmpty` 返回 `true`,则结果为 `true`
    var fdy_isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}

// MARK: - 可选值安全操作方法
public extension Optional {
    /// 如果可选值存在,则对其执行指定操作
    ///
    /// - Parameter body: 接收解包后值的闭包,仅在值非 `nil` 时调用
    func fdy_run(_ body: FdyAction1<Wrapped>) {
        if let value = self {
            body(value)
        }
    }

    /// 强制解包可选值,若为 `nil` 则触发致命错误
    ///
    /// - Parameter message: 自定义错误信息（使用 `@autoclosure` 延迟求值）
    /// - Returns: 解包后的非空值
    /// - Warning: 仅用于调试或能**绝对保证非空**的场景,生产环境慎用
    func fdy_unwrap(orFail message: @autoclosure FdyFunc<String> = "Unexpected nil") -> Wrapped {
        guard let value = self else { fatalError(message()) }
        return value
    }

    /// 返回可选值,若为 `nil` 则使用指定的默认值
    ///
    /// - Parameter defaultValue: 默认值（直接传入,非惰性求值）
    /// - Returns: 非空值
    func fdy_or(_ defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }

    /// 返回可选值,若为 `nil` 则通过闭包生成默认值（惰性求值）
    ///
    /// - Parameter fallback: 仅在值为 `nil` 时调用的闭包,用于生成默认值
    /// - Returns: 非空值
    func fdy_or(fallback: FdyFunc<Wrapped>) -> Wrapped {
        self ?? fallback()
    }

    /// 若可选值为 `nil`,则抛出指定错误;否则返回解包后的值
    ///
    /// - Parameter error: 要抛出的错误实例
    /// - Returns: 解包后的非空值
    /// - Throws: 指定的错误（当值为 `nil` 时）
    func fdy_or(throw error: Error) throws -> Wrapped {
        guard let value = self else { throw error }
        return value
    }

    /// 在可选值非空且满足指定条件时,返回该值;否则返回 `nil`
    ///
    /// - Parameter predicate: 判断值是否符合条件的闭包
    /// - Returns: 满足条件的原值,或 `nil`
    func fdy_takeIf(_ predicate: FdyFunc1<Wrapped, Bool>) -> Wrapped? {
        guard let value = self, predicate(value) else { return nil }
        return value
    }
}

// MARK: - 可选值自定义赋值方法
public extension Optional {
    /// 仅当参数可选值非 `nil` 时,将其解包并赋值给当前可选值
    ///
    /// - Parameter other: 另一个值
    /// - Note: 相当于 `if let value = other { self = value }`
    @inlinable
    mutating func fdy_assignIfNotNil(_ other: Self) {
        if let value = other {
            self = value
        }
    }

    /// 仅当当前可选值为 `nil` 时,使用参数闭包的结果进行赋值（惰性求值）
    ///
    /// - Parameter other: 回调闭包
    /// - Note: 参数表达式仅在 `self == nil` 时求值
    @inlinable
    mutating func fdy_assignIfNil(_ other: @autoclosure () -> Self) {
        if self == nil {
            self = other()
        }
    }
}

// MARK: - 可选 RawRepresentable 类型与原始值的比较方法
public extension Optional where Wrapped: RawRepresentable, Wrapped.RawValue: Equatable {
    /// 判断当前 `Optional<Enum>` 的 `rawValue` 是否等于指定的可选原始值
    ///
    /// - Parameter rawValue: 可选原始值
    /// - Returns: 若两者 `rawValue` 相等（或同为 `nil`）,则返回 `true`
    /// - Note: 原 `==` 的两个方向（`Optional<Enum>` 与 `Optional<RawValue>` 互比）合并为本方法
    @inlinable
    func fdy_isEqual(to rawValue: Wrapped.RawValue?) -> Bool {
        self?.rawValue == rawValue
    }

    /// 判断当前 `Optional<Enum>` 的 `rawValue` 是否不等于指定的可选原始值
    ///
    /// - Parameter rawValue: 可选原始值
    /// - Returns: 若 `rawValue` 不等或仅一方为 `nil`,则返回 `true`
    /// - Note: 原 `!=` 的两个方向（`Optional<Enum>` 与 `Optional<RawValue>` 互比）合并为本方法
    @inlinable
    func fdy_isNotEqual(to rawValue: Wrapped.RawValue?) -> Bool {
        self?.rawValue != rawValue
    }
}
