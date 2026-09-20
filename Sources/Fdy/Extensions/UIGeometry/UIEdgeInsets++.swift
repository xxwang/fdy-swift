import UIKit

// MARK: - 构造方法
public extension UIEdgeInsets {
    /// 创建四个方向相等的 `UIEdgeInsets`
    ///
    /// - Parameter inset: 应用于 `top、left、bottom、right`的相同值
    init(fdy_inset inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    /// 创建一个 `UIEdgeInsets`,其左右边距之和为 `horizontalTotal`,
    /// 上下边距之和为 `verticalTotal`,并平均分配到两侧
    ///
    /// - Parameters:
    ///   - horizontalTotal: 水平方向的`总边距(left + right)`
    ///   - verticalTotal: 垂直方向的`总边距(top + bottom)`
    init(fdy_horizontalTotal horizontalTotal: CGFloat, verticalTotal: CGFloat) {
        self.init(
            top: verticalTotal / 2,
            left: horizontalTotal / 2,
            bottom: verticalTotal / 2,
            right: horizontalTotal / 2
        )
    }
}

// MARK: - 运算方法：支持加法与复合赋值
public extension UIEdgeInsets {
    /// 将两个 `UIEdgeInsets` 对应方向相加
    /// - Parameter other: 内边距
    /// - Returns: 内边距
    func fdy_adding(_ other: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(
            top: self.top + other.top,
            left: self.left + other.left,
            bottom: self.bottom + other.bottom,
            right: self.right + other.right
        )
    }

    /// 将右侧的 `UIEdgeInsets` 累加到左侧(就地修改)
    /// - Parameter other: 内边距
    mutating func fdy_add(_ other: UIEdgeInsets) {
        self = self.fdy_adding(other)
    }
}

// MARK: - 属性
public extension UIEdgeInsets {
    /// 水平方向的总边距(`left` + `right`)
    /// - Returns: 计算结果
    var fdy_horizontal: CGFloat {
        self.left + self.right
    }

    /// 垂直方向的总边距(`top` + `bottom`)
    /// - Returns: 计算结果
    var fdy_vertical: CGFloat {
        self.top + self.bottom
    }
}
