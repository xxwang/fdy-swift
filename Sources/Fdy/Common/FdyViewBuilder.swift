import UIKit

@resultBuilder
public struct FdyViewBuilder {
    /// 承接单个视图
    /// - Parameter expression: 视图
    /// - Returns: 视图数组
    public static func buildExpression(_ expression: UIView) -> [UIView] {
        [expression]
    }

    /// 承接视图数组
    /// - Parameter expression: 视图数组
    /// - Returns: 视图数组
    public static func buildExpression(_ expression: [UIView]) -> [UIView] {
        expression
    }

    /// 构建多个子视图(基本用法)
    /// - Parameter components: 各分量
    /// - Returns: 视图数组
    public static func buildBlock(_ components: [UIView]...) -> [UIView] {
        components.flatMap(\.self)
    }

    /// 支持空闭包(无子视图)
    /// - Returns: 视图数组
    public static func buildBlock() -> [UIView] {
        []
    }

    /// 支持可选视图(`if` 条件)
    /// - Parameter component: 视图数组
    /// - Returns: 视图数组
    public static func buildOptional(_ component: [UIView]?) -> [UIView] {
        component ?? []
    }

    /// 支持 `if-else` 分支(`true` 分支)
    /// - Parameter component: 视图数组
    /// - Returns: 视图数组
    public static func buildEither(first component: [UIView]) -> [UIView] {
        component
    }

    /// 支持 `if-else `分支(`false` 分支)
    /// - Parameter component: 视图数组
    /// - Returns: 视图数组
    public static func buildEither(second component: [UIView]) -> [UIView] {
        component
    }

    /// 支持 `for-in `循环
    /// - Parameter components: 各分量
    /// - Returns: 视图数组
    public static func buildArray(_ components: [[UIView]]) -> [UIView] {
        components.flatMap(\.self)
    }
}

// MARK: - UIView
public extension UIView {
    /// 使用 `FdyViewBuilder` 声明式地添加子视图
    ///
    /// - Parameters:
    ///   - content: 视图构建器闭包,返回一组子视图
    ///   - configure: 可选的配置闭包,在添加子视图后调用(可用于设置约束等)
    convenience init(
        @FdyViewBuilder content: () -> [UIView],
        configure: FdyAction1<UIView>? = nil
    ) {
        self.init()

        // 添加子视图
        let subviews = content()
        for subview in subviews {
            // 默认关闭 autoresizing mask(推荐使用 Auto Layout)
            subview.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(subview)
        }

        // 可选的额外配置(如背景色、约束等)
        configure?(self)
    }
}
