import Foundation

// MARK: - Base64 编解码扩展
public extension String {
    /// 将字符串以 UTF-8 编码后进行 Base64 编码
    ///
    /// - Returns: Base64 编码字符串,或 `nil`（理论上 UTF-8 不会失败）
    var fdy_base64Encoded: String? {
        self.fdy_Data()?.base64EncodedString()
    }

    /// 将 Base64 字符串解码为 UTF-8 字符串
    ///
    /// - Returns: 解码后的字符串,或 `nil`
    /// - Note: 容忍非法字符（空格、换行等,按 `.ignoreUnknownCharacters` 忽略）,
    ///   并自动补全缺失的填充符 `=`;补全后仍无法解码则返回 `nil`
    /// - Example:
    ///   ```swift
    ///   "SGVsbG8g8J+MjQ".fdy_base64Decoded  // Optional("Hello 😊")
    ///   "SGVsbG8g8J+MjQ==".fdy_base64Decoded // Optional("Hello 😊")
    ///   ```
    var fdy_base64Decoded: String? {
        // 第一次尝试：标准解码
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters),
           let str = String(data: data, encoding: .utf8)
        {
            return str
        }

        // 自动补全填充
        let remainder = self.count % 4
        if remainder != 0 {
            let padded = self + String(repeating: "=", count: 4 - remainder)
            if let data = Data(base64Encoded: padded, options: .ignoreUnknownCharacters),
               let str = String(data: data, encoding: .utf8)
            {
                return str
            }
        }
        return nil
    }
}
