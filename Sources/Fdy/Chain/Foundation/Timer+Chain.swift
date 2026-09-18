import Foundation

// MARK: - 链式方法
public extension FdyWrapper where Base: Timer {
    /// 加入当前 RunLoop 并启动(`Timer` 需 RunLoop 才能触发)
    /// - Parameter mode: 运行模式,默认为 `.default`
    /// - Returns: `Self`
    @discardableResult
    func addToCurrentRunLoop(mode: RunLoop.Mode = .default) -> Self {
        RunLoop.current.add(base, forMode: mode)
        return self
    }

    /// 立即触发定时器(不等待下一次时间到达)
    /// - Returns: `Self`
    @discardableResult
    func fire() -> Self {
        base.fire()
        return self
    }

    /// 停止定时器并从 RunLoop 移除
    /// - Returns: `Self`
    @discardableResult
    func invalidate() -> Self {
        base.invalidate()
        return self
    }
}
