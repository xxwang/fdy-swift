import Foundation

/// 日志上下文——携带单条日志的元信息（文件、行号、级别、内容等）
public struct FdyLogContext {
    /// 所在文件
    /// - Returns: 处理后的字符串
    public let file: String
    /// 所在方法
    public let function: String
    /// 所在行号
    public let line: Int
    /// 日志日期
    public let date: Date
    /// 日志级别
    public let level: FdyLogLevel
    /// 日志内容
    public let items: [Any]

    /// 仅保留文件名，去除完整路径
    public var fileName: String {
        (file as NSString).lastPathComponent
    }

    /// 创建日志上下文
    public init(file: String, function: String, line: Int, date: Date, level: FdyLogLevel, items: [Any]) {
        self.file = file
        self.function = function
        self.line = line
        self.date = date
        self.level = level
        self.items = items
    }
}
