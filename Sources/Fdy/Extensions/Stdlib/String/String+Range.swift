import Foundation

// MARK: - 字符串范围（Range）与 NSRange 互转
public extension String {
    /// 返回字符串的完整字符范围（基于 `String.Index`）
    ///
    /// - Returns: `startIndex..<endIndex`
    var fdy_fullRange: Range<String.Index> {
        self.startIndex ..< self.endIndex
    }

    /// 返回字符串的完整范围（基于 `NSRange`,常用于与 Foundation 或正则 API 交互）
    ///
    /// - Returns: 对应的 `NSRange`（基于 UTF-16 单元）
    var fdy_fullNSRange: NSRange {
        NSRange(self.fdy_fullRange, in: self)
    }

    /// 将 `Range<String.Index>` 转换为 `NSRange`
    ///
    /// - Parameter range: 基于 `String.Index` 的字符范围
    /// - Returns: 对应的 `NSRange`（基于 UTF-16 单元）
    /// - Note: 等价于 `NSRange(_:in:)`,保留以统一 `fdy_` 前缀;要求 `range` 是当前字符串的有效子范围
    func fdy_toNSRange(from range: Range<String.Index>) -> NSRange {
        NSRange(range, in: self)
    }

    /// 查找子字符串在当前字符串中的首次出现位置（基于 `NSRange`）
    ///
    /// - Parameter substring: 要查找的子字符串
    /// - Returns: 找到则返回 `NSRange`;否则返回 `NSRange(location: NSNotFound, length: 0)`（符合 Foundation 惯例）
    func fdy_subNSRange(of substring: String) -> NSRange {
        guard let range = self.range(of: substring) else {
            return NSRange(location: NSNotFound, length: 0)
        }
        return NSRange(range, in: self)
    }

    /// 查找所有匹配子串的字符范围（支持自定义比较选项）
    ///
    /// - Parameters:
    ///   - substring: 要查找的子字符串
    ///   - options: 字符串比较选项（如 `.caseInsensitive`）,默认为空
    /// - Returns: 所有匹配位置的 `Range<String.Index>` 数组（按出现顺序）
    func fdy_ranges(of substring: String, options: String.CompareOptions = []) -> [Range<String.Index>] {
        guard !substring.isEmpty else { return [] }
        var results: [Range<String.Index>] = []
        var searchStart = self.startIndex

        while searchStart < self.endIndex,
              let range = self.range(of: substring, options: options, range: searchStart ..< self.endIndex)
        {
            results.append(range)
            searchStart = range.upperBound
        }

        return results
    }

    /// 查找所有匹配子串的 `NSRange`（支持自定义比较选项）
    ///
    /// - Parameters:
    ///   - substring: 要查找的子字符串
    ///   - options: 字符串比较选项（如 `.caseInsensitive`）,默认为空
    /// - Returns: 所有匹配位置的 `NSRange` 数组（按出现顺序）
    func fdy_nsRanges(of substring: String, options: String.CompareOptions = []) -> [NSRange] {
        self.fdy_ranges(of: substring, options: options).map { self.fdy_toNSRange(from: $0) }
    }
}

// MARK: - 字符串填充（左/右对齐）
public extension String {
    /// 在字符串开头填充字符,直到达到指定长度（左对齐）
    ///
    /// - Parameters:
    ///   - length: 长度
    ///   - padding: 用于填充的字符串（默认为空格）
    /// - Returns: 填充后的字符串;若原长度 ≥ 目标长度或填充串为空,则返回原字符串
    func fdy_padStart(toLength length: Int, with padding: String = " ") -> String {
        guard length > self.count, !padding.isEmpty else { return self }
        let needed = length - self.count
        let repeatCount = (needed + padding.count - 1) / padding.count
        let repeated = String(repeating: padding, count: repeatCount)
        return String(repeated.prefix(needed)) + self
    }

    /// 在字符串末尾填充字符,直到达到指定长度（右对齐）
    ///
    /// - Parameters:
    ///   - length: 长度
    ///   - padding: 用于填充的字符串（默认为空格）
    /// - Returns: 填充后的字符串;若长度 ≥ 目标长度或填充串为空,则返回原字符串
    func fdy_padEnd(toLength length: Int, with padding: String = " ") -> String {
        guard length > self.count, !padding.isEmpty else { return self }
        let needed = length - self.count
        let repeatCount = (needed + padding.count - 1) / padding.count
        let repeated = String(repeating: padding, count: repeatCount)
        return self + String(repeated.prefix(needed))
    }
}

// MARK: - 子字符串位置查找扩展
public extension String {
    /// 返回子字符串首次出现的字符位置
    ///
    /// - Parameter substring: 要查找的子字符串
    /// - Returns: 首次出现的起始位置（按 `Character` 序号,从 0 开始）,未找到返回 `-1`
    /// - Note: 与 `fdy_substring(from:)` 等价同源,二者的返回值可直接互传
    func fdy_positionFirst(of substring: String) -> Int {
        self.fdy_position(of: substring, backwards: false)
    }

    /// 返回子字符串最后一次出现的字符位置
    ///
    /// - Parameter substring: 要查找的子字符串
    /// - Returns: 最后一次出现的起始位置（按 `Character` 序号）,未找到返回 `-1`
    func fdy_positionLast(of substring: String) -> Int {
        self.fdy_position(of: substring, backwards: true)
    }

    /// 私有辅助方法：统一实现前后向查找
    private func fdy_position(of substring: String, backwards: Bool) -> Int {
        guard !substring.isEmpty else { return -1 }
        let options: String.CompareOptions = backwards ? .backwards : []
        if let range = self.range(of: substring, options: options) {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        }
        return -1
    }
}

// MARK: - 安全截取（Character 序号口径）
// ⚠️ **`NSRange` 系是 UTF-16 口径**（`fdy_toNSRange` / `fdy_subNSRange` / `fdy_nsRanges` /
// `fdy_fullNSRange` / `[fdy_nsRange: NSRange]`）—— 属「与 Foundation 互转」而非另一套下标，
// 与 Character 序号**不可互相传递位置**。
// 口径约定：**默认 `Character` 序号**（`fdy_slice` / `fdy_substring` / `fdy_range`）—— 只有 `NSRange` 系带 `ns`。
public extension String {
    /// 根据 `Range<Int>`（字符序号）安全截取子字符串
    ///
    /// - Parameter range: 前闭后开的整数范围（按 `Character` 序号）
    /// - Returns: 截取结果;若范围无效或越界,返回空字符串
    func fdy_slice(_ range: Range<Int>) -> String {
        guard !range.isEmpty,
              range.lowerBound >= 0,
              range.upperBound <= self.count
        else {
            return ""
        }

        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return String(self[start ..< end])
    }

    /// 从指定字符位置截取到字符串末尾
    ///
    /// - Parameter from: 起始位置（`Character` 序号）
    /// - Returns: 截取结果;若 `from` 越界,返回空字符串
    func fdy_substring(from: Int) -> String {
        let start = min(max(0, from), self.count)
        return self.fdy_slice(start ..< self.count)
    }

    /// 从开头截取到指定字符位置（不包含）
    ///
    /// - Parameter to: 结束位置（`Character` 序号）
    /// - Returns: 截取结果;若 `to` 越界,自动截断至末尾
    func fdy_substring(to: Int) -> String {
        let end = min(max(0, to), self.count)
        return self.fdy_slice(0 ..< end)
    }

    /// 从指定位置截取固定字符数
    ///
    /// - Parameters:
    ///   - from: 起始位置（`Character` 序号）
    ///   - length: 截取字符数
    /// - Returns: 尽可能截取的有效子串;若 `length <= 0`,返回空字符串
    func fdy_substring(from: Int, length: Int) -> String {
        guard length > 0 else { return "" }
        let start = min(max(0, from), self.count)
        let end = min(start + length, self.count)
        return self.fdy_slice(start ..< end)
    }

    /// 在两个字符位置之间截取子串（自动处理顺序颠倒）
    ///
    /// - Parameters:
    ///   - from: 起始位置
    ///   - to: 结束位置（不包含）
    /// - Returns: 有效范围内的子串
    func fdy_substring(from: Int, to: Int) -> String {
        let end = min(max(0, max(from, to)), self.count)
        let start = min(max(0, min(from, to)), end)
        return self.fdy_slice(start ..< end)
    }

    /// 获取指定字符位置的一个字符（作为字符串）
    ///
    /// - Parameter index: **`Character` 序号**（从 0 开始）
    /// - Returns: 对应位置的字符串;若索引无效,返回空字符串
    /// - Note: 与 `[fdy_safe: i]`（见 `String+Subscript.swift`）同源;区别是该下标越界返回 `nil`、本方法返回空字符串
    func fdy_Character(at index: Int) -> String {
        self.fdy_substring(from: index, length: 1)
    }

    /// 截断字符串至指定字符数
    ///
    /// - Parameter length: 最大保留字符数
    /// - Returns: 截断后的字符串;若未超长,返回原串
    func fdy_truncate(length: Int) -> String {
        guard length < self.count else { return self }
        return self.fdy_substring(to: length)
    }

    /// 截断字符串并在末尾追加尾部标记（如省略号）
    ///
    /// - Parameters:
    ///   - length: 最大保留字符数（不含尾部标记）
    ///   - trailing: 尾部附加字符串,默认为 `"..."`
    /// - Returns: 截断并追加标记的字符串;若未超长,返回原串
    /// - Warning: 总长度 = `length + trailing.count`,可能超过 `length`
    func fdy_truncate(length: Int, trailing: String = "...") -> String {
        guard length >= 0, self.count > length else { return self }
        let truncated = self.fdy_substring(to: length)
        return truncated + trailing
    }

    /// 按固定字符数分段,并用分隔符连接
    ///
    /// - Parameters:
    ///   - segmentLength: 每段的字符数
    ///   - separator: 分隔符,默认为 `"-"`
    /// - Returns: 分段拼接后的字符串
    func fdy_chunked(segmentLength: Int, separator: String = "-") -> String {
        guard segmentLength > 0 else { return self }

        var result: [String] = []
        var offset = 0

        while offset < self.count {
            let end = min(offset + segmentLength, self.count)
            result.append(self.fdy_slice(offset ..< end))
            offset = end
        }

        return result.joined(separator: separator)
    }
}
