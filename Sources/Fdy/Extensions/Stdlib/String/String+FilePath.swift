import Foundation

// MARK: - 文件路径基础操作(基于 NSString 的 POSIX 路径处理)
public extension String {
    /// 返回路径的最后一个组件
    /// - Returns: 处理后的字符串
    var fdy_lastPathComponent: String {
        (self as NSString).lastPathComponent
    }

    /// 返回路径的扩展名(不含前导点)
    /// - Returns: 处理后的字符串
    var fdy_pathExtension: String {
        (self as NSString).pathExtension
    }

    /// 返回删除最后一个路径组件后的路径
    /// - Returns: 处理后的字符串
    var fdy_deletingLastPathComponent: String {
        (self as NSString).deletingLastPathComponent
    }

    /// 返回删除路径扩展名后的路径
    /// - Returns: 处理后的字符串
    var fdy_deletingPathExtension: String {
        (self as NSString).deletingPathExtension
    }

    /// 返回路径的所有组件数组(包含根目录 "/")
    /// - Returns: 字符串数组
    var fdy_pathComponents: [String] {
        (self as NSString).pathComponents
    }

    /// 在当前路径后追加一个路径组件,自动处理路径分隔符
    ///
    /// - Parameter component: 要追加的路径组件(不应以 `/` 开头)
    /// - Returns: 拼接后的新路径字符串
    func fdy_appendingPathComponent(_ component: String) -> String {
        (self as NSString).appendingPathComponent(component)
    }

    /// 为当前路径添加扩展名(自动添加前导点)
    ///
    /// - Parameter ext: 扩展名(不应包含点)
    /// - Returns: 添加扩展名后的新路径;若原路径为空或为绝对根路径,则可能返回 `nil`
    func fdy_appendingPathExtension(_ ext: String) -> String? {
        (self as NSString).appendingPathExtension(ext)
    }

    /// 返回将 `~` 展开为用户主目录后的路径字符串
    /// - Returns: 处理后的字符串
    var fdy_expandingTildeInPath: String {
        (self as NSString).expandingTildeInPath
    }
}
