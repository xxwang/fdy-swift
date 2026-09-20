import CoreGraphics

// MARK: - 命名空间入口
extension CGPoint: FdyExtension {}

// MARK: - 向量属性
public extension CGPoint {
    /// 向量长度(到原点的距离)
    /// - Returns: 计算结果
    var fdy_length: CGFloat {
        sqrt(self.x * self.x + self.y * self.y)
    }

    /// 向量长度的平方
    /// - Returns: 计算结果
    var fdy_lengthSquared: CGFloat {
        self.x * self.x + self.y * self.y
    }

    /// 单位向量(归一化)若长度为 0,返回 `.zero`
    /// - Returns: 坐标点
    var fdy_normalized: CGPoint {
        let len = self.fdy_length
        guard len > 0 else { return .zero }
        return self.fdy_divided(by: len)
    }

    /// 与另一个向量的点积(dot product)
    /// - Parameter other: 坐标点
    /// - Returns: 计算结果
    func fdy_dot(_ other: CGPoint) -> CGFloat {
        self.x * other.x + self.y * other.y
    }
}

// MARK: - 计算
public extension CGPoint {
    /// 计算到另一点的欧几里得距离
    /// - Parameter point: 目标点
    /// - Returns: 非负距离值
    func fdy_distance(to point: CGPoint) -> CGFloat {
        let dx = point.x - self.x
        let dy = point.y - self.y
        return sqrt(dx * dx + dy * dy)
    }

    /// 计算到另一点的距离平方(避免开方,用于高效比较)
    /// - Parameter point: 目标点
    /// - Returns: 距离的平方
    func fdy_distanceSquared(to point: CGPoint) -> CGFloat {
        let dx = point.x - self.x
        let dy = point.y - self.y
        return dx * dx + dy * dy
    }

    /// 返回当前点与另一点的中点
    /// - Parameter other: 坐标点
    /// - Returns: 坐标点
    func fdy_midpoint(to other: CGPoint) -> CGPoint {
        CGPoint(x: (self.x + other.x) / 2, y: (self.y + other.y) / 2)
    }
}

// MARK: - 运算方法
public extension CGPoint {
    /// 与另一个点逐分量相加
    /// - Parameter other: 坐标点
    /// - Returns: 坐标点
    func fdy_adding(_ other: CGPoint) -> CGPoint {
        CGPoint(x: self.x + other.x, y: self.y + other.y)
    }

    /// 将另一个点逐分量累加到自身
    /// - Parameter other: 坐标点
    mutating func fdy_add(_ other: CGPoint) {
        self = self.fdy_adding(other)
    }

    /// 与另一个点逐分量相减
    /// - Parameter other: 坐标点
    /// - Returns: 坐标点
    func fdy_subtracting(_ other: CGPoint) -> CGPoint {
        CGPoint(x: self.x - other.x, y: self.y - other.y)
    }

    /// 将另一个点逐分量从自身减去
    /// - Parameter other: 坐标点
    mutating func fdy_subtract(_ other: CGPoint) {
        self = self.fdy_subtracting(other)
    }

    /// 对两个分量同时乘以标量
    /// - Parameter scalar: 标量系数
    /// - Returns: 坐标点
    func fdy_scaled(by scalar: CGFloat) -> CGPoint {
        CGPoint(x: self.x * scalar, y: self.y * scalar)
    }

    /// 对两个分量同时乘以标量(就地修改)
    /// - Parameter scalar: 标量系数
    mutating func fdy_scale(by scalar: CGFloat) {
        self = self.fdy_scaled(by: scalar)
    }

    /// 对两个分量同时除以标量,标量为 0 时返回 `.zero`
    /// - Parameter scalar: 标量系数
    /// - Returns: 坐标点
    func fdy_divided(by scalar: CGFloat) -> CGPoint {
        guard scalar != 0 else { return .zero }
        return CGPoint(x: self.x / scalar, y: self.y / scalar)
    }

    /// 对两个分量同时除以标量(就地修改)
    /// - Parameter scalar: 标量系数
    mutating func fdy_divide(by scalar: CGFloat) {
        self = self.fdy_divided(by: scalar)
    }
}
