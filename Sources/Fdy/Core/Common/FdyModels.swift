import Foundation

public struct FdyModel1<A> {
    public let item1: A

    public init(item1: A) {
        self.item1 = item1
    }
}

public struct FdyModel2<A, B> {
    public let item1: A
    public let item2: B

    public init(item1: A, item2: B) {
        self.item1 = item1
        self.item2 = item2
    }
}

public struct FdyModel3<A, B, C> {
    public let item1: A
    public let item2: B
    public let item3: C

    public init(item1: A, item2: B, item3: C) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
    }
}

public struct FdyModel4<A, B, C, D> {
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

public struct FdyModel5<A, B, C, D, E> {
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
