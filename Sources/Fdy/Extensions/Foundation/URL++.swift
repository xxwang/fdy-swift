import AVFoundation
import os.log
import UIKit
import UniformTypeIdentifiers

// MARK: - 命名空间入口
extension URL: FdyExtension {}

// MARK: - 属性
public extension URL {
    /// 检测应用是否能打开此 URL(需在` Info.plist` 中声明 `LSApplicationQueriesSchemes`)
    /// - Returns: 能打开返回 `true`,否则 `false`
    /// - ⚠️ 注意：从 iOS 9 开始,只能查询已白名单的 `scheme`(如 "`mailto`", "`tel`" 等需提前注册)
    var fdy_canOpen: Bool {
        UIApplication.shared.canOpenURL(self)
    }

    /// 判断是否为 HTTPS 协议
    /// - Returns: 是否满足条件
    var fdy_isHTTPS: Bool {
        self.scheme?.lowercased() == "https"
    }

    /// 解析查询参数为字典(重复 key 时后者覆盖前者)
    /// - Returns: 字符串字典,不可用时返回 `nil`
    var fdy_parameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        return Dictionary(
            queryItems.compactMap { item in
                guard let value = item.value else { return nil }
                return (item.name, value)
            },
            uniquingKeysWith: { _, new in new }
        )
    }

    /// 获取主机名(域名)
    /// - Returns: 处理后的字符串,不可用时返回 `nil`
    var fdy_hostName: String? {
        self.host
    }

    /// 获取文件名(最后一个路径组件)
    /// - Returns: 处理后的字符串
    var fdy_filename: String {
        self.lastPathComponent
    }

    /// 获取文件扩展名
    /// - Returns: 处理后的字符串,不可用时返回 `nil`
    var fdy_fileExtension: String? {
        self.pathExtension.isEmpty ? nil : self.pathExtension
    }

    /// 返回一个将路径中 `～` 展开后的 `URL`
    /// - Returns: URL
    var fdy_expandingTildeInUrl: URL {
        URL(fileURLWithPath: self.path.fdy_expandingTildeInPath)
    }

    /// 获取 MIME 类型
    /// - Returns: 处理后的字符串,不可用时返回 `nil`
    var fdy_mimeType: String? {
        let ext = self.pathExtension.lowercased()
        return UTType(filenameExtension: ext)?.preferredMIMEType
    }

    /// 将 URL 指向的内容读取为 Data(⚠️ 仅建议用于本地文件！网络 URL 会阻塞线程)
    /// - Returns: 数据,不可用时返回 `nil`
    /// - ⚠️ 警告：对网络 URL 调用会同步下载并阻塞当前线程,可能导致卡顿或崩溃
    ///   请仅用于 `isFileURL == true` 的场景
    var fdy_Data: Data? {
        guard self.isFileURL else {
            os_log(.error, "⚠️ Warning: data called on non-file URL. This may block the thread.")
            return nil
        }
        return try? Data(contentsOf: self)
    }

    /// 将 URL 字符串 Base64 编码
    /// - Returns: 处理后的字符串,不可用时返回 `nil`
    var fdy_base64Encoded: String? {
        self.absoluteString.data(using: .utf8)?.base64EncodedString()
    }

    /// 获取本地文件大小(仅适用于文件 URL)
    /// - Returns: 计算结果,不可用时返回 `nil`
    var fdy_fileSize: Int64? {
        guard self.isFileURL else { return nil }
        let attrs = try? FileManager.default.attributesOfItem(atPath: self.path)
        return attrs?[.size] as? Int64
    }

    /// 返回 URL 各组件组成的字典
    /// - Returns: 字符串字典
    var fdy_components: [String: String?] {
        [
            "scheme": self.scheme,
            "host": self.host,
            "path": self.path,
            "query": self.query,
            "fragment": self.fragment,
        ]
    }

    /// 获取路径组件列表(过滤掉 "/")
    /// - Returns: 字符串数组
    var fdy_pathComponentsList: [String] {
        self.pathComponents.filter { $0 != "/" }
    }
}

// MARK: - 方法
public extension URL {
    /// 删除指定查询参数
    /// - Parameter key: 键
    /// - Returns: URL
    func fdy_removeQueryParameter(for key: String) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        components.queryItems = components.queryItems?.filter { $0.name != key }
        return components.url ?? self
    }

    /// 追加查询参数(非 mutating 版本)
    /// - Parameter parameters: 参数集合
    /// - Returns: URL
    func fdy_appendParameters(_ parameters: [String: String]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        let newItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        components.queryItems = (components.queryItems ?? []) + newItems
        return components.url ?? self
    }

    /// 追加查询参数(mutating 版本)
    /// - Parameter parameters: 参数集合
    mutating func fdy_appendParameters(_ parameters: [String: String]) {
        self = self.fdy_appendParameters(parameters)
    }

    /// 获取指定查询参数的值
    /// - Parameter key: 键
    /// - Returns: 处理后的字符串,不可用时返回 `nil`
    func fdy_queryValue(for key: String) -> String? {
        URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first { $0.name == key }?
            .value
    }

    /// 删除所有路径组件,保留 scheme + host
    /// - Returns: URL
    func fdy_deleteAllPathComponents() -> URL {
        guard let host = self.host, let scheme = self.scheme else {
            return self
        }
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        return components.url ?? self
    }

    /// 删除所有路径组件(mutating)
    mutating func fdy_deleteAllPathComponents() {
        self = self.fdy_deleteAllPathComponents()
    }

    /// 移除 scheme(返回 "example.com/path?..." 形式)
    /// - Returns: URL,不可用时返回 `nil`
    /// - ⚠️ 不返回 URL 类型(因无 scheme 的字符串不是合法 URL),改为返回 String？
    ///   但为保持 API 一致,仍尝试构造 URL(可能失败)
    func fdy_droppedScheme() -> URL? {
        guard let host = self.host else { return nil }
        var result = host
        if !self.path.isEmpty, self.path != "/" {
            result += self.path
        }
        if let query = self.query {
            result += "?\(query)"
        }
        if let fragment = self.fragment {
            result += "#\(fragment)"
        }
        return URL(string: result)
    }

    /// 从视频 URL 异步生成指定时间的缩略图
    /// - Parameter time: 时间(秒)
    /// - Returns: UIImage?(失败返回 nil)
    func fdy_thumbnail(from time: Float64 = 0) async -> UIImage? {
        let asset = AVURLAsset(url: self)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true // 自动旋转修正

        let cmTime = CMTime(seconds: time, preferredTimescale: 600)

        return await withCheckedContinuation { continuation in
            generator.generateCGImageAsynchronously(for: cmTime) { cgImage, _, error in
                if let cgImage, error == nil {
                    continuation.resume(returning: UIImage(cgImage: cgImage))
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    /// 路径组件追加
    /// - Parameter path: 路径
    /// - Returns: URL
    func fdy_appendingPathComponent(_ path: String) -> URL {
        self.appending(component: path)
    }
}
