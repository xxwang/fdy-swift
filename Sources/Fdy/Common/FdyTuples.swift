import Foundation

// MARK: - 元组容器
//
// Swift 原生元组无法被协议扩展、不能被 `Equatable`/`Hashable` 自动合成,
// 需要把二元以上的组合当作具名类型传递(如放进集合、作为泛型参数)时用这批容器。
//
// - Note: 一元组合没有容器意义(`FdyTuple1<A>` 就是 `A` 本身),故不提供。

/// 二元容器
public struct FdyTuple2<A, B> {
    public let item1: A
    public let item2: B

    public init(item1: A, item2: B) {
        self.item1 = item1
        self.item2 = item2
    }
}

/// 三元容器
public struct FdyTuple3<A, B, C> {
    public let item1: A
    public let item2: B
    public let item3: C

    public init(item1: A, item2: B, item3: C) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
    }
}

/// 四元容器
public struct FdyTuple4<A, B, C, D> {
    public let item1: A
    public let item2: B
    public let item3: C
    public let item4: D

    public init(item1: A, item2: B, item3: C, item4: D) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
    }
}

/// 五元容器
public struct FdyTuple5<A, B, C, D, E> {
    public let item1: A
    public let item2: B
    public let item3: C
    public let item4: D
    public let item5: E

    public init(item1: A, item2: B, item3: C, item4: D, item5: E) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        self.item5 = item5
    }
}
