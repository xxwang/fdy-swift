import Foundation

// MARK: - 日志级别
public enum FdyLogLevel: Int, Comparable, CustomStringConvertible, CaseIterable {
    /// 调试
    case debug = 1
    /// 正常打印
    case info = 2
    /// 警告
    case warn = 3
    /// 错误
    case error = 4
    /// 致命错误
    case fatal = 5

    /// 按严重程度比较两个级别
    public static func < (lhs: FdyLogLevel, rhs: FdyLogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// 图标前缀（可选，增强可读性）
    /// - Returns: 处理后的字符串
    public var icon: String {
        switch self {
        case .debug: return "👻"
        case .info: return "🌸"
        case .warn: return "⚠️"
        case .error: return "❌"
        case .fatal: return "☠️"
        }
    }

    /// 级别的显示名
    public var description: String {
        switch self {
        case .debug: return "调试"
        case .info: return "正常"
        case .warn: return "警告"
        case .error: return "错误"
        case .fatal: return "致命"
        }
    }
}
