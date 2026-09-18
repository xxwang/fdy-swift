import UIKit

// MARK: - 命名空间入口
//
// `UIBackgroundConfiguration` 在 Swift 侧是 **struct**(ObjC 的 `UIBackgroundConfiguration` 是 `NSObject`
// 子类,Swift 把它桥接成了值类型),因此**不继承** `extension NSObject: FdyExtension` —— 必须单独补一条
// conformance,否则本文件全部链式方法对外不可达(`value of type 'UIBackgroundConfiguration' has no
// member 'fdy'`)。
extension UIBackgroundConfiguration: FdyExtension {}

// MARK: - 链式设置属性
//
// - Note: 值类型语义 —— `.fdy` 返回的 `FdyWrapper` 持有配置的一份**拷贝**,链式修改不会改动原变量。
//   需要取回结果请以 `build()` 收尾(与 `UIButton.Configuration+Chain.swift` 同机制):
//   ```swift
//   let background = UIBackgroundConfiguration.listCell().fdy
//       .backgroundColor(.secondarySystemBackground)
//       .cornerRadius(12)
//       .build()
//   ```
public extension FdyWrapper where Base == UIBackgroundConfiguration {
    /// 设置自定义背景视图
    ///
    /// - Note: 自定义视图必须开着 `translatesAutoresizingMaskIntoConstraints`,内部子视图可以正常用
    ///   自动布局(头文件明示)。
    @discardableResult
    func customView(_ customView: UIView?) -> Self {
        base.customView = customView
        return self
    }

    /// 设置背景与描边的圆角(连续曲率)
    ///
    /// - Note: 视图小到装不下时,系统会**自行收敛圆角曲线与半径**去适配,不是照单全收。
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        base.cornerRadius = cornerRadius
        return self
    }

    /// 设置背景与描边相对容器边缘的内缩(负值即外扩)
    @discardableResult
    func backgroundInsets(_ backgroundInsets: NSDirectionalEdgeInsets) -> Self {
        base.backgroundInsets = backgroundInsets
        return self
    }

    /// 让指定边把容器的 `layoutMargins` 叠加进 ``backgroundInsets(_:)``
    ///
    /// - Note: 效果是让这些边的内缩量**相对容器的 layoutMargins** 计算,而不是相对容器边缘。
    @discardableResult
    func edgesAddingLayoutMarginsToBackgroundInsets(
        _ edgesAddingLayoutMarginsToBackgroundInsets: NSDirectionalRectEdge
    ) -> Self {
        base.edgesAddingLayoutMarginsToBackgroundInsets = edgesAddingLayoutMarginsToBackgroundInsets
        return self
    }

    /// 设置填充色
    ///
    /// - Note: 传 `nil` 表示**取视图的 `tintColor`**(不是「无色」);要透明请传 `.clear`。
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        base.backgroundColor = backgroundColor
        return self
    }

    /// 设置填充色变换器
    ///
    /// - Note: 传 `nil` 表示 ``backgroundColor(_:)`` 原样使用;非 `nil` 时由它做最终解析,
    ///   结果可用 `UIBackgroundConfiguration.resolvedBackgroundColor(for:)` 核对。
    @discardableResult
    func backgroundColorTransformer(_ backgroundColorTransformer: UIConfigurationColorTransformer?) -> Self {
        base.backgroundColorTransformer = backgroundColorTransformer
        return self
    }

    /// 设置背景的视觉效果(毛玻璃等)
    @discardableResult
    func visualEffect(_ visualEffect: UIVisualEffect?) -> Self {
        base.visualEffect = visualEffect
        return self
    }

    /// 设置背景图
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 设置背景图的渲染方式
    @discardableResult
    func imageContentMode(_ imageContentMode: UIView.ContentMode) -> Self {
        base.imageContentMode = imageContentMode
        return self
    }

    /// 设置描边色
    ///
    /// - Note: 同 ``backgroundColor(_:)`` —— `nil` 表示取 `tintColor`,透明要传 `.clear`。
    @discardableResult
    func strokeColor(_ strokeColor: UIColor?) -> Self {
        base.strokeColor = strokeColor
        return self
    }

    /// 设置描边色变换器
    @discardableResult
    func strokeColorTransformer(_ strokeColorTransformer: UIConfigurationColorTransformer?) -> Self {
        base.strokeColorTransformer = strokeColorTransformer
        return self
    }

    /// 设置描边宽度(默认 0,即不描边)
    @discardableResult
    func strokeWidth(_ strokeWidth: CGFloat) -> Self {
        base.strokeWidth = strokeWidth
        return self
    }

    /// 设置描边相对背景的外扩量(负值为内缩)
    ///
    /// - Note: 外扩后**描边圆角会被系统调整**,以与背景保持同心(头文件明示)。
    @discardableResult
    func strokeOutset(_ strokeOutset: CGFloat) -> Self {
        base.strokeOutset = strokeOutset
        return self
    }
}

// MARK: - 阴影轴
//
// `shadowProperties` 本身是 struct(`UIShadowProperties`),不能像引用类型那样嵌套着改,
// 故按本库既有约定把嵌套轴的属性**拍平**成前缀方法(先例:`UIButton.Configuration+Chain.swift`
// 的 `backgroundCornerRadius` / `titlePadding` 等)。
//
// - Note: ObjC 头文件把 `shadowProperties` 标成了 `readonly`,但 Swift 接口是 `{ get set }`,
//   且 `configuration.shadowProperties.radius = 4` 实测可编译 —— **以编译器为准**,按可写实现。
public extension FdyWrapper where Base == UIBackgroundConfiguration {
    /// 设置阴影颜色
    @discardableResult
    func shadowColor(_ shadowColor: UIColor) -> Self {
        base.shadowProperties.color = shadowColor
        return self
    }

    /// 设置阴影不透明度
    ///
    /// - Note: 默认配置下不透明度为 `0`,即**没有阴影** —— 只设颜色不设不透明度是看不到阴影的。
    @discardableResult
    func shadowOpacity(_ shadowOpacity: CGFloat) -> Self {
        base.shadowProperties.opacity = shadowOpacity
        return self
    }

    /// 设置阴影模糊半径
    @discardableResult
    func shadowRadius(_ shadowRadius: CGFloat) -> Self {
        base.shadowProperties.radius = shadowRadius
        return self
    }

    /// 设置阴影偏移
    @discardableResult
    func shadowOffset(_ shadowOffset: CGSize) -> Self {
        base.shadowProperties.offset = shadowOffset
        return self
    }

    /// 设置阴影路径
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
    /// - Note: 只会覆盖「尚未被自定义」的属性;已显式设过的值保持不变。常用于
    ///   `cell.configurationUpdateHandler` 里按 `configurationState` 取色。
    @discardableResult
    func updated(for state: any UIConfigurationState) -> Self {
        base = base.updated(for: state)
        return self
    }
}
