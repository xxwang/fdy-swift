import UIKit

// MARK: - 链式图像变换
//
// `UIImage` 不可变,链式一律**替换 `base`**,原始图像不受影响。所有方法只**转发**到已有的
// `fdy_*` 实现,不重复造轮子 —— 语义要改只改一处。
//
// **失败语义**:不少变换会返回 `UIImage?`(裁剪越界、滤镜不可用、白底不纯等)。链式版一律
// **保留原图并继续**,不中断成 `nil` —— 链到一半炸掉比拿到一张没变换的图更难排查。
// 需要知道"到底改没改成"时,请直接调对应的 `fdy_*` 方法拿 `Optional`。
//
// 因此这些链式方法**不保证生效**:返回值永远非 `nil`,但内容可能与入参相同。
public extension FdyWrapper where Base == UIImage {
    // MARK: 渲染模式

    /// 换成原样渲染模式(忽略 `tintColor`),返回新图
    ///
    /// - Note: 即 `fdy_withOriginalRenderingMode`。模板图想恢复彩色时用。
    @discardableResult
    func originalRenderingMode() -> Self {
        base = base.fdy_withOriginalRenderingMode
        return self
    }

    /// 换成模板渲染模式(跟随 `tintColor` 上色),返回新图
    ///
    /// - Note: 即 `fdy_withTemplateRenderingMode`。
    @discardableResult
    func templateRenderingMode() -> Self {
        base = base.fdy_withTemplateRenderingMode
        return self
    }

    /// 换成指定渲染模式,返回新图
    @discardableResult
    func renderingMode(_ mode: UIImage.RenderingMode) -> Self {
        base = base.fdy_renderingMode(mode)
        return self
    }

    /// 套用 `UIImage.SymbolConfiguration`(SF Symbol 专用),返回新图
    @discardableResult
    func symbolConfiguration(_ configuration: UIImage.SymbolConfiguration) -> Self {
        if let new = base.fdy_symbolConfiguration(configuration) {
            base = new
        }
        return self
    }

    // MARK: 尺寸与缩放

    /// 按矩形裁剪,返回新图
    ///
    /// - Note: **越界时保留原图**(对应 `fdy_crop(to:)` 返回 `nil` 的情形)。
    @discardableResult
    func crop(to rect: CGRect) -> Self {
        if let new = base.fdy_crop(to: rect) {
            base = new
        }
        return self
    }

    /// 等比压到不超过给定尺寸,返回新图
    @discardableResult
    func limit(to maxSize: CGSize) -> Self {
        base = base.fdy_limit(to: maxSize)
        return self
    }

    /// 从中心做九宫格拉伸(`capInsets` = 中心 1×1),返回新图
    @discardableResult
    func resizableFromCenter() -> Self {
        base = base.fdy_makeResizableFromCenter()
        return self
    }

    /// 按指定 `insets` 与拉伸模式做九宫格,返回新图
    @discardableResult
    func resizable(insets: UIEdgeInsets, mode: UIImage.ResizingMode = .stretch) -> Self {
        base = base.fdy_makeResizable(insets: insets, mode: mode)
        return self
    }

    /// 等比缩放填充到目标尺寸(可能超出后居中裁切),返回新图
    @discardableResult
    func aspectFill(to size: CGSize) -> Self {
        base = base.fdy_scaleAspectFill(to: size)
        return self
    }

    /// 等比缩放适配到目标尺寸(完整显示、可能留白),返回新图
    @discardableResult
    func aspectFit(to size: CGSize) -> Self {
        base = base.fdy_scaleAspectFit(to: size)
        return self
    }

    /// 缩放到指定宽度(高度等比),返回新图
    ///
    /// - Note: **失败时保留原图**。
    @discardableResult
    func scale(toWidth width: CGFloat, opaque: Bool = false) -> Self {
        if let new = base.fdy_scale(toWidth: width, opaque: opaque) {
            base = new
        }
        return self
    }

    /// 缩放到指定高度(宽度等比),返回新图
    ///
    /// - Note: **失败时保留原图**。
    @discardableResult
    func scale(toHeight height: CGFloat, opaque: Bool = false) -> Self {
        if let new = base.fdy_scale(toHeight: height, opaque: opaque) {
            base = new
        }
        return self
    }

    /// 平铺成指定尺寸,返回新图
    @discardableResult
    func tiled(to size: CGSize) -> Self {
        base = base.fdy_tiled(to: size)
        return self
    }

    // MARK: 几何变换

    /// 把方向信息烘焙进像素(`imageOrientation` 归一为 `.up`),返回新图
    ///
    /// - Note: 相机照片画圆角/裁剪前建议先调它,否则方向元数据会在重绘时丢失。
    @discardableResult
    func fixedOrientation() -> Self {
        base = base.fdy_fixOrientation()
        return self
    }

    /// 顺时针旋转指定角度,返回新图
    ///
    /// - Note: **失败时保留原图**。
    @discardableResult
    func rotate(degrees: CGFloat) -> Self {
        if let new = base.fdy_rotate(degrees: degrees) {
            base = new
        }
        return self
    }

    /// 顺时针旋转指定弧度,返回新图
    ///
    /// - Note: **失败时保留原图**。
    @discardableResult
    func rotate(radians: CGFloat) -> Self {
        if let new = base.fdy_rotate(radians: radians) {
            base = new
        }
        return self
    }

    /// 水平镜像,返回新图
    @discardableResult
    func flipHorizontal() -> Self {
        if let new = base.fdy_flipHorizontal() {
            base = new
        }
        return self
    }

    /// 垂直镜像,返回新图
    @discardableResult
    func flipVertical() -> Self {
        if let new = base.fdy_flipVertical() {
            base = new
        }
        return self
    }

    /// 切圆角,返回新图
    ///
    /// - Note: `radius` 传 `nil` 取短边一半(即近圆形);**失败时保留原图**。
    @discardableResult
    func roundedCorner(radius: CGFloat? = nil) -> Self {
        if let new = base.fdy_roundedCorner(radius: radius) {
            base = new
        }
        return self
    }

    /// 裁成圆形,返回新图
    ///
    /// - Note: **失败时保留原图**。
    @discardableResult
    func circular() -> Self {
        if let new = base.fdy_circularImage() {
            base = new
        }
        return self
    }

    // MARK: 颜色

    /// 用指定颜色与渲染模式重新上色,返回新图
    @discardableResult
    func tintColor(with color: UIColor, renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> Self {
        base = base.fdy_tintColor(with: color, renderingMode: renderingMode)
        return self
    }

    /// 按混合模式叠色,返回新图
    @discardableResult
    func tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> Self {
        base = base.fdy_tint(color, blendMode: blendMode, alpha: alpha)
        return self
    }

    /// 调图片整体透明度,返回新图
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base = base.fdy_imageAlpha(alpha)
        return self
    }

    /// 用指定颜色填充非透明像素,返回新图
    @discardableResult
    func filled(with color: UIColor) -> Self {
        base = base.fdy_filled(with: color)
        return self
    }

    /// 垫上背景色,返回新图
    ///
    /// - Note: 用于给带透明区的图补底色,避免叠在深色背景上发黑。
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        base = base.fdy_backgroundColor(color)
        return self
    }

    /// 去白底(转透明),返回新图
    ///
    /// - Note: 只对**纯白**背景有效,带渐变或压缩噪点的背景去不干净;**失败时保留原图**。
    @discardableResult
    func removingWhiteBackground() -> Self {
        if let new = base.fdy_removeWhiteBackground() {
            base = new
        }
        return self
    }

    /// 去黑底(转透明),返回新图
    ///
    /// - Note: 只对**纯黑**背景有效;**失败时保留原图**。
    @discardableResult
    func removingBlackBackground() -> Self {
        if let new = base.fdy_removeBlackBackground() {
            base = new
        }
        return self
    }

    // MARK: 滤镜

    /// 高斯模糊,返回新图
    ///
    /// - Note: **失败时保留原图**。
    @discardableResult
    func blurred(radius: CGFloat = 20) -> Self {
        if let new = base.fdy_gaussianBlur(radius: radius) {
            base = new
        }
        return self
    }

    /// 马赛克,返回新图
    ///
    /// - Note: **失败时保留原图**。
    @discardableResult
    func pixelated(scale: CGFloat = 20) -> Self {
        if let new = base.fdy_pixelation(scale: scale) {
            base = new
        }
        return self
    }

    /// 套用内置照片滤镜,返回新图
    ///
    /// - Note: 即 `fdy_filter(_:)`。滤镜类型 `UIImage.FdyPhotoFilter` 嵌套在 `UIImage` 里,故写全名。
    ///   **失败时保留原图**。
    @discardableResult
    func filtered(_ filter: UIImage.FdyPhotoFilter) -> Self {
        if let new = base.fdy_filter(filter) {
            base = new
        }
        return self
    }
}
