import UIKit
import os.log

// MARK: - 屏幕捕获监控器
/// 屏幕截图 / 录屏监听器。回调与状态访问都在主线程,因此标注为 ``@MainActor``
@MainActor
public final class FdyScreenCaptureMonitor {
    public static let shared = FdyScreenCaptureMonitor()

    private var isMonitoring = false
    private var onScreenshot: FdyAction?
    private var onRecordingStart: FdyAction?
    private var onRecordingStop: FdyAction?

    /// 通知观察者 token。用 `nonisolated(unsafe)` 保存，使 `deinit`(nonisolated) 也能注销观察者，
    /// 避免 `start()` 后未调用 `stop()` 时观察者与闭包随单例永不释放
    private nonisolated(unsafe) var observerTokens: [NSObjectProtocol] = []

    private init() {}

    deinit {
        // deinit 不能访问 MainActor 隔离成员，只能清理上面的 nonisolated(unsafe) token
        observerTokens.forEach { NotificationCenter.default.removeObserver($0) }
    }
}

public extension FdyScreenCaptureMonitor {
    func start(
        onScreenshot: FdyAction?,
        onRecordingStart: FdyAction?,
        onRecordingStop: FdyAction?
    ) {
        guard !isMonitoring else {
            os_log("⚠️ UIScreen.startMonitoring 已在监听中,忽略重复调用")
            return
        }

        self.onScreenshot = onScreenshot
        self.onRecordingStart = onRecordingStart
        self.onRecordingStop = onRecordingStop

        // 监听截屏（回调经 queue: .main 投递，故用 assumeIsolated 进入 MainActor）
        let screenshotToken = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.onScreenshot?()
            }
        }
        observerTokens.append(screenshotToken)

        // 监听录屏
        if FdyScreen.isCaptured {
            self.onRecordingStart?()
        }

        let captureToken = NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                if FdyScreen.isCaptured {
                    self?.onRecordingStart?()
                } else {
                    self?.onRecordingStop?()
                }
            }
        }
        observerTokens.append(captureToken)

        isMonitoring = true
    }

    func stop() {
        observerTokens.forEach { NotificationCenter.default.removeObserver($0) }
        observerTokens.removeAll()

        onScreenshot = nil
        onRecordingStart = nil
        onRecordingStop = nil
        isMonitoring = false
    }
}
