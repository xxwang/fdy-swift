import UIKit

// MARK: - 皮肤管理器实现
/// 主题皮肤管理器，所有操作通过 ``@MainActor`` 串行化
@MainActor
public final class FdySkinManager {
    /// 存储皮肤观察者的弱引用集合(自动清理已释放对象)
    private let observers = NSHashTable<AnyObject>.weakObjects()

    /// 全局共享实例
    public static let shared = FdySkinManager()

    /// 私有初始化,确保单例
    private init() {}
}

// MARK: - 观察者管理
public extension FdySkinManager {
    /// 注册一个皮肤观察者
    func register(observer: FdySkinable) {
        observers.add(observer)
    }

    /// 移除一个皮肤观察者
    func remove(observer: FdySkinable) {
        observers.remove(observer)
    }

    /// 刷新所有已注册观察者的皮肤样式
    func updateSkin() {
        let active = observers.allObjects.compactMap { $0 as? FdySkinable }
        active.forEach { $0.updateSkin() }
    }
}
