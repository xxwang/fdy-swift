import Foundation

// MARK: - 方法
public extension NSPredicate {
    /// 返回当前谓词的逻辑非(NOT)
    /// - Returns: 一个表示 `NOT (self)` 的复合谓词
    ///
    /// - Example:
    ///   ```swift
    ///   let pred = NSPredicate(format: "age > 18")
    ///   let notPred = pred.fdy_not()
    ///   // 等价于 "NOT (age > 18)"
    ///   ```
    func fdy_not() -> NSPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self)
    }

    /// 返回当前谓词与另一个谓词的逻辑与(AND)
    /// - Parameter other: 另一个谓词
    /// - Returns: 一个表示 `self AND other` 的复合谓词
    func fdy_and(_ other: NSPredicate) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, other])
    }

    /// 返回当前谓词与另一个谓词的逻辑或(OR)
    /// - Parameter other: 另一个谓词
    /// - Returns: 一个表示 `self OR other` 的复合谓词
    func fdy_or(_ other: NSPredicate) -> NSPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, other])
    }

    /// 返回满足当前谓词但不满足另一个谓词的结果(即 A AND NOT B)
    /// - Parameter other: 要排除的谓词
    /// - Returns: 一个表示 `self AND NOT other` 的复合谓词
    func fdy_excluding(_ other: NSPredicate) -> NSPredicate {
        return self.fdy_and(other.fdy_not())
    }
}
