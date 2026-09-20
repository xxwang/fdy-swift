import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIImageView {
    /// 图像的`tintColor`(自动将图像转为模板模式)
    /// - Parameter color: 主色调
    /// - Returns: `Self`
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        if let image = base.image {
            base.image = image.withRenderingMode(.alwaysTemplate)
        }
        base.tintColor = color
        return self
    }

    /// 普通图片
    /// - Parameter image: 要设置的图片
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 高亮状态图片
    /// - Parameter image: 要设置的高亮图片
    /// - Returns: `Self`
    @discardableResult
    func highlightedImage(_ image: UIImage?) -> Self {
        base.highlightedImage = image
        return self
    }

    /// 高亮状态
    /// - Parameter highlighted: 是否高亮
    /// - Returns: `Self`
    @discardableResult
    func isHighlighted(_ highlighted: Bool) -> Self {
        base.isHighlighted = highlighted
        return self
    }

    /// 帧动画图片数组
    /// - Parameter images: 图片数组
    /// - Returns: `Self`
    @discardableResult
    func animationImages(_ images: [UIImage]?) -> Self {
        base.animationImages = images
        return self
    }

    /// 高亮状态帧动画图片数组
    /// - Parameter images: 图片数组
    /// - Returns: `Self`
    @discardableResult
    func highlightedAnimationImages(_ images: [UIImage]?) -> Self {
        base.highlightedAnimationImages = images
        return self
    }

    /// 帧动画时长
    /// - Parameter duration: 动画时长(秒)
    /// - Returns: `Self`
    @discardableResult
    func animationDuration(_ duration: TimeInterval) -> Self {
        base.animationDuration = duration
        return self
    }

    /// 帧动画重复次数
    /// - Parameter count: 重复次数,0 表示无限循环
    /// - Returns: `Self`
    @discardableResult
    func animationRepeatCount(_ count: Int) -> Self {
        base.animationRepeatCount = count
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension FdyWrapper where Base: UIImageView {
    /// 添加模糊背景(会替换本库上一次添加的模糊视图,不影响使用者自行添加的模糊视图)
    /// - Parameter style: 模糊样式
    /// - Returns: `Self`
    @discardableResult
    func blur(_ style: UIBlurEffect.Style = .light) -> Self {
        removeBlur()

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurView.frame = base.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.tag = FdyImageViewBlurViewTag
        base.addSubview(blurView)
        return self
    }

    /// 移除 `blur(_:)` 添加的模糊效果
    /// - Returns: `Self`
    @discardableResult
    func removeBlur() -> Self {
        for subview in base.subviews where subview.tag == FdyImageViewBlurViewTag {
            subview.removeFromSuperview()
        }
        return self
    }

    /// 首选符号配置(用于 SF Symbols)
    /// - Parameter preferredSymbolConfiguration: 符号配置,传 `nil` 用系统默认
    /// - Returns: `Self`
    @discardableResult
    func preferredSymbolConfiguration(
        _ preferredSymbolConfiguration: UIImage.SymbolConfiguration?
    ) -> Self {
        base.preferredSymbolConfiguration = preferredSymbolConfiguration
        return self
    }

    /// 首选的图像动态范围
    /// - Parameter preferredImageDynamicRange: 动态范围
    /// - Returns: `Self`
    @discardableResult
    func preferredImageDynamicRange(_ preferredImageDynamicRange: UIImage.DynamicRange) -> Self {
        base.preferredImageDynamicRange = preferredImageDynamicRange
        return self
    }
}

/// `blur(_:)` 自建模糊视图的 `tag`,用于 `removeBlur()` 精确移除
private let FdyImageViewBlurViewTag = 889971
