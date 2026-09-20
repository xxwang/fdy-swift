import Foundation

// MARK: - HTML Entity Encoding
public extension String {
    /// 把**每一个** Unicode 标量都转成 HTML 数字字符引用（格式 `&#xHHHH;`）
    ///
    /// - Returns: 处理后的字符串
    /// - Important: 这**不是**通常说的「HTML 转义」。常见做法只处理 `& < > " '` 五个字符，
    ///   而本方法**逐标量全编码** —— `"<&\""` 会变成 `&#x003c;&#x0026;&#x0022;`：
    ///   体积膨胀数倍、可读性为零。它适合「需要彻底防止任何字符被解释」的场景
    ///   （例如往 `<script>` 里塞字符串），**不适合**常规 HTML 文本转义。按需选用。
    /// - Note: 每个标量转成小写十六进制，至少补足 4 位。
    func fdy_htmlEncoded() -> String {
        unicodeScalars.map { scalar in
            let hex = String(scalar.value, radix: 16, uppercase: false)
            let paddedHex = String(repeating: "0", count: max(0, 4 - hex.count)) + hex
            return "&#x\(paddedHex);"
        }.joined()
    }

    /// 尝试将字符串中的 HTML 数字字符引用(如 `&#x0041;` 或 `&#65;`)解码为原始字符
    /// - Returns: 解码后的字符串;如果输入不含有效引用或结果为空,返回 `nil`
    /// - 支持十六进制(`&#x...;`,不区分大小写)和十进制(`&#...;`)
    /// - 不支持命名实体(如 `&lt;`, `&amp;`)
    /// - 无效或超出 Unicode 范围的引用会被忽略(不插入字符)
    func fdy_htmlDecoded() -> String? {
        // 匹配 &#x[hex]; (十六进制)和 &#[dec]; (十进制),不区分大小写
        let pattern = "(?i)&#(?:x([0-9a-f]+)|([0-9]+));"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }

        let nsString = self as NSString
        let fullRange = NSRange(location: 0, length: nsString.length)
        let matches = regex.matches(in: self, options: [], range: fullRange)

        guard !matches.isEmpty else {
            return nil // 无匹配项,提前返回
        }

        var result = ""
        var currentIndex = 0

        for match in matches {
            let entityRange = match.range(at: 0)
            // 添加实体前的普通文本
            if entityRange.location > currentIndex {
                let plainRange = NSRange(location: currentIndex, length: entityRange.location - currentIndex)
                result += nsString.substring(with: plainRange)
            }

            // 解析数值
            var codePoint: UInt32?
            if let hexRange = Range(match.range(at: 1), in: self), !hexRange.isEmpty {
                let hexStr = String(self[hexRange])
                codePoint = UInt32(hexStr, radix: 16)
            } else if let decRange = Range(match.range(at: 2), in: self), !decRange.isEmpty {
                let decStr = String(self[decRange])
                codePoint = UInt32(decStr)
            }

            // 验证并追加有效字符
            if let cp = codePoint, let scalar = Unicode.Scalar(cp) {
                result += String(scalar)
            }
            // 注意：无效引用被静默跳过(可按需改为保留原文本)

            currentIndex = entityRange.upperBound
        }

        // 添加末尾剩余文本
        if currentIndex < nsString.length {
            let tailRange = NSRange(location: currentIndex, length: nsString.length - currentIndex)
            result += nsString.substring(with: tailRange)
        }

        return result.isEmpty ? nil : result
    }
}
