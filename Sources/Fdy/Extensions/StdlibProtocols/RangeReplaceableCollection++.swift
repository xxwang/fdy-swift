import Foundation

// MARK: - 构造方法
public extension RangeReplaceableCollection {
    /// 使用表达式结果创建一个指定大小的集合
    ///
    /// - Parameters:
    ///   - expression: 返回元素的自动闭包(惰性求值)
    ///   - count: 元素数量(必须 ≥ 0)
    /// - Throws: 若 `expression` 抛出错误,则初始化失败
    ///
    /// - Note: 表达式会在每次追加时重新求值(适合生成唯一值,如 UUID)
    init(fdy_expression expression: @autoclosure () throws -> Element, count: Int) rethrows {
        precondition(count >= 0, "Count must be non-negative")
        self.init()
        guard count > 0 else { return }
        self.reserveCapacity(count)
        for _ in 0 ..< count {
            try self.append(expression())
        }
    }
}

// MARK: - 下标
public extension RangeReplaceableCollection {
    /// 访问集合指定位置的元素
    /// - Parameter offset: 元素的位置偏移
    /// - Returns: 指定位置的元素
    subscript(fdy_offset offset: Int) -> Element {
        get {
            precondition(offset >= 0 && offset < count, "Index out of bounds")
            return self[index(startIndex, offsetBy: offset)]
        }
        set {
            precondition(offset >= 0 && offset < count, "Index out of bounds")
            let offsetIndex = index(startIndex, offsetBy: offset)
            self.replaceSubrange(offsetIndex ..< index(after: offsetIndex), with: [newValue])
        }
    }

    /// 访问集合指定范围的元素(返回切片)
    /// - Parameter range: 元素的范围
    /// - Returns: 结果切片 `SubSequence`
    ///
    /// - Note: 标签刻意用 `fdy_slice` 而非 `fdy_range` —— `String` 也是 `RangeReplaceableCollection`,
    ///   若两条同名同约束(仅返回类型不同:`String?` vs `SubSequence`),重载会靠上下文返回类型消解,
    ///   同一表达式 `str[fdy_range: r]` 会因标注不同而返回不同类型。切片用 `fdy_slice`、安全子串用 `fdy_range`；
    ///   `NSRange`（UTF-16）口径另用 `fdy_nsRange`，见 `String+Subscript.swift`。
    subscript<R>(fdy_slice range: R) -> SubSequence where R: RangeExpression, R.Bound == Int {
        get {
            let indexRange = range.relative(to: 0 ..< count)
            return self[index(startIndex, offsetBy: indexRange.lowerBound) ..< index(startIndex, offsetBy: indexRange.upperBound)]
        }
        set {
            let indexRange = range.relative(to: 0 ..< count)
            self.replaceSubrange(
                index(startIndex, offsetBy: indexRange.lowerBound) ..< index(startIndex, offsetBy: indexRange.upperBound),
                with: newValue
            )
        }
    }
}

// MARK: - 旋转
public extension RangeReplaceableCollection {
    /// 返回一个按指定位置旋转后的副本
    ///
    /// - Parameter places: 旋转位数正数向右旋转,负数向左旋转
    /// - Returns: 旋转后的新集合
    func fdy_rotated(by places: Int) -> Self {
        var copy = self
        copy.fdy_rotate(by: places)
        return copy
    }

    /// 原地旋转集合(通用实现,适用于所有 RangeReplaceableCollection)
    ///
    /// - Parameter places: 旋转位数正数向右旋转,负数向左旋转
    /// - Returns: 修改后的集合
    ///
    /// - Note: 该实现具有 O(n) 时间和空间复杂度
    ///         若需极致性能(如大数组),建议使用针对 `Array` 的特化版本
    @discardableResult
    mutating func fdy_rotate(by places: Int) -> Self {
        guard !isEmpty, places != 0 else { return self }

        let n = count
        let k = (places % n + n) % n

        let midIndex = index(startIndex, offsetBy: k)
        let rotated = [self[midIndex...], self[..<midIndex]].joined()
        self = Self(rotated)

        return self
    }
}

// MARK: - 删除
public extension RangeReplaceableCollection {
    /// 删除第一个满足条件的元素
    ///
    /// - Parameter condition: 回调闭包
    /// - Returns: 被删除的元素,若无匹配则返回 `nil`
    @discardableResult
    mutating func fdy_removeFirst(where condition: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try firstIndex(where: condition) else { return nil }
        return remove(at: index)
    }

    /// 删除所有重复元素(基于 `Hashable`)
    ///
    /// - Parameter transform: 提取用于比较的 `Hashable` 值的函数
    mutating func fdy_removeDuplicates<T: Hashable>(by transform: (Element) throws -> T) rethrows {
        var seen = Set<T>()
        try removeAll { element in
            let key = try transform(element)
            return !seen.insert(key).inserted
        }
    }

    /// 删除所有重复元素(基于 `Hashable`)
    ///
    /// - Note: 保留首次出现的元素
    mutating func fdy_removeDuplicates() where Element: Hashable {
        var seen = Set<Element>()
        removeAll { !seen.insert($0).inserted }
    }

    /// 随机删除一个元素
    ///
    /// - Returns: 被删除的元素,若集合为空则返回 `nil`
    @discardableResult
    mutating func fdy_removeRandomElement() -> Element? {
        guard let randomIndex = indices.randomElement() else { return nil }
        return remove(at: randomIndex)
    }
}

// MARK: - 条件截取
public extension RangeReplaceableCollection {
    /// 原地保留从头开始满足条件的连续元素
    ///
    /// - Parameter condition: 回调闭包
    /// - Returns: 修改后的集合
    @discardableResult
    mutating func fdy_keep(while condition: (Element) throws -> Bool) rethrows -> Self {
        if let firstNonMatching = try firstIndex(where: { try !condition($0) }) {
            removeSubrange(firstNonMatching...)
        }
        return self
    }

    /// 返回从头开始满足条件的连续元素
    ///
    /// - Parameter condition: 回调闭包
    /// - Returns: 新集合
    func fdy_take(while condition: (Element) throws -> Bool) rethrows -> Self {
        return try Self(prefix(while: condition))
    }

    /// 返回跳过开头满足条件的连续元素后的剩余部分
    ///
    /// - Parameter condition: 回调闭包
    /// - Returns: 新集合
    func fdy_skip(while condition: (Element) throws -> Bool) rethrows -> Self {
        guard let firstNonMatching = try firstIndex(where: { try !condition($0) }) else {
            return Self()
        }
        return Self(self[firstNonMatching...])
    }
}

// MARK: - 追加
public extension RangeReplaceableCollection {
    /// 仅当元素非 `nil` 时追加
    ///
    /// - Parameter element: 可选元素
    mutating func fdy_appendIfNonNil(_ element: Element?) {
        if let element {
            append(element)
        }
    }

    /// 仅当序列非 `nil` 时追加其所有元素
    ///
    /// - Parameter newElements: 可选序列
    mutating func fdy_appendIfNonNil(contentsOf newElements: (some Sequence<Element>)?) {
        if let newElements {
            append(contentsOf: newElements)
        }
    }
}
