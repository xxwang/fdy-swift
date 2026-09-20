import Foundation

// MARK: - URL 操作扩展
public extension String {
    /// 将字符串转义为 POSIX shell 安全的单引号形式
    /// 规则：用单引号包裹,内部单引号用 '\'' 转义
    /// - Returns: 处理后的字符串
    var fdy_shellEscaped: String {
        // 替换每个 ' 为 '\''
        let escaped = self.replacingOccurrences(of: "'", with: "'\\''")
        return "'\(escaped)'"
    }

    /// 从字符串中提取所有有效的 URL 链接
    ///
    /// 使用系统 `NSDataDetector` 自动识别文本中的超链接(包括 http/https 等)
    /// 返回 `URL` 对象数组,保留原始编码信息,便于后续安全操作
    ///
    /// - Returns: 所有匹配到的 `URL` 对象数组;若无匹配,返回空数组 `[]`
    /// - Note: 每次访问都会**新建一个 `NSDataDetector`**。它并非零成本对象，
    ///   若在滚动列表这类高频路径上反复取用，建议自行缓存 detector 再复用。
    var fdy_urls: [URL] {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return [] // 极罕见情况,返回空数组比崩溃更安全
        }

        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = detector.matches(in: self, options: [], range: range)

        return matches.compactMap { result in
            result.url // 自动过滤 nil
        }
    }

    /// 解析当前字符串作为 URL 的查询参数(query string),返回每个键对应的所有值
    ///
    /// - Returns: `[String: [String]]`,每个键对应一个字符串数组(至少包含一个元素)
    /// - 自动对 percent-encoded 的键和值进行解码(如 `%20` → 空格)
    /// - 支持重复键(如 `?tag=a&tag=b` → `["tag": ["a", "b"]]`)
    /// - 若字符串不是有效 URL 或无查询参数,返回空字典
    var fdy_queryParameters: [String: [String]] {
        guard let components = URLComponents(string: self),
              let queryItems = components.queryItems,
              !queryItems.isEmpty
        else {
            return [:]
        }

        var parameters: [String: [String]] = [:]

        for item in queryItems {
            // 自动解码 percent-encoded 字符串
            let key = item.name.removingPercentEncoding ?? item.name
            let value = item.value?.removingPercentEncoding ?? ""

            if var existing = parameters[key] {
                existing.append(value)
                parameters[key] = existing
            } else {
                parameters[key] = [value]
            }
        }

        return parameters
    }

    /// 解析查询参数,仅保留每个键的第一个值(忽略重复键)
    ///
    /// - Returns: `[String: String]`,每个键对应第一个出现的值
    /// - 适用于大多数简单场景(如表单提交)
    /// - 同样会自动解码 percent-encoded 内容
    var fdy_firstQueryParameters: [String: String] {
        let multiParams = self.fdy_queryParameters
        var singleParams: [String: String] = [:]
        for (key, values) in multiParams {
            singleParams[key] = values.first ?? ""
        }
        return singleParams
    }
}
