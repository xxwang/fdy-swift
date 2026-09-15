import Foundation

// MARK: - 全局入口

/// 全局工具入口。通过 `fdy` 访问所有工具类。
///
/// ```swift
/// fdy.logger.debug("hello")
/// fdy.helper.isPad
/// fdy.perChecker.request(.camera) { ... }
/// fdy.queue.asyncMain { ... }
/// fdy.screen.width
/// fdy.symbol.monochrome(for: "star", color: .red)
/// fdy.path.documentsDirPath
/// ```
public let fdy = FdyGlobal()

/// 全局工具聚合器
public final class FdyGlobal: @unchecked Sendable {
    /// 设备辅助信息
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

    /// 屏幕信息
    public var screen: FdyScreen {
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
}
