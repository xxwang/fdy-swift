import UIKit
import os.log

// MARK: - 屏幕捕获监控器
public final class FdyScreenCaptureMonitor {
    public static let shared = FdyScreenCaptureMonitor()

    private var isMonitoring = false
    private var screenshotObserver: NSObjectProtocol?
    private var captureObserver: NSObjectProtocol?

    private var onScreenshot: FdyAction?
    private var onRecordingStart: FdyAction?
    private var onRecordingStop: FdyAction?

    private init() {}
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

        // 监听截屏
        screenshotObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.onScreenshot?()
        }

        // 监听录屏
        if FdyScreen.isCaptured {
            self.onRecordingStart?()
        }

        captureObserver = NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            if FdyScreen.isCaptured {
                self.onRecordingStart?()
            } else {
                self.onRecordingStop?()
            }
        }

        isMonitoring = true
    }

    func stop() {
        if let observer = screenshotObserver {
            NotificationCenter.default.removeObserver(observer)
            screenshotObserver = nil
        }
        if let observer = captureObserver {
            NotificationCenter.default.removeObserver(observer)
            captureObserver = nil
        }

        onScreenshot = nil
        onRecordingStart = nil
        onRecordingStop = nil
        isMonitoring = false
    }
}
