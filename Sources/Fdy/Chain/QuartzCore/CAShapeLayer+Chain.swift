import QuartzCore
import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: CAShapeLayer {
    /// 绘制路径
    /// - Parameter path: 要绘制的 `CGPath`(可由 `UIBezierPath` 转换而来)
    /// - Returns: `Self`
    @discardableResult
    func path(_ path: CGPath) -> Self {
        base.path = path
        return self
    }

    /// 图层内容缩放比例(适配 Retina 屏幕)
    /// - Parameter scale: 缩放因子,`nil` 时取当前屏幕 scale
    /// - Returns: `Self`
    /// - Important: 若不设置,高分辨率设备上路径可能模糊
    @MainActor
    @discardableResult
    func contentsScale(_ scale: CGFloat? = nil) -> Self {
        base.contentsScale = scale ?? FdyScreen.screenScale
        return self
    }

    /// 填充颜色(使用 `UIColor`)
    /// - Parameter color: 填充色;传 `nil` 可清除填充
    /// - Returns: `Self`
    @discardableResult
    func fillColor(_ color: UIColor?) -> Self {
        base.fillColor = color?.cgColor
        return self
    }

    /// 描边(笔触)颜色(使用 `UIColor`)
    /// - Parameter color: 描边色;传 `nil` 可清除描边
    /// - Returns: `Self`
    @discardableResult
    func strokeColor(_ color: UIColor?) -> Self {
        base.strokeColor = color?.cgColor
        return self
    }

    /// 线宽
    /// - Parameter width: 线宽(必须 ≥ 0,默认 `1.0`)
    /// - Returns: `Self`
    @discardableResult
    func lineWidth(_ width: CGFloat) -> Self {
        base.lineWidth = max(width, 0)
        return self
    }

    /// 最大斜接长度(用于尖角连接)
    /// - Parameter miterLimit: 斜接限制(必须 ≥ 0,默认 `10.0`)
    ///   当斜接长度超过此值时,会转为 `bevel` 连接
    /// - Returns: `Self`
    @discardableResult
    func miterLimit(_ miterLimit: CGFloat) -> Self {
        base.miterLimit = max(miterLimit, 0)
        return self
    }

    /// 线帽样式(路径端点外观)
    /// - Parameter lineCap: 线端样式
    /// - Returns: `Self`
    @discardableResult
    func lineCap(_ lineCap: CAShapeLayerLineCap) -> Self {
        base.lineCap = lineCap
        return self
    }

    /// 线条连接样式(路径拐角外观)
    /// - Parameter lineJoin: 拐角样式
    /// - Returns: `Self`
    @discardableResult
    func lineJoin(_ lineJoin: CAShapeLayerLineJoin) -> Self {
        base.lineJoin = lineJoin
        return self
    }

    /// 虚线模板(使用 `CGFloat` 数组,更符合 Swift 习惯)
    /// - Parameter pattern: 虚线模式,格式为 `[onLength, offLength, onLength, ...]`
    ///   例如：`[5, 3]` 表示 5pt 实线 + 3pt 空隙,循环重复
    /// - Returns: `Self`
    /// - Note: 数组长度应为偶数,且所有值 ≥ 0
    @discardableResult
    func lineDashPattern(_ pattern: [CGFloat]) -> Self {
        base.lineDashPattern = pattern.map { NSNumber(value: $0) }
        return self
    }

    /// 虚线相位(起始偏移)
    /// - Parameter phase: 虚线起始偏移量(单位：point)
    /// - Returns: `Self`
    @discardableResult
    func lineDashPhase(_ phase: CGFloat) -> Self {
        base.lineDashPhase = phase
        return self
    }

    /// 路径填充规则
    /// - Parameter fillRule: 要设置的路径填充规则
    /// - Returns: `Self`
    @discardableResult
    func fillRule(_ fillRule: CAShapeLayerFillRule) -> Self {
        base.fillRule = fillRule
        return self
    }

    /// 描边起始位置(用于绘制动画)
    /// - Parameter start: 起始比例,范围 `[0.0, 1.0]`(默认 `0.0`)
    ///   `0.0` = 路径起点,`1.0` = 路径终点
    /// - Returns: `Self`
    @discardableResult
    func strokeStart(_ start: CGFloat) -> Self {
        base.strokeStart = min(max(start, 0), 1)
        return self
    }

    /// 描边结束位置(用于绘制动画)
    /// - Parameter end: 结束比例,范围 `[0.0, 1.0]`(默认 `1.0`)
    /// - Returns: `Self`
    @discardableResult
    func strokeEnd(_ end: CGFloat) -> Self {
        base.strokeEnd = min(max(end, 0), 1)
        return self
    }

    /// 是否翻转几何坐标系(Y 轴方向)
    /// - Parameter isFlipped: `true` 时 Y 轴向下为正(UIKit 默认),`false` 向上为正(Quartz 默认)
    /// - Returns: `Self`
    /// - Note: 大多数情况下应保持 `true` 以匹配 UIKit
    @discardableResult
    func isGeometryFlipped(_ isFlipped: Bool) -> Self {
        base.isGeometryFlipped = isFlipped
        return self
    }
}
