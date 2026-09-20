import CoreGraphics

// MARK: - 命名空间入口
extension CGVector: FdyExtension {}

// MARK: - 构造方法
public extension CGVector {
    /// 根据角度(弧度)和长度创建一个向量
    /// - Parameters:
    ///   - angle: 从正 X 轴逆时针旋转的角度(单位：弧度)
    ///   - magnitude: 向量的长度
    init(fdy_angle angle: CGFloat, magnitude: CGFloat) {
        self.init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }
}

// MARK: - 属性
public extension CGVector {
    /// 向量相对于正 X 轴的旋转角度(弧度),范围为 [-π, π]
    /// - Returns: 计算结果
    var fdy_angle: CGFloat {
        atan2(self.dy, self.dx)
    }

    /// 向量的长度(模长)
    /// - Returns: 计算结果
    var fdy_magnitude: CGFloat {
        sqrt(self.dx * self.dx + self.dy * self.dy)
    }

    /// 向量长度的平方(避免开方,用于高效比较)
    /// - Returns: 计算结果
    var fdy_magnitudeSquared: CGFloat {
        self.dx * self.dx + self.dy * self.dy
    }

    /// 返回单位向量(长度为 1 的方向向量)若原向量长度为 0,则返回 `.zero`
    /// - Returns: 向量
    var fdy_normalized: CGVector {
        let length = self.fdy_magnitude
        guard length > 0 else { return .zero }
        return self.fdy_divided(by: length)
    }
}

// MARK: - 向量运算
public extension CGVector {
    /// 计算与另一个向量的点积(Dot Product)
    /// 点积可用于判断夹角、投影等
    /// - Parameter other: 另一个向量
    /// - Returns: 两个向量的点积(标量)
    func fdy_dot(_ other: CGVector) -> CGFloat {
        self.dx * other.dx + self.dy * other.dy
    }
}

// MARK: - 运算方法
public extension CGVector {
    /// 加法
    /// - Parameter other: 向量
    /// - Returns: 向量
    func fdy_adding(_ other: CGVector) -> CGVector {
        CGVector(dx: self.dx + other.dx, dy: self.dy + other.dy)
    }

    /// 将另一个向量累加到自身(就地修改)
    /// - Parameter other: 向量
    mutating func fdy_add(_ other: CGVector) {
        self = self.fdy_adding(other)
    }

    /// 减法
    /// - Parameter other: 向量
    /// - Returns: 向量
    func fdy_subtracting(_ other: CGVector) -> CGVector {
        CGVector(dx: self.dx - other.dx, dy: self.dy - other.dy)
    }

    /// 将另一个向量从自身减去(就地修改)
    /// - Parameter other: 向量
    mutating func fdy_subtract(_ other: CGVector) {
        self = self.fdy_subtracting(other)
    }

    /// 标量乘法
    /// - Parameter scalar: 标量系数
    /// - Returns: 向量
    func fdy_scaled(by scalar: CGFloat) -> CGVector {
        CGVector(dx: self.dx * scalar, dy: self.dy * scalar)
    }

    /// 标量乘法(就地修改)
    /// - Parameter scalar: 标量系数
    mutating func fdy_scale(by scalar: CGFloat) {
        self = self.fdy_scaled(by: scalar)
    }

    /// 标量除法
    /// - Parameter scalar: 标量系数
    /// - Returns: 向量
    func fdy_divided(by scalar: CGFloat) -> CGVector {
        CGVector(dx: self.dx / scalar, dy: self.dy / scalar)
    }

    /// 标量除法(就地修改)
    /// - Parameter scalar: 标量系数
    mutating func fdy_divide(by scalar: CGFloat) {
        self = self.fdy_divided(by: scalar)
    }

    /// 取反(方向相反,长度不变)
    /// - Returns: 向量
    func fdy_negated() -> CGVector {
        CGVector(dx: -self.dx, dy: -self.dy)
    }
}
