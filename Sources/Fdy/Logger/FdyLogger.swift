import Foundation

// MARK: - FdyLogger
public final class FdyLogger {
    /// 最低日志级别，低于此级别的日志将被忽略。
    /// 用独立锁保护，避免在 `log()` 热路径上同步等待串行队列（否则连被过滤的日志都阻塞调用线程）。
    public var minimumLevel: FdyLogLevel {
        get {
            levelLock.lock()
            defer { levelLock.unlock() }
            return _minimumLevel
        }
        set {
            levelLock.lock()
            _minimumLevel = newValue
            levelLock.unlock()
        }
    }

    private var _minimumLevel: FdyLogLevel = .debug
    private let levelLock = NSLock()

    /// 所有输出目标
    private var destinations: [FdyLogDestination] = []
    /// 串行队列，保证所有读写操作的线程安全
    private let queue = DispatchQueue(label: "logger.queue", qos: .userInitiated)

    public static let shared = FdyLogger()
    private init() {}
}

public extension FdyLogger {
    /// 添加输出目标
    /// - Parameter destination: 目标位置
    /// - Returns: 日志器
    @discardableResult
    func addDestination(_ destination: FdyLogDestination) -> FdyLogger {
        queue.sync { destinations.append(destination) }
        return self
    }

    /// 根据标识符移除指定输出目标
    /// - Parameter identifier: 标识符
    /// - Returns: 是否满足条件
    @discardableResult
    func removeDestination(identifier: String) -> Bool {
        queue.sync {
            if let idx = destinations.firstIndex(where: { $0.identifier == identifier }) {
                destinations[idx].teardown()
                destinations.remove(at: idx)
                return true
            }
            return false
        }
    }

    /// 移除所有输出目标
    func removeAllDestinations() {
        queue.sync {
            for dest in destinations {
                dest.teardown()
            }
            destinations.removeAll()
        }
    }

    /// 核心日志方法。在入队前先快速检查全局 minimumLevel（避免不必要的队列操作）；
    /// 入队后再按每个目标各自的 minimumLevel 分发。
    /// - Parameters:
    ///   - file: 文件路径
    ///   - function: 函数名
    ///   - line: 行号
    ///   - date: 日期
    ///   - level: 级别
    ///   - items: 元素数组
    func log(file: String, function: String, line: Int, date: Date, level: FdyLogLevel, items: [Any]) {
        // 快速路径：全局级别过滤，避免浪费队列调度
        if level < minimumLevel {
            return
        }

        self.queue.async { [weak self] in
            guard let self else { return }
            let context = FdyLogContext(file: file, function: function, line: line, date: date, level: level, items: items)
            self.dispatch(context)
        }
    }
}

// MARK: - 内部实现
private extension FdyLogger {
    /// 同步写日志，写完后刷盘（供 `fatal` 使用）
    func logSynchronously(file: String, function: String, line: Int, date: Date, level: FdyLogLevel, items: [Any]) {
        if level < minimumLevel {
            return
        }

        queue.sync { [weak self] in
            guard let self else { return }
            let context = FdyLogContext(file: file, function: function, line: line, date: date, level: level, items: items)
            self.dispatch(context)
            // 串行队列保证写入先于刷盘，文件目标据此立即 synchronizeFile
            self.destinations.forEach { $0.flush() }
        }
    }

    /// 按各目标自身的 `minimumLevel` 分发（须在 `queue` 上调用）
    func dispatch(_ context: FdyLogContext) {
        for destination in destinations {
            guard context.level >= destination.minimumLevel else { continue }
            destination.log(context: context)
        }
    }
}

// MARK: - 便捷方法
public extension FdyLogger {
    /// 调试
    /// - Parameters:
    ///   - items: 元素数组
    ///   - file: 文件路径,默认为 `#file`
    ///   - function: 函数名,默认为 `#function`
    ///   - line: 行号,默认为 `#line`
    func debug(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .debug, items: items)
    }

    /// 正常打印
    /// - Parameters:
    ///   - items: 元素数组
    ///   - file: 文件路径,默认为 `#file`
    ///   - function: 函数名,默认为 `#function`
    ///   - line: 行号,默认为 `#line`
    func info(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .info, items: items)
    }

    /// 警告
    /// - Parameters:
    ///   - items: 元素数组
    ///   - file: 文件路径,默认为 `#file`
    ///   - function: 函数名,默认为 `#function`
    ///   - line: 行号,默认为 `#line`
    func warn(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .warn, items: items)
    }

    /// 错误
    /// - Parameters:
    ///   - items: 元素数组
    ///   - file: 文件路径,默认为 `#file`
    ///   - function: 函数名,默认为 `#function`
    ///   - line: 行号,默认为 `#line`
    func error(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .error, items: items)
    }

    /// 致命错误（同步写，用于崩溃前）
    /// - Parameters:
    ///   - items: 元素数组
    ///   - file: 文件路径,默认为 `#file`
    ///   - function: 函数名,默认为 `#function`
    ///   - line: 行号,默认为 `#line`
    func fatal(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.logSynchronously(file: file, function: function, line: line, date: Date(), level: .fatal, items: items)
    }
}

// MARK: - 扩展到fdy空间下
public extension FdyGlobal {
    /// 全局日志器入口
    var logger: FdyLogger {
        return FdyLogger.shared
    }
}
