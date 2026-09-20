import CoreGraphics
import UIKit

// MARK: - 命名空间入口
extension CGSize: FdyExtension {}

// MARK: - 属性
public extension CGSize {
    /// 宽高比(width / height)
    /// - Returns: 计算结果
    var fdy_aspectRatio: CGFloat {
        guard self.height != 0 else { return 0 }
        return self.width / self.height
    }

    /// 较长的一边(max(width, height))
    /// - Returns: 计算结果
    var fdy_longestSide: CGFloat {
        max(self.width, self.height)
    }

    /// 较短的一边(min(width, height))
    /// - Returns: 计算结果
    var fdy_shortestSide: CGFloat {
        min(self.width, self.height)
    }
}

// MARK: - 方法
public extension CGSize {
    /// 对宽高进行四舍五入
    /// - Returns: 尺寸
    func fdy_rounded() -> CGSize {
        CGSize(width: Darwin.round(self.width), height: Darwin.round(self.height))
    }

    /// 将尺寸限制在最大尺寸内
    /// - Parameter maxSize: 尺寸
    /// - Returns: 尺寸
    func fdy_clamped(to maxSize: CGSize) -> CGSize {
        CGSize(
            width: min(self.width, maxSize.width),
            height: min(self.height, maxSize.height)
        )
    }
}

// MARK: - 缩放
public extension CGSize {
    /// 按宽高比缩放,使内容`完全适配`目标区域(不超出)
    /// - Parameter targetSize: 尺寸
    /// - Returns: 尺寸
    func fdy_aspectFit(to targetSize: CGSize) -> CGSize {
        guard self.width > 0, self.height > 0, targetSize.width > 0, targetSize.height > 0 else {
            return .zero
        }
        let scale = min(targetSize.width / self.width, targetSize.height / self.height)
        return CGSize(width: self.width * scale, height: self.height * scale)
    }

    /// 按宽高比缩放,使内容`完全覆盖`目标区域(可能超出)
    /// - Parameter targetSize: 尺寸
    /// - Returns: 尺寸
    func fdy_aspectFill(to targetSize: CGSize) -> CGSize {
        guard self.width > 0, self.height > 0 else { return .zero }
        let scale = max(targetSize.width / self.width, targetSize.height / self.height)
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
}

// MARK: - 运算方法
public extension CGSize {
    /// 与另一个尺寸逐分量相加
    /// - Parameter other: 尺寸
    /// - Returns: 尺寸
    func fdy_adding(_ other: CGSize) -> CGSize {
        CGSize(width: self.width + other.width, height: self.height + other.height)
    }

    /// 将另一个尺寸逐分量累加到自身
    /// - Parameter other: 尺寸
    mutating func fdy_add(_ other: CGSize) {
        self = self.fdy_adding(other)
    }

    /// 与另一个尺寸逐分量相减
    /// - Parameter other: 尺寸
    /// - Returns: 尺寸
    func fdy_subtracting(_ other: CGSize) -> CGSize {
        CGSize(width: self.width - other.width, height: self.height - other.height)
    }

    /// 将另一个尺寸逐分量从自身减去
    /// - Parameter other: 尺寸
    mutating func fdy_subtract(_ other: CGSize) {
        self = self.fdy_subtracting(other)
    }

    /// 与另一个尺寸逐分量相乘
    /// - Parameter other: 尺寸
    /// - Returns: 尺寸
    func fdy_multiplied(by other: CGSize) -> CGSize {
        CGSize(width: self.width * other.width, height: self.height * other.height)
    }

    /// 与另一个尺寸逐分量相乘(就地修改)
    /// - Parameter other: 尺寸
    mutating func fdy_multiply(by other: CGSize) {
        self = self.fdy_multiplied(by: other)
    }

    /// 对宽高同时乘以标量
    /// - Parameter scalar: 标量系数
    /// - Returns: 尺寸
    func fdy_scaled(by scalar: CGFloat) -> CGSize {
        CGSize(width: self.width * scalar, height: self.height * scalar)
    }

    /// 对宽高同时乘以标量(就地修改)
    /// - Parameter scalar: 标量系数
    mutating func fdy_scale(by scalar: CGFloat) {
        self = self.fdy_scaled(by: scalar)
    }

    /// 对宽高同时除以标量,标量为 0 时返回 `.zero`
    /// - Parameter scalar: 标量系数
    /// - Returns: 尺寸
    func fdy_divided(by scalar: CGFloat) -> CGSize {
        guard scalar != 0 else { return .zero }
        return CGSize(width: self.width / scalar, height: self.height / scalar)
    }

    /// 对宽高同时除以标量(就地修改)
    /// - Parameter scalar: 标量系数
    mutating func fdy_divide(by scalar: CGFloat) {
        self = self.fdy_divided(by: scalar)
    }

    /// 与另一个尺寸逐分量相除,任一除数为 0 时返回 `.zero`
    /// - Parameter other: 尺寸
    /// - Returns: 尺寸
    func fdy_divided(by other: CGSize) -> CGSize {
        guard other.width != 0, other.height != 0 else { return .zero }
        return CGSize(width: self.width / other.width, height: self.height / other.height)
    }
}
