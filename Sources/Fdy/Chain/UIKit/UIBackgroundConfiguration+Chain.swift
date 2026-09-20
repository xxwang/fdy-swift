import UIKit

// MARK: - 命名空间入口
extension UIBackgroundConfiguration: FdyExtension {}

// MARK: - 链式设置属性
public extension FdyWrapper where Base == UIBackgroundConfiguration {
    /// 自定义背景视图
    ///
    /// - Parameter customView: 视图
    /// - Returns: `Self`
    /// - Note: 自定义视图必须开着 `translatesAutoresizingMaskIntoConstraints`,内部子视图可以正常用
    ///   自动布局(头文件明示)。
    @discardableResult
    func customView(_ customView: UIView?) -> Self {
        base.customView = customView
        return self
    }

    /// 背景与描边的圆角(连续曲率)
    ///
    /// - Parameter cornerRadius: 圆角半径
    /// - Returns: `Self`
    /// - Note: 视图小到装不下时,系统会**自行收敛圆角曲线与半径**去适配,不是照单全收。
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        base.cornerRadius = cornerRadius
        return self
    }

    /// 背景与描边相对容器边缘的内缩(负值即外扩)
    /// - Parameter backgroundInsets: 背景内边距
    /// - Returns: `Self`
    @discardableResult
    func backgroundInsets(_ backgroundInsets: NSDirectionalEdgeInsets) -> Self {
        base.backgroundInsets = backgroundInsets
        return self
    }

    /// 让指定边把容器的 `layoutMargins` 叠加进 ``backgroundInsets(_:)``
    ///
    /// - Parameter edgesAddingLayoutMarginsToBackgroundInsets: 需把布局边距并入背景内边距的边
    /// - Returns: `Self`
    /// - Note: 效果是让这些边的内缩量**相对容器的 layoutMargins** 计算,而不是相对容器边缘。
    @discardableResult
    func edgesAddingLayoutMarginsToBackgroundInsets(
        _ edgesAddingLayoutMarginsToBackgroundInsets: NSDirectionalRectEdge
    ) -> Self {
        base.edgesAddingLayoutMarginsToBackgroundInsets = edgesAddingLayoutMarginsToBackgroundInsets
        return self
    }

    /// 填充色
    ///
    /// - Parameter backgroundColor: 颜色
    /// - Returns: `Self`
    /// - Note: 传 `nil` 表示**取视图的 `tintColor`**(不是「无色」);要透明请传 `.clear`。
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        base.backgroundColor = backgroundColor
        return self
    }

    /// 填充色变换器
    ///
    /// - Parameter backgroundColorTransformer: 要设置的填充色变换器
    /// - Returns: `Self`
    /// - Note: 传 `nil` 表示 ``backgroundColor(_:)`` 原样使用;非 `nil` 时由它做最终解析,
    ///   结果可用 `UIBackgroundConfiguration.resolvedBackgroundColor(for:)` 核对。
    @discardableResult
    func backgroundColorTransformer(_ backgroundColorTransformer: UIConfigurationColorTransformer?) -> Self {
        base.backgroundColorTransformer = backgroundColorTransformer
        return self
    }

    /// 背景的视觉效果(毛玻璃等)
    /// - Parameter visualEffect: 视觉效果
    /// - Returns: `Self`
    @discardableResult
    func visualEffect(_ visualEffect: UIVisualEffect?) -> Self {
        base.visualEffect = visualEffect
        return self
    }

    /// 背景图
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 背景图的渲染方式
    /// - Parameter imageContentMode: 要设置的背景图的渲染方式
    /// - Returns: `Self`
    @discardableResult
    func imageContentMode(_ imageContentMode: UIView.ContentMode) -> Self {
        base.imageContentMode = imageContentMode
        return self
    }

    /// 描边色
    ///
    /// - Parameter strokeColor: 颜色
    /// - Returns: `Self`
    /// - Note: 同 ``backgroundColor(_:)`` —— `nil` 表示取 `tintColor`,透明要传 `.clear`。
    @discardableResult
    func strokeColor(_ strokeColor: UIColor?) -> Self {
        base.strokeColor = strokeColor
        return self
    }

    /// 描边色变换器
    /// - Parameter strokeColorTransformer: 要设置的描边色变换器
    /// - Returns: `Self`
    @discardableResult
    func strokeColorTransformer(_ strokeColorTransformer: UIConfigurationColorTransformer?) -> Self {
        base.strokeColorTransformer = strokeColorTransformer
        return self
    }

    /// 描边宽度(默认 0,即不描边)
    /// - Parameter strokeWidth: 描边宽度
    /// - Returns: `Self`
    @discardableResult
    func strokeWidth(_ strokeWidth: CGFloat) -> Self {
        base.strokeWidth = strokeWidth
        return self
    }

    /// 描边相对背景的外扩量(负值为内缩)
    ///
    /// - Parameter strokeOutset: 描边外扩量
    /// - Returns: `Self`
    /// - Note: 外扩后**描边圆角会被系统调整**,以与背景保持同心(头文件明示)。
    @discardableResult
    func strokeOutset(_ strokeOutset: CGFloat) -> Self {
        base.strokeOutset = strokeOutset
        return self
    }
}

// MARK: - 阴影轴
// `shadowProperties` 是 struct（`UIShadowProperties`），不能像引用类型那样嵌套着改，故按本库既有约定
// 把嵌套轴的属性**拍平**成前缀方法（先例：`UIButton.Configuration+Chain.swift` 的 `backgroundCornerRadius`）。
// - Note: ObjC 头把 `shadowProperties` 标成 `readonly`，但 Swift 接口是 `{ get set }`、
//   `configuration.shadowProperties.radius = 4` 实测可编译 —— **以编译器为准**，按可写实现。
public extension FdyWrapper where Base == UIBackgroundConfiguration {
    /// 阴影颜色
    /// - Parameter shadowColor: 颜色
    /// - Returns: `Self`
    @discardableResult
    func shadowColor(_ shadowColor: UIColor) -> Self {
        base.shadowProperties.color = shadowColor
        return self
    }

    /// 阴影不透明度
    ///
    /// - Parameter shadowOpacity: 要设置的阴影不透明度
    /// - Returns: `Self`
    /// - Note: 默认配置下不透明度为 `0`,即**没有阴影** —— 只设颜色不设不透明度是看不到阴影的。
    @discardableResult
    func shadowOpacity(_ shadowOpacity: CGFloat) -> Self {
        base.shadowProperties.opacity = shadowOpacity
        return self
    }

    /// 阴影模糊半径
    /// - Parameter shadowRadius: 要设置的阴影模糊半径
    /// - Returns: `Self`
    @discardableResult
    func shadowRadius(_ shadowRadius: CGFloat) -> Self {
        base.shadowProperties.radius = shadowRadius
        return self
    }

    /// 阴影偏移
    /// - Parameter shadowOffset: 尺寸
    /// - Returns: `Self`
    @discardableResult
    func shadowOffset(_ shadowOffset: CGSize) -> Self {
        base.shadowProperties.offset = shadowOffset
        return self
    }

    /// 阴影路径
    /// - Parameter shadowPath: 要设置的阴影路径
    /// - Returns: `Self`
    @discardableResult
    func shadowPath(_ shadowPath: UIBezierPath?) -> Self {
        base.shadowProperties.path = shadowPath
        return self
    }
}

// MARK: - 方法
public extension FdyWrapper where Base == UIBackgroundConfiguration {
    /// 按给定配置状态换算出一份**已应用状态默认值**的配置并替换当前值
    ///
    /// - Parameter state: 状态
    /// - Returns: `Self`
    /// - Note: 只会覆盖「尚未被自定义」的属性;已显式设过的值保持不变。常用于
    ///   `cell.configurationUpdateHandler` 里按 `configurationState` 取色。
    @discardableResult
    func updated(for state: any UIConfigurationState) -> Self {
        base = base.updated(for: state)
        return self
    }
}
