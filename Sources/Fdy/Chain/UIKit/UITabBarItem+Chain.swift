import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UITabBarItem {
    /// 标题
    /// - Parameter title: 标题文本
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        base.title = title
        return self
    }

    /// 按钮标题的文本属性
    /// - Parameters:
    ///   - attributes: 文本属性字典,如字体、颜色等
    ///   - state: 控件状态,如 `.normal`、`.highlighted` 等
    /// - Returns: `Self`
    @discardableResult
    func titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        base.setTitleTextAttributes(attributes, for: state)
        return self
    }

    /// 默认图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        if let img = image {
            base.image = img.withRenderingMode(.alwaysOriginal)
        } else {
            base.image = nil
        }
        return self
    }

    /// 选中图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func selectedImage(_ image: UIImage?) -> Self {
        if let img = image {
            base.selectedImage = img.withRenderingMode(.alwaysOriginal)
        } else {
            base.selectedImage = nil
        }
        return self
    }

    /// 图片的内边距
    /// - Parameter imageInsets: 图片的内边距
    /// - Returns: `Self`
    @discardableResult
    func imageInsets(_ imageInsets: UIEdgeInsets) -> Self {
        base.imageInsets = imageInsets
        return self
    }

    /// 标题的位置调整
    /// - Parameter titleOffset: 标题相对于默认位置的偏移量
    /// - Returns: `Self`
    @discardableResult
    func titlePositionAdjustment(_ titleOffset: UIOffset) -> Self {
        base.titlePositionAdjustment = titleOffset
        return self
    }

    ///  `badgeColor` 颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func badgeColor(_ color: UIColor?) -> Self {
        base.badgeColor = color
        return self
    }

    ///  `badgeValue` 值
    /// - Parameter value: 值
    /// - Returns: `Self`
    @discardableResult
    func badgeValue(_ value: String?) -> Self {
        base.badgeValue = value
        return self
    }
}

// MARK: - 链式方法
public extension FdyWrapper where Base: UITabBarItem {
    /// `Badge`文本属性
    /// - Parameters:
    ///   - textAttributes: 文本属性字典(如字体、颜色等)
    ///   - state: 控制状态(如 `.normal` 或 `.selected`)
    /// - Returns: `Self`
    @discardableResult
    func badgeTextAttributes(_ textAttributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        base.setBadgeTextAttributes(textAttributes, for: state)
        return self
    }

    /// 图标的渲染模式
    /// - Parameter renderingMode: 渲染模式(默认使用 `.alwaysOriginal`)
    /// - Returns: `Self`
    @discardableResult
    func imageRenderingMode(_ renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> Self {
        if let image = base.image {
            base.image = image.withRenderingMode(renderingMode)
        }
        if let selectedImage = base.selectedImage {
            base.selectedImage = selectedImage.withRenderingMode(renderingMode)
        }
        return self
    }

    /// 该标签项的默认外观(`standardAppearance`)
    /// - Parameter appearance: 目标外观,传 `nil` 回退到标签栏的设置
    /// - Returns: `Self`
    @discardableResult
    func standardAppearance(_ appearance: UITabBarAppearance?) -> Self {
        base.standardAppearance = appearance
        return self
    }

    /// 该标签项滚动到边缘时的外观(`scrollEdgeAppearance`)
    /// - Parameter appearance: 目标外观,传 `nil` 回退到标签栏的设置
    /// - Returns: `Self`
    @discardableResult
    func scrollEdgeAppearance(_ appearance: UITabBarAppearance?) -> Self {
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 大内容尺寸下使用的图片(辅助功能)
    /// - Parameter image: 图片,传 `nil` 用系统默认
    /// - Returns: `Self`
    @discardableResult
    func largeContentSizeImage(_ image: UIImage?) -> Self {
        base.largeContentSizeImage = image
        return self
    }
}
