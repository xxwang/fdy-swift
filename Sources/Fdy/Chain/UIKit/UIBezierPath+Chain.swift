import UIKit

// MARK: - 链式绘制
public extension FdyWrapper where Base: UIBezierPath {
    // MARK: 构造路径

    /// 画一段经过三点的圆弧
    ///
    /// - Parameters:
    ///   - startPoint: 坐标点
    ///   - middlePoint: 坐标点
    ///   - endPoint: 坐标点
    ///   - clockwise: 是否顺时针
    /// - Returns: `Self`
    /// - Note: 即 `fdy_addArc(from:through:to:clockwise:)`。**三点共线时无法定圆,退化为直线**,
    ///   不会静默什么都不做。
    @discardableResult
    func addArc(
        from startPoint: CGPoint,
        through middlePoint: CGPoint,
        to endPoint: CGPoint,
        clockwise: Bool
    ) -> Self {
        base.fdy_addArc(from: startPoint, through: middlePoint, to: endPoint, clockwise: clockwise)
        return self
    }

    /// 以给定圆心画一段圆弧(半径由圆心与起点推出)
    ///
    /// - Parameters:
    ///   - center: 坐标点
    ///   - start: 坐标点
    ///   - end: 坐标点
    ///   - clockwise: 是否顺时针
    /// - Returns: `Self`
    /// - Note: 即 `fdy_addArc(withCenter:from:to:clockwise:)`。与系统
    ///   `addArc(withCenter:radius:startAngle:endAngle:clockwise:)` 的区别是**收起止点而非角度**。
    @discardableResult
    func addArc(
        withCenter center: CGPoint,
        from start: CGPoint,
        to end: CGPoint,
        clockwise: Bool
    ) -> Self {
        base.fdy_addArc(withCenter: center, from: start, to: end, clockwise: clockwise)
        return self
    }

    /// 以原点为基准加矩形
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - centered: 是否居中,默认为 `false`
    /// - Returns: `Self`
    /// - Note: `centered: true` 时矩形以**当前原点为中心**摆放,而非从原点向右下展开。
    @discardableResult
    func addRectangle(size: CGSize, centered: Bool = false) -> Self {
        base.fdy_addRectangle(size: size, centered: centered)
        return self
    }

    /// 以原点为基准加椭圆
    /// - Parameters:
    ///   - size: 尺寸
    ///   - centered: 是否居中,默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func addEllipse(size: CGSize, centered: Bool = false) -> Self {
        base.fdy_addEllipse(size: size, centered: centered)
        return self
    }

    /// 以原点为基准加圆
    /// - Parameters:
    ///   - radius: 半径
    ///   - centered: 是否居中,默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func addCircle(radius: CGFloat, centered: Bool = false) -> Self {
        base.fdy_addCircle(radius: radius, centered: centered)
        return self
    }

    /// 加一段三次贝塞尔曲线
    /// - Parameters:
    ///   - endPoint: 坐标点
    ///   - controlPoint1: 坐标点
    ///   - controlPoint2: 坐标点
    /// - Returns: `Self`
    @discardableResult
    func addCubicCurve(to endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) -> Self {
        base.fdy_addCubicCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        return self
    }

    /// 加一个箭头(线段 + 两撇)
    ///
    /// - Parameters:
    ///   - startPoint: 坐标点
    ///   - endPoint: 坐标点
    ///   - headSize: 箭头尺寸
    ///   - headAngle: 箭头夹角,默认为 `.pi / 6`
    /// - Returns: `Self`
    /// - Note: `headAngle` 是**半张角**,默认 30°(`.pi / 6`)。
    @discardableResult
    func addArrow(
        from startPoint: CGPoint,
        to endPoint: CGPoint,
        headSize: CGFloat,
        headAngle: CGFloat = .pi / 6
    ) -> Self {
        base.fdy_addArrow(from: startPoint, to: endPoint, headSize: headSize, headAngle: headAngle)
        return self
    }

    /// 加正多边形(顶点朝上,内接于圆)
    /// - Parameters:
    ///   - sides: 边数
    ///   - radius: 半径
    ///   - centered: 是否居中,默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func addRegularPolygon(sides: Int, radius: CGFloat, centered: Bool = false) -> Self {
        base.fdy_addRegularPolygon(sides: sides, radius: radius, centered: centered)
        return self
    }

    /// 用一串点连成闭合形状
    ///
    /// - Parameter points: 坐标点数组
    /// - Returns: `Self`
    /// - Note: 点数少于 3 时不构成面,调用方需自行保证。
    @discardableResult
    func addClosedShape(from points: [CGPoint]) -> Self {
        base.fdy_addClosedShape(from: points)
        return self
    }

    // MARK: 追加线段与状态

    /// 把当前点移到指定位置(不画线)
    /// - Parameter point: 坐标点
    /// - Returns: `Self`
    @discardableResult
    func move(to point: CGPoint) -> Self {
        base.move(to: point)
        return self
    }

    /// 从当前点画直线到指定点
    /// - Parameter point: 坐标点
    /// - Returns: `Self`
    @discardableResult
    func addLine(to point: CGPoint) -> Self {
        base.addLine(to: point)
        return self
    }

    /// 闭合子路径
    /// - Returns: `Self`
    @discardableResult
    func close() -> Self {
        base.close()
        return self
    }

    /// 清空所有子路径
    /// - Returns: `Self`
    @discardableResult
    func removeAllPoints() -> Self {
        base.removeAllPoints()
        return self
    }

    // MARK: 描边与填充样式

    /// 线宽
    /// - Parameter width: 宽度
    /// - Returns: `Self`
    @discardableResult
    func lineWidth(_ width: CGFloat) -> Self {
        base.lineWidth = width
        return self
    }

    // 描边 / 填充**颜色**不提供链式包装：iOS 的 `UIBezierPath` 没有 `strokeColor` / `fillColor`
    // （那是 AppKit `NSBezierPath` 的，别照 macOS 写法搬）；iOS 上颜色属于**图形上下文的全局状态**，
    // 链式方法会悄悄改全局绘制状态、副作用隐蔽 —— 需要时直接调 `UIColor.setStroke()` / `setFill()`。

    /// 线端头样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func lineCapStyle(_ style: CGLineCap) -> Self {
        base.lineCapStyle = style
        return self
    }

    /// 线拐角样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func lineJoinStyle(_ style: CGLineJoin) -> Self {
        base.lineJoinStyle = style
        return self
    }

    /// 尖角上限(仅 `lineJoinStyle == .miter` 时生效)
    /// - Parameter limit: 上限
    /// - Returns: `Self`
    @discardableResult
    func miterLimit(_ limit: CGFloat) -> Self {
        base.miterLimit = limit
        return self
    }

    /// 渲染精度(值越小越平滑、开销越大)
    /// - Parameter flatness: 平坦度
    /// - Returns: `Self`
    @discardableResult
    func flatness(_ flatness: CGFloat) -> Self {
        base.flatness = flatness
        return self
    }

    /// 是否用奇偶填充规则(默认非零环绕规则)
    /// - Parameter uses: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func usesEvenOddFillRule(_ uses: Bool) -> Self {
        base.usesEvenOddFillRule = uses
        return self
    }
}
