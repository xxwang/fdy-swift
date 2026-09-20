import Foundation

// MARK: - 全局入口
public let fdyG = FdyGlobal()

// MARK: - 全局工具聚合器
public final class FdyGlobal {
    /// 设备辅助信息（UI 相关成员为 ``@MainActor``）
    public var helper: FdyHelper {
        FdyHelper.shared
    }

    /// 权限管理
    public var perChecker: FdyPermissionChecker {
        FdyPermissionChecker.shared
    }

    /// 任务队列
    public var queue: FdyQueue {
        FdyQueue.shared
    }

    /// 屏幕信息（必须在主线程使用）
    @MainActor public var screen: FdyScreen {
        FdyScreen.shared
    }

    /// SF Symbol 图标
    public var symbol: FdySymbol {
        FdySymbol.shared
    }

    /// 沙盒路径
    public var path: FdyPath {
        FdyPath.shared
    }

    /// 触觉反馈（必须在主线程使用）
    @MainActor public var haptic: FdyHaptic {
        FdyHaptic.shared
    }

    /// 全局 UI 外观（App 启动时的**一次性**默认样式，走 `UIAppearance` 代理；必须在主线程使用）
    @MainActor public var appearance: FdyAppearance {
        FdyAppearance.shared
    }

    /// 主题皮肤管理器（**运行期**主题切换，广播给已注册的 ``FdySkinable``，必须在主线程使用）
    @MainActor public var skinManager: FdySkinManager {
        FdySkinManager.shared
    }

    /// 屏幕录制 / 截屏监听（必须在主线程使用）
    @MainActor public var screenCaptureMonitor: FdyScreenCaptureMonitor {
        FdyScreenCaptureMonitor.shared
    }

    /// `.plist` 文件读写
    public var plist: FdyPlist {
        FdyPlist.shared
    }
}
