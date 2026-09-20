import Foundation

// MARK: - 下标
public extension BidirectionalCollection {
    /// 安全地通过偏移量访问元素
    ///
    /// - Parameter offset: 偏移量
    /// - Returns: 对应位置的元素,若越界则返回 `nil`
    subscript(fdy_safe offset: Int) -> Element? {
        let count = self.count
        // 空集合直接返回 nil
        guard count > 0 else { return nil }

        let index: Index
        if offset >= 0 {
            // 正向偏移：0, 1, 2, ...
            guard offset < count else { return nil }
            index = self.index(startIndex, offsetBy: offset)
        } else {
            // 负向偏移：-1 (last), -2, ...
            let positiveIndex = count + offset
            guard positiveIndex >= 0 else { return nil }
            index = self.index(startIndex, offsetBy: positiveIndex)
        }
        return self[index]
    }
}
