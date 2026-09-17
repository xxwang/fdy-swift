import UIKit

// MARK: - 主题可响应协议
/// 主题皮肤可响应协议。实现方在收到 ``FdySkinManager`` 广播时更新自身样式。
///
/// 与 ``FdyAppearance`` 的分工：
/// - `FdyAppearance` —— App 启动时的**一次性**全局默认样式（走 `UIAppearance` 代理）
/// - `FdySkinable` / ``FdySkinManager`` —— **运行期**主题切换（走观察者广播）
public protocol FdySkinable: AnyObject {
    /// 更新主题样式
    func updateSkin()
}

// MARK: - 提供对全局皮肤管理器的快捷访问
@MainActor
public extension FdySkinable where Self: UITraitEnvironment {
    /// 全局皮肤管理器实例,用于注册/移除观察者或触发刷新
    var skinManager: FdySkinManager {
        FdySkinManager.shared
    }
}
