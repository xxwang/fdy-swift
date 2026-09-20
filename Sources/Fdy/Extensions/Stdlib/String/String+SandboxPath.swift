import Foundation

// MARK: - 沙盒路径解析：返回完整路径字符串(String)
public extension String {
    /// 将当前字符串作为相对路径,解析为 Documents 目录下的绝对路径
    ///
    /// - Returns: 完整的文件系统路径字符串
    /// - Throws: 不会抛出错误,但若无法获取 Documents 目录会触发断言失败(仅调试模式)
    func fdy_pathInDocuments() -> String {
        FdyPath.shared.path(inDocuments: self)
    }

    /// 将当前字符串作为相对路径,解析为 Caches 目录下的绝对路径
    ///
    /// - Returns: 处理后的字符串
    /// - Caches 目录用于存放可再生的缓存数据,系统可能在存储空间不足时清除
    func fdy_pathInCaches() -> String {
        FdyPath.shared.path(inCaches: self)
    }

    /// 将当前字符串作为相对路径,解析为临时目录(tmp)下的绝对路径
    ///
    /// - Returns: 处理后的字符串
    /// - 临时目录用于短期存储,应用重启后内容可能被清除
    func fdy_pathInTemporaryDirectory() -> String {
        FdyPath.shared.path(inTemp: self)
    }

    /// 将当前字符串作为相对路径,解析为 Application Support 目录下的绝对路径
    ///
    /// - Returns: 处理后的字符串
    /// - Application Support 目录用于存放应用支持文件,`会被 iCloud 备份`
    /// - 首次使用时建议确保父目录存在(可通过 `FileManager` 创建)
    func fdy_pathInApplicationSupport() -> String {
        FdyPath.shared.path(inApplicationSupport: self)
    }
}

// MARK: - 沙盒路径解析：返回 URL
/// 返回对应沙盒目录中文件的 `URL`。Apple 推荐使用 `URL` 而非 `String` 表示文件路径,
/// 因其能正确处理 Unicode、特殊字符、编码等问题
///
/// 这些是**方法**（不是计算属性）—— 与上一节保持一致：结果依赖运行时沙盒目录的位置，
/// 方法调用形式本身就在提醒「每次调用都会去取系统目录」。
public extension String {
    /// Documents 目录中对应文件的 URL
    /// - Returns: URL
    func fdy_urlInDocuments() -> URL {
        FdyPath.shared.url(inDocuments: self)
    }

    /// Caches 目录中对应文件的 URL
    /// - Returns: URL
    func fdy_urlInCaches() -> URL {
        FdyPath.shared.url(inCaches: self)
    }

    /// 临时目录(tmp)中对应文件的 URL
    /// - Returns: URL
    func fdy_urlInTemporary() -> URL {
        FdyPath.shared.url(inTemp: self)
    }

    /// Application Support 目录中对应文件的 URL
    /// - Returns: URL
    func fdy_urlInApplicationSupport() -> URL {
        FdyPath.shared.url(inApplicationSupport: self)
    }
}
