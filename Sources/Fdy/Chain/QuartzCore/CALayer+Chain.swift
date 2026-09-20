import QuartzCore
import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: CALayer {
    /// 图层的 frame(位置与尺寸)
    /// - Parameter frame: 新的 frame
    /// - Returns: `Self`
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        base.frame = frame
        return self
    }

    /// 背景颜色
    /// - Parameter color: 背景色;传 `nil` 可清除背景
    /// - Returns: `Self`
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        base.backgroundColor = color?.cgColor
        return self
    }

    /// 是否隐藏图层
    /// - Parameter isHidden: `true` 隐藏,`false` 显示
    /// - Returns: `Self`
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        base.isHidden = isHidden
        return self
    }

    /// 透明度(0.0 ～ 1.0)
    /// - Parameter opacity: 透明度值
    /// - Returns: `Self`
    @discardableResult
    func opacity(_ opacity: Float) -> Self {
        base.opacity = opacity
        return self
    }

    /// 边框宽度
    /// - Parameter width: 边框宽度(≥ 0)
    /// - Returns: `Self`
    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        base.borderWidth = max(width, 0)
        return self
    }

    /// 边框颜色
    /// - Parameter color: 边框颜色;传 `nil` 可清除边框
    /// - Returns: `Self`
    @discardableResult
    func borderColor(_ color: UIColor?) -> Self {
        base.borderColor = color?.cgColor
        return self
    }

    /// 是否裁剪子图层超出边界的内容
    /// - Parameter masksToBounds: `true` 裁剪,`false` 不裁剪
    /// - Returns: `Self`
    @discardableResult
    func masksToBounds(_ masksToBounds: Bool) -> Self {
        base.masksToBounds = masksToBounds
        return self
    }

    /// 统一圆角半径
    /// - Parameter cornerRadius: 圆角半径
    /// - Returns: `Self`
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        base.cornerRadius = max(cornerRadius, 0)
        return self
    }

    /// 要圆角化的角
    /// - Parameter maskedCorners: 要圆角的角
    /// - Returns: `Self`
    @discardableResult
    func maskedCorners(_ maskedCorners: CACornerMask) -> Self {
        base.maskedCorners = maskedCorners
        return self
    }

    /// 角的圆角
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 要圆角化的角(如 `.topLeft`, `.bottomRight` 等)
    /// - Returns: `Self`
    @discardableResult
    func roundedCorners(_ radius: CGFloat, corners: CACornerMask) -> Self {
        base.cornerRadius = max(radius, 0)
        base.maskedCorners = corners
        return self
    }

    /// 阴影颜色
    /// - Parameter color: 阴影颜色;传 `nil` 可清除阴影
    /// - Returns: `Self`
    @discardableResult
    func shadowColor(_ color: UIColor?) -> Self {
        base.shadowColor = color?.cgColor
        return self
    }

    /// 阴影透明度(0.0 ～ 1.0)
    /// - Parameter opacity: 阴影不透明度
    /// - Returns: `Self`
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        base.shadowOpacity = min(max(opacity, 0), 1)
        return self
    }

    /// 阴影偏移量
    /// - Parameter offset: 偏移(正 x 向右,正 y 向下)
    /// - Returns: `Self`
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        base.shadowOffset = offset
        return self
    }

    /// 阴影模糊半径
    /// - Parameter radius: 模糊半径(≥ 0)
    /// - Returns: `Self`
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        base.shadowRadius = max(radius, 0)
        return self
    }

    /// 阴影路径(提升性能,避免离屏渲染)
    /// - Parameter path: 自定义阴影轮廓路径
    /// - Returns: `Self`
    @discardableResult
    func shadowPath(_ path: CGPath) -> Self {
        base.shadowPath = path
        return self
    }

    /// 快速启用/禁用阴影(透明度设为 0.5 或 0)
    /// - Parameter hasShadow: 是否显示阴影
    /// - Returns: `Self`
    /// - Note: 此方法会覆盖 `shadowOpacity`,如需自定义透明度请直接使用 `shadowOpacity`
    @discardableResult
    func showShadow(_ hasShadow: Bool) -> Self {
        base.shadowOpacity = hasShadow ? 0.5 : 0
        return self
    }

    /// 启用或禁用光栅化(将图层预渲染为位图)
    /// - Parameter shouldRasterize: 是否启用光栅化
    /// - Returns: `Self`
    /// - Important: 启用后建议调用 `.fdy.rasterizationScale(FdyScreen.screenScale)` 以适配 Retina 屏幕
    @discardableResult
    func shouldRasterize(_ shouldRasterize: Bool) -> Self {
        base.shouldRasterize = shouldRasterize
        return self
    }

    /// 光栅化缩放比例(通常等于屏幕 scale)
    /// - Parameter scale: 缩放因子(如 `FdyScreen.screenScale`)
    /// - Returns: `Self`
    @discardableResult
    func rasterizationScale(_ scale: CGFloat) -> Self {
        base.rasterizationScale = max(scale, 1)
        return self
    }

    /// 将当前图层添加到指定 UIView 的 layer 中
    /// - Parameter view: 目标视图
    /// - Returns: `Self`
    @discardableResult
    func add2(_ view: UIView) -> Self {
        view.layer.addSublayer(base)
        return self
    }

    /// 将当前图层添加到指定 CALayer 中
    /// - Parameter layer: 目标图层
    /// - Returns: `Self`
    @discardableResult
    func add2(_ layer: CALayer) -> Self {
        layer.addSublayer(base)
        return self
    }

    /// 相对旋转图层(绕 Z 轴)
    /// - Parameter angle: 旋转角度(弧度)正值为顺时针
    /// - Returns: `Self`
    /// - Note: 此为`累积变换`如需绝对旋转,请重置 transform 后再设置
    @discardableResult
    func rotate(by angle: CGFloat) -> Self {
        base.transform = CATransform3DRotate(base.transform, angle, 0, 0, 1)
        return self
    }

    /// 相对缩放图层(等比缩放 X/Y 轴)
    /// - Parameter scale: 缩放因子(>1 放大,<1 缩小)
    /// - Returns: `Self`
    /// - Note: 此为`累积变换`
    @discardableResult
    func scale(by scale: CGFloat) -> Self {
        base.transform = CATransform3DScale(base.transform, scale, scale, 1)
        return self
    }

    /// 相对平移图层
    /// - Parameter translation: 平移向量(x: 水平, y: 垂直)
    /// - Returns: `Self`
    /// - Note: 此为`累积变换`
    @discardableResult
    func translate(by translation: CGPoint) -> Self {
        base.transform = CATransform3DTranslate(base.transform, translation.x, translation.y, 0)
        return self
    }

    /// 遮罩图层
    /// - Parameter mask: 用作遮罩的图层(仅 alpha 通道生效)
    /// - Returns: `Self`
    @discardableResult
    func mask(_ mask: CALayer) -> Self {
        base.mask = mask
        return self
    }

    /// z轴(深度)
    /// - Parameter zPosition: z轴
    /// - Returns: `Self`
    @discardableResult
    func zPosition(_ zPosition: CGFloat) -> Self {
        base.zPosition = zPosition
        return self
    }

    /// 图层边界(相对父图层坐标系的矩形)
    /// - Parameter bounds: 矩形
    /// - Returns: `Self`
    @discardableResult
    func bounds(_ bounds: CGRect) -> Self {
        base.bounds = bounds
        return self
    }

    /// 图层在父图层坐标系中的位置(锚点所在处)
    /// - Parameter position: 坐标点
    /// - Returns: `Self`
    @discardableResult
    func position(_ position: CGPoint) -> Self {
        base.position = position
        return self
    }

    /// 锚点(以 `bounds` 为单位,默认 `(0.5, 0.5)`)
    /// - Parameter anchorPoint: 坐标点
    /// - Returns: `Self`
    @discardableResult
    func anchorPoint(_ anchorPoint: CGPoint) -> Self {
        base.anchorPoint = anchorPoint
        return self
    }

    /// 锚点的 Z 轴分量
    /// - Parameter anchorPointZ: 要设置的锚点的 Z 轴分量
    /// - Returns: `Self`
    @discardableResult
    func anchorPointZ(_ anchorPointZ: CGFloat) -> Self {
        base.anchorPointZ = anchorPointZ
        return self
    }

    /// 图层的 3D 变换
    /// - Parameter transform: 3D 变换矩阵
    /// - Returns: `Self`
    @discardableResult
    func transform(_ transform: CATransform3D) -> Self {
        base.transform = transform
        return self
    }

    /// 子图层变换(只影响子图层,不影响自身)
    /// - Parameter sublayerTransform: 3D 变换矩阵
    /// - Returns: `Self`
    @discardableResult
    func sublayerTransform(_ sublayerTransform: CATransform3D) -> Self {
        base.sublayerTransform = sublayerTransform
        return self
    }

    /// 子图层数组
    /// - Parameter sublayers: 子图层数组,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func sublayers(_ sublayers: [CALayer]?) -> Self {
        base.sublayers = sublayers
        return self
    }

    /// 是否双面绘制
    /// - Parameter isDoubleSided: `true` 表示双面绘制
    /// - Returns: `Self`
    @discardableResult
    func isDoubleSided(_ isDoubleSided: Bool) -> Self {
        base.isDoubleSided = isDoubleSided
        return self
    }

    /// 是否沿 Y 轴翻转几何
    /// - Parameter isGeometryFlipped: 是否翻转几何坐标
    /// - Returns: `Self`
    @discardableResult
    func isGeometryFlipped(_ isGeometryFlipped: Bool) -> Self {
        base.isGeometryFlipped = isGeometryFlipped
        return self
    }

    /// 是否不透明(提升合成性能)
    /// - Parameter isOpaque: 是否不透明
    /// - Returns: `Self`
    @discardableResult
    func isOpaque(_ isOpaque: Bool) -> Self {
        base.isOpaque = isOpaque
        return self
    }

    /// 图层内容(通常是 `CGImage`)
    /// - Parameter contents: 内容,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func contents(_ contents: Any?) -> Self {
        base.contents = contents
        return self
    }

    /// 内容在图层中的绘制矩形(单位化坐标)
    /// - Parameter contentsRect: 单位化矩形
    /// - Returns: `Self`
    @discardableResult
    func contentsRect(_ contentsRect: CGRect) -> Self {
        base.contentsRect = contentsRect
        return self
    }

    /// 内容的重力/对齐方式
    /// - Parameter contentsGravity: 要设置的内容的重力/对齐方式
    /// - Returns: `Self`
    @discardableResult
    func contentsGravity(_ contentsGravity: CALayerContentsGravity) -> Self {
        base.contentsGravity = contentsGravity
        return self
    }

    /// 内容的中心区域(九宫格拉伸用)
    /// - Parameter contentsCenter: 单位化矩形
    /// - Returns: `Self`
    @discardableResult
    func contentsCenter(_ contentsCenter: CGRect) -> Self {
        base.contentsCenter = contentsCenter
        return self
    }

    /// 缩小时的过滤方式
    /// - Parameter minificationFilter: 要设置的缩小时的过滤方式
    /// - Returns: `Self`
    @discardableResult
    func minificationFilter(_ minificationFilter: CALayerContentsFilter) -> Self {
        base.minificationFilter = minificationFilter
        return self
    }

    /// 放大时的过滤方式
    /// - Parameter magnificationFilter: 要设置的放大时的过滤方式
    /// - Returns: `Self`
    @discardableResult
    func magnificationFilter(_ magnificationFilter: CALayerContentsFilter) -> Self {
        base.magnificationFilter = magnificationFilter
        return self
    }

    /// 缩小时的过滤偏差
    /// - Parameter minificationFilterBias: 要设置的缩小时的过滤偏差
    /// - Returns: `Self`
    @discardableResult
    func minificationFilterBias(_ minificationFilterBias: Float) -> Self {
        base.minificationFilterBias = minificationFilterBias
        return self
    }

    /// 边界变化时是否重绘
    /// - Parameter needsDisplayOnBoundsChange: 要设置的边界变化时是否重绘
    /// - Returns: `Self`
    @discardableResult
    func needsDisplayOnBoundsChange(_ needsDisplayOnBoundsChange: Bool) -> Self {
        base.needsDisplayOnBoundsChange = needsDisplayOnBoundsChange
        return self
    }

    /// 边缘抗锯齿掩码
    /// - Parameter edgeAntialiasingMask: 要设置的边缘抗锯齿掩码
    /// - Returns: `Self`
    @discardableResult
    func edgeAntialiasingMask(_ edgeAntialiasingMask: CAEdgeAntialiasingMask) -> Self {
        base.edgeAntialiasingMask = edgeAntialiasingMask
        return self
    }

    /// 合成滤镜
    /// - Parameter compositingFilter: 滤镜,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func compositingFilter(_ compositingFilter: Any?) -> Self {
        base.compositingFilter = compositingFilter
        return self
    }

    /// 内容滤镜数组
    /// - Parameter filters: 滤镜数组,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func filters(_ filters: [Any]?) -> Self {
        base.filters = filters
        return self
    }

    /// 背景滤镜数组
    /// - Parameter backgroundFilters: 滤镜数组,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func backgroundFilters(_ backgroundFilters: [Any]?) -> Self {
        base.backgroundFilters = backgroundFilters
        return self
    }

    /// 事件到动作的映射表
    /// - Parameter actions: 映射表,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func actions(_ actions: [String: any CAAction]?) -> Self {
        base.actions = actions
        return self
    }

    /// 图层名称(便于调试定位)
    /// - Parameter name: 名称,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func name(_ name: String?) -> Self {
        base.name = name
        return self
    }

    /// 图层代理
    /// - Parameter delegate: 遵循 `CALayerDelegate` 的对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: CALayerDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 样式字典
    /// - Parameter style: 样式字典,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func style(_ style: [AnyHashable: Any]?) -> Self {
        base.style = style
        return self
    }
}
