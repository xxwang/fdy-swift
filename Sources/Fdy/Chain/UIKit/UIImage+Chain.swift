import UIKit

// MARK: - 链式图像变换
public extension FdyWrapper where Base == UIImage {
    // MARK: 渲染模式

    /// 换成原样渲染模式(忽略 `tintColor`),返回新图
    ///
    /// - Returns: `Self`
    /// - Note: 即 `fdy_withOriginalRenderingMode`。模板图想恢复彩色时用。
    @discardableResult
    func originalRenderingMode() -> Self {
        base = base.fdy_withOriginalRenderingMode
        return self
    }

    /// 换成模板渲染模式(跟随 `tintColor` 上色),返回新图
    ///
    /// - Returns: `Self`
    /// - Note: 即 `fdy_withTemplateRenderingMode`。
    @discardableResult
    func templateRenderingMode() -> Self {
        base = base.fdy_withTemplateRenderingMode
        return self
    }

    /// 换成指定渲染模式,返回新图
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    @discardableResult
    func renderingMode(_ mode: UIImage.RenderingMode) -> Self {
        base = base.fdy_renderingMode(mode)
        return self
    }

    /// 套用 `UIImage.SymbolConfiguration`(SF Symbol 专用),返回新图
    /// - Parameter configuration: 配置
    /// - Returns: `Self`
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
    /// - Parameter rect: 矩形
    /// - Returns: `Self`
    /// - Note: **越界时保留原图**(对应 `fdy_crop(to:)` 返回 `nil` 的情形)。
    @discardableResult
    func crop(to rect: CGRect) -> Self {
        if let new = base.fdy_crop(to: rect) {
            base = new
        }
        return self
    }

    /// 等比压到不超过给定尺寸,返回新图
    /// - Parameter maxSize: 尺寸
    /// - Returns: `Self`
    @discardableResult
    func limit(to maxSize: CGSize) -> Self {
        base = base.fdy_limit(to: maxSize)
        return self
    }

    /// 从中心做九宫格拉伸(`capInsets` = 中心 1×1),返回新图
    /// - Returns: `Self`
    @discardableResult
    func resizableFromCenter() -> Self {
        base = base.fdy_makeResizableFromCenter()
        return self
    }

    /// 按指定 `insets` 与拉伸模式做九宫格,返回新图
    /// - Parameters:
    ///   - insets: 内边距
    ///   - mode: 模式,默认为 `.stretch`
    /// - Returns: `Self`
    @discardableResult
    func resizable(insets: UIEdgeInsets, mode: UIImage.ResizingMode = .stretch) -> Self {
        base = base.fdy_makeResizable(insets: insets, mode: mode)
        return self
    }

    /// 等比缩放填充到目标尺寸(可能超出后居中裁切),返回新图
    /// - Parameter size: 尺寸
    /// - Returns: `Self`
    @discardableResult
    func aspectFill(to size: CGSize) -> Self {
        base = base.fdy_scaleAspectFill(to: size)
        return self
    }

    /// 等比缩放适配到目标尺寸(完整显示、可能留白),返回新图
    /// - Parameter size: 尺寸
    /// - Returns: `Self`
    @discardableResult
    func aspectFit(to size: CGSize) -> Self {
        base = base.fdy_scaleAspectFit(to: size)
        return self
    }

    /// 缩放到指定宽度(高度等比),返回新图
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - opaque: 是否不透明,默认为 `false`
    /// - Returns: `Self`
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
    /// - Parameters:
    ///   - height: 高度
    ///   - opaque: 是否不透明,默认为 `false`
    /// - Returns: `Self`
    /// - Note: **失败时保留原图**。
    @discardableResult
    func scale(toHeight height: CGFloat, opaque: Bool = false) -> Self {
        if let new = base.fdy_scale(toHeight: height, opaque: opaque) {
            base = new
        }
        return self
    }

    /// 平铺成指定尺寸,返回新图
    /// - Parameter size: 尺寸
    /// - Returns: `Self`
    @discardableResult
    func tiled(to size: CGSize) -> Self {
        base = base.fdy_tiled(to: size)
        return self
    }

    // MARK: 几何变换

    /// 把方向信息烘焙进像素(`imageOrientation` 归一为 `.up`),返回新图
    ///
    /// - Returns: `Self`
    /// - Note: 相机照片画圆角/裁剪前建议先调它,否则方向元数据会在重绘时丢失。
    @discardableResult
    func fixedOrientation() -> Self {
        base = base.fdy_fixOrientation()
        return self
    }

    /// 顺时针旋转指定角度,返回新图
    ///
    /// - Parameter degrees: 角度(单位:度)
    /// - Returns: `Self`
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
    /// - Parameter radians: 弧度
    /// - Returns: `Self`
    /// - Note: **失败时保留原图**。
    @discardableResult
    func rotate(radians: CGFloat) -> Self {
        if let new = base.fdy_rotate(radians: radians) {
            base = new
        }
        return self
    }

    /// 水平镜像,返回新图
    /// - Returns: `Self`
    @discardableResult
    func flipHorizontal() -> Self {
        if let new = base.fdy_flipHorizontal() {
            base = new
        }
        return self
    }

    /// 垂直镜像,返回新图
    /// - Returns: `Self`
    @discardableResult
    func flipVertical() -> Self {
        if let new = base.fdy_flipVertical() {
            base = new
        }
        return self
    }

    /// 切圆角,返回新图
    ///
    /// - Parameter radius: 半径,默认为 `nil`
    /// - Returns: `Self`
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
    /// - Returns: `Self`
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
    /// - Parameters:
    ///   - color: 颜色
    ///   - renderingMode: 渲染模式,默认为 `.alwaysOriginal`
    /// - Returns: `Self`
    @discardableResult
    func tintColor(with color: UIColor, renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> Self {
        base = base.fdy_tintColor(with: color, renderingMode: renderingMode)
        return self
    }

    /// 按混合模式叠色,返回新图
    /// - Parameters:
    ///   - color: 颜色
    ///   - blendMode: 混合模式
    ///   - alpha: 不透明度,默认为 `1.0`
    /// - Returns: `Self`
    @discardableResult
    func tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> Self {
        base = base.fdy_tint(color, blendMode: blendMode, alpha: alpha)
        return self
    }

    /// 调图片整体透明度,返回新图
    /// - Parameter alpha: 不透明度
    /// - Returns: `Self`
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base = base.fdy_imageAlpha(alpha)
        return self
    }

    /// 用指定颜色填充非透明像素,返回新图
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func filled(with color: UIColor) -> Self {
        base = base.fdy_filled(with: color)
        return self
    }

    /// 垫上背景色,返回新图
    ///
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    /// - Note: 用于给带透明区的图补底色,避免叠在深色背景上发黑。
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        base = base.fdy_backgroundColor(color)
        return self
    }

    /// 去白底(转透明),返回新图
    ///
    /// - Returns: `Self`
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
    /// - Returns: `Self`
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
    /// - Parameter radius: 半径,默认为 `20`
    /// - Returns: `Self`
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
    /// - Parameter scale: 缩放比例,默认为 `20`
    /// - Returns: `Self`
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
    /// - Parameter filter: 滤镜
    /// - Returns: `Self`
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
