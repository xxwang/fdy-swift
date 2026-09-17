import Foundation

// MARK: - 无返回值
public typealias FdyAction = () -> Void
public typealias FdyAction1<A> = (A) -> Void
public typealias FdyAction2<A, B> = (A, B) -> Void
public typealias FdyAction3<A, B, C> = (A, B, C) -> Void
public typealias FdyAction4<A, B, C, D> = (A, B, C, D) -> Void
public typealias FdyAction5<A, B, C, D, E> = (A, B, C, D, E) -> Void

// MARK: - 有返回值
public typealias FdyFunc<R> = () -> R
public typealias FdyFunc1<A, R> = (A) -> R
public typealias FdyFunc2<A, B, R> = (A, B) -> R
public typealias FdyFunc3<A, B, C, R> = (A, B, C) -> R
public typealias FdyFunc4<A, B, C, D, R> = (A, B, C, D) -> R
public typealias FdyFunc5<A, B, C, D, E, R> = (A, B, C, D, E) -> R

// MARK: - 便利别名
/// 位置权限请求类型,等价于 ``FdyPermissionType/Location``
public typealias FdyLocationPermissionType = FdyPermissionType.Location
