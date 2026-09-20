import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UITab {
    /// 标题
    /// - Parameter title: 要设置的标题
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String) -> Self {
        base.title = title
        return self
    }

    /// 图标
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 副标题
    /// - Parameter subtitle: 要设置的副标题
    /// - Returns: `Self`
    @discardableResult
    func subtitle(_ subtitle: String?) -> Self {
        base.subtitle = subtitle
        return self
    }

    /// 角标
    /// - Parameter badgeValue: 角标文字,`nil` 表示隐藏
    /// - Returns: `Self`
    @discardableResult
    func badgeValue(_ badgeValue: String?) -> Self {
        base.badgeValue = badgeValue
        return self
    }

    /// 首选位置
    /// - Parameter preferredPlacement: 要设置的首选位置
    /// - Returns: `Self`
    @discardableResult
    func preferredPlacement(_ preferredPlacement: UITab.Placement) -> Self {
        base.preferredPlacement = preferredPlacement
        return self
    }

    /// 附加信息
    /// - Parameter userInfo: 要设置的附加信息
    /// - Returns: `Self`
    @discardableResult
    func userInfo(_ userInfo: Any?) -> Self {
        base.userInfo = userInfo
        return self
    }

    /// 是否隐藏
    /// - Parameter hidden: `true` 表示隐藏
    /// - Returns: `Self`
    @discardableResult
    func hidden(_ hidden: Bool) -> Self {
        base.isHidden = hidden
        return self
    }

    /// 默认是否隐藏
    /// - Parameter hiddenByDefault: 是否默认不出现在标签栏中(用户仍可添加)
    /// - Returns: `Self`
    @discardableResult
    func hiddenByDefault(_ hiddenByDefault: Bool) -> Self {
        base.isHiddenByDefault = hiddenByDefault
        return self
    }

    /// 是否允许隐藏
    /// - Parameter allowsHiding: `true` 表示允许隐藏
    /// - Returns: `Self`
    @discardableResult
    func allowsHiding(_ allowsHiding: Bool) -> Self {
        base.allowsHiding = allowsHiding
        return self
    }
}

// MARK: - iOS 18.4 / 26.1 新增属性

public extension FdyWrapper where Base: UITab {
    /// 标签是否可被选中
    ///
    /// - Parameter isEnabled: `false` 时呈禁用外观且不可选
    /// - Returns: `Self`
    @available(iOS 18.4, *)
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        base.isEnabled = isEnabled
        return self
    }

    /// 选中态图片
    ///
    /// - Parameter selectedImage: 选中时显示的图片,传 `nil` 用默认
    /// - Returns: `Self`
    @available(iOS 26.1, *)
    @discardableResult
    func selectedImage(_ selectedImage: UIImage?) -> Self {
        base.selectedImage = selectedImage
        return self
    }
}
