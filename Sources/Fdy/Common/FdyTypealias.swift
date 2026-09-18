import Foundation

// MARK: - 无返回值
public typealias FdyAction = () -> Void
public typealias FdyAction1<A> = (A) -> Void
public typealias FdyAction2<A, B> = (A, B) -> Void

// MARK: - 有返回值
public typealias FdyFunc<R> = () -> R
public typealias FdyFunc1<A, R> = (A) -> R
public typealias FdyFunc2<A, B, R> = (A, B) -> R

// MARK: - 便利别名
/// 位置权限请求类型,等价于 ``FdyPermissionType/Location``
public typealias FdyLocationPermissionType = FdyPermissionType.Location
