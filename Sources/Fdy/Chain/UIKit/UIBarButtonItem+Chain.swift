import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIBarButtonItem {
    /// 按钮的显示样式(如 `.plain`、`.done` 等)
    /// - Parameter style: 指定按钮的视觉样式
    /// - Returns: `Self`
    @discardableResult
    func style(_ style: UIBarButtonItem.Style) -> Self {
        base.style = style
        return self
    }

    /// 按钮是否可交互(启用/禁用状态)
    ///
    /// - Parameter isEnabled: `true` 表示启用,`false` 表示禁用
    /// - Returns: `Self`
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        base.isEnabled = isEnabled
        return self
    }

    /// 自定义视图(如 `UILabel`、`UIButton` 等)作为按钮内容
    /// - Parameter customView: 要作为按钮内容的自定义视图
    /// - Returns: `Self`
    @discardableResult
    func customView(_ customView: UIView?) -> Self {
        base.customView = customView
        return self
    }

    /// 按钮的文本标题
    ///
    /// - Parameter title: 要显示的字符串标题,可为 `nil` 以移除标题
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        base.title = title
        return self
    }

    /// 按钮的图标图像
    ///
    /// - Parameter image: 要显示的图像,可为 `nil` 以移除图像
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 按钮在指定状态下的背景图像(适用于系统样式的按钮)
    ///
    /// - Parameters:
    ///   - backgroundImage: 背景图像,可为 `nil` 以清除
    ///   - state: 控件状态(如 `.normal`, `.highlighted`)
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State) -> Self {
        base.setBackgroundImage(backgroundImage, for: state, barMetrics: .default)
        return self
    }

    /// 按钮的宽度(仅在非自定义视图模式下有效)
    ///
    /// - Parameter width: 按钮的固定宽度(单位：点)
    /// - Returns: `Self`
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        base.width = width
        return self
    }

    /// 按钮点击事件的目标对象(通常为 ViewController 或其他响应者)
    ///
    /// - Parameter target: 接收点击事件的对象,可为 `nil`
    /// - Returns: `Self`
    @discardableResult
    func target(_ target: AnyObject?) -> Self {
        base.target = target
        return self
    }

    /// 按钮点击事件的响应方法(`Selector`)
    ///
    /// - Parameter action: 方法选择器(如 `#selector(doSomething)`),可为 `nil`
    /// - Returns: `Self`
    @discardableResult
    func action(_ action: Selector?) -> Self {
        base.action = action
        return self
    }

    /// 同时设置目标对象和响应方法(常用快捷方式)
    ///
    /// - Parameters:
    ///   - target: 事件接收者
    ///   - action: 对应的 `Selector`
    /// - Returns: `Self`
    @discardableResult
    func addTarget(_ target: AnyObject, action: Selector) -> Self {
        base.target = target
        base.action = action
        return self
    }

    /// 预声明按钮可能使用的标题集合(用于布局优化,尤其在动态切换标题时)
    ///
    /// - Parameter possibleTitles: 所有可能出现的标题字符串集合,可为 `nil`
    /// - Returns: `Self`
    @discardableResult
    func possibleTitles(_ possibleTitles: Set<String>?) -> Self {
        base.possibleTitles = possibleTitles
        return self
    }
}

// MARK: - 链式方法
public extension FdyWrapper where Base: UIBarButtonItem {
    /// 按钮图标的渲染模式(例如保持原始颜色或使用模板色)
    ///
    /// - Parameter renderingMode: 渲染模式(如 `.alwaysOriginal`, `.alwaysTemplate`)
    /// - Returns: `Self`
    @discardableResult
    func imageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let currentImage = base.image {
            base.image = currentImage.withRenderingMode(renderingMode)
        }
        return self
    }

    /// 按钮背景图像的渲染模式
    /// - Parameter renderingMode: 渲染模式(如 `.alwaysOriginal`, `.alwaysTemplate`)
    /// - Returns: `Self`
    /// - Note: 仅对 `.normal` 状态 + `.default` 样式下的背景图生效
    @discardableResult
    func backgroundImageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let currentBackground = base.backgroundImage(for: .normal, barMetrics: .default) {
            let renderedImage = currentBackground.withRenderingMode(renderingMode)
            base.setBackgroundImage(renderedImage, for: .normal, barMetrics: .default)
        }
        return self
    }

    /// 菜单
    /// - Parameter menu: 菜单,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func menu(_ menu: UIMenu?) -> Self {
        base.menu = menu
        return self
    }

    /// 主操作
    /// - Parameter primaryAction: 主操作,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func primaryAction(_ primaryAction: UIAction?) -> Self {
        base.primaryAction = primaryAction
        return self
    }

    /// 菜单展示形态
    /// - Parameter menuRepresentation: 菜单元素,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func menuRepresentation(_ menuRepresentation: UIMenuElement?) -> Self {
        base.menuRepresentation = menuRepresentation
        return self
    }

    /// 菜单元素排序策略
    /// - Parameter preferredMenuElementOrder: 排序策略
    /// - Returns: `Self`
    @discardableResult
    func preferredMenuElementOrder(
        _ preferredMenuElementOrder: UIContextMenuConfiguration.ElementOrder
    ) -> Self {
        base.preferredMenuElementOrder = preferredMenuElementOrder
        return self
    }

    /// 「选中是否触发主操作」
    /// - Parameter changesSelectionAsPrimaryAction: `true` 时点击即执行主操作
    /// - Returns: `Self`
    @discardableResult
    func changesSelectionAsPrimaryAction(_ changesSelectionAsPrimaryAction: Bool) -> Self {
        base.changesSelectionAsPrimaryAction = changesSelectionAsPrimaryAction
        return self
    }

    /// 是否为选中态
    /// - Parameter isSelected: 是否处于选中态
    /// - Returns: `Self`
    @discardableResult
    func isSelected(_ isSelected: Bool) -> Self {
        base.isSelected = isSelected
        return self
    }

    /// 是否隐藏
    /// - Parameter isHidden: `true` 表示隐藏
    /// - Returns: `Self`
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        base.isHidden = isHidden
        return self
    }

    /// 是否启用符号动画
    /// - Parameter isSymbolAnimationEnabled: `true` 表示启用符号动画
    /// - Returns: `Self`
    @discardableResult
    func isSymbolAnimationEnabled(_ isSymbolAnimationEnabled: Bool) -> Self {
        base.isSymbolAnimationEnabled = isSymbolAnimationEnabled
        return self
    }

    /// 按钮的 `tintColor`
    /// - Parameter color: 颜色,传 `nil` 用系统默认
    /// - Returns: `Self`
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        base.tintColor = color
        return self
    }
}

// MARK: - iOS 26.0 / 27.0 新增属性

public extension FdyWrapper where Base: UIBarButtonItem {
    /// 是否隐藏与相邻按钮的共享背景
    ///
    /// - Parameter hidesSharedBackground: `true` 隐藏
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func hidesSharedBackground(_ hidesSharedBackground: Bool) -> Self {
        base.hidesSharedBackground = hidesSharedBackground
        return self
    }

    /// 是否与相邻按钮共享背景
    ///
    /// - Parameter sharesBackground: `true` 共享
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func sharesBackground(_ sharesBackground: Bool) -> Self {
        base.sharesBackground = sharesBackground
        return self
    }

    /// 跨转场匹配按钮用的标识
    ///
    /// - Parameter identifier: 标识字符串,传 `nil` 清空
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func identifier(_ identifier: String?) -> Self {
        base.identifier = identifier
        return self
    }

    /// 是否移除内边距
    ///
    /// - Parameter isPaddingRemoved: `true` 移除
    /// - Returns: `Self`
    @available(iOS 27.0, *)
    @discardableResult
    func isPaddingRemoved(_ isPaddingRemoved: Bool) -> Self {
        base.isPaddingRemoved = isPaddingRemoved
        return self
    }

    /// 可见性优先级
    ///
    /// - Parameter visibilityPriority: 优先级枚举值
    /// - Returns: `Self`
    @available(iOS 27.0, *)
    @discardableResult
    func visibilityPriority(_ visibilityPriority: UIBarButtonItemVisibilityPriority) -> Self {
        base.visibilityPriority = visibilityPriority
        return self
    }
}
