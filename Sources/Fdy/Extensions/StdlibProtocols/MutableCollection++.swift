import Foundation

// MARK: - 方法
public extension MutableCollection {
    /// 将集合中所有元素的指定属性设置为同一值
    ///
    /// - Parameters:
    ///   - value: 要设置的新值
    ///   - keyPath: 指向可写属性的 `WritableKeyPath`
    mutating func fdy_setAll<Value>(_ value: Value, for keyPath: WritableKeyPath<Element, Value>) {
        for index in indices {
            self[index][keyPath: keyPath] = value
        }
    }
}

// MARK: - RandomAccessCollection相关方法
public extension MutableCollection where Self: RandomAccessCollection {
    /// 根据指定属性和自定义比较规则对集合进行原地排序
    ///
    /// - Parameters:
    ///   - keyPath: 用于提取排序依据的 `KeyPath`
    ///   - compare: 自定义比较闭包,返回 `true` 表示第一个元素应排在前面
    mutating func fdy_sort<T>(by keyPath: KeyPath<Element, T>, with compare: (T, T) -> Bool) {
        sort { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    /// 根据指定属性对集合进行升序排序(要求属性符合 `Comparable`)
    ///
    /// - Parameter keyPath: 指向 `Comparable` 属性的 `KeyPath`
    mutating func fdy_sort(by keyPath: KeyPath<Element, some Comparable>) {
        sort { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    /// 根据两个属性对集合进行多级升序排序
    ///
    /// - Parameters:
    ///   - primary: 主排序属性(`Comparable`)
    ///   - secondary: 次排序属性(`Comparable`)
    ///
    /// - Note: 先按 `primary` 排序,相等时再按 `secondary` 排序
    mutating func fdy_sort(
        by primary: KeyPath<Element, some Comparable>,
        and secondary: KeyPath<Element, some Comparable>
    ) {
        sort {
            let a1 = $0[keyPath: primary], b1 = $1[keyPath: primary]
            if a1 != b1 {
                return a1 < b1
            }
            let a2 = $0[keyPath: secondary], b2 = $1[keyPath: secondary]
            return a2 < b2
        }
    }

    /// 根据三个属性对集合进行多级升序排序
    ///
    /// - Parameters:
    ///   - k1: 第一排序属性
    ///   - k2: 第二排序属性
    ///   - k3: 第三排序属性
    ///
    /// - Note: 依次比较,前一属性相等时才比较下一属性
    mutating func fdy_sort(
        by k1: KeyPath<Element, some Comparable>,
        and k2: KeyPath<Element, some Comparable>,
        and k3: KeyPath<Element, some Comparable>
    ) {
        sort {
            if $0[keyPath: k1] != $1[keyPath: k1] {
                return $0[keyPath: k1] < $1[keyPath: k1]
            }
            if $0[keyPath: k2] != $1[keyPath: k2] {
                return $0[keyPath: k2] < $1[keyPath: k2]
            }
            return $0[keyPath: k3] < $1[keyPath: k3]
        }
    }
}
