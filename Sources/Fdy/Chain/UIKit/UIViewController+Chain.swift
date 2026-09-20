import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIViewController {
    /// 强制覆盖用户界面样式(亮色/暗色模式)
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func overrideUserInterfaceStyle(_ style: UIUserInterfaceStyle) -> Self {
        base.overrideUserInterfaceStyle = style
        return self
    }

    /// 模态呈现样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func modalPresentationStyle(_ style: UIModalPresentationStyle) -> Self {
        base.modalPresentationStyle = style
        return self
    }

    /// 内容大小
    /// - Parameter size: 内容大小
    /// - Returns: `Self`
    @discardableResult
    func preferredContentSize(_ size: CGSize) -> Self {
        base.preferredContentSize = size
        return self
    }

    /// 是否禁止通过手势或点击背景关闭抽屉
    /// - Parameter isModalInPresentation: `true` 表示强制模态（不可关闭），`false` 表示允许关闭（默认）
    /// - Returns: `Self`
    @discardableResult
    func isModalInPresentation(_ isModalInPresentation: Bool) -> Self {
        base.isModalInPresentation = isModalInPresentation
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension FdyWrapper where Base: UIViewController {
    /// 安全地将子控制器添加到指定容器视图
    ///
    /// - Parameters:
    ///   - child: 要添加的子视图控制器
    ///   - containerView: 容器视图(必须已加入视图层级,否则子视图不可见)
    /// - Returns: `Self`
    ///
    /// - 注意：自动完成完整的子控制器生命周期调用：
    ///   `addChild(_:)` → `addSubview(_:)` → `didMove(toParent:)`
    @discardableResult
    func addChild(_ child: UIViewController, to containerView: UIView) -> Self {
        base.addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: base)
        return self
    }

    /// 从父控制器中安全移除自身(包括视图和生命周期回调)
    ///
    /// - Returns: `Self`
    /// - 注意：仅当 `parent != nil` 时执行移除操作
    ///   自动完成：`willMove(toParent: nil)` → `removeFromSuperview()` → `removeFromParent()`
    @discardableResult
    func removeFromParent() -> Self {
        guard base.parent != nil else { return self }
        base.willMove(toParent: nil)
        base.view.removeFromSuperview()
        base.removeFromParent()
        return self
    }

    /// 是否把自身作为转场呈现的上下文
    /// - Parameter definesPresentationContext: 是否作为展示上下文边界
    /// - Returns: `Self`
    @discardableResult
    func definesPresentationContext(_ definesPresentationContext: Bool) -> Self {
        base.definesPresentationContext = definesPresentationContext
        return self
    }

    /// 是否使用呈现上下文的转场样式
    /// - Parameter providesPresentationContextTransitionStyle: 是否提供展示上下文的过渡样式
    /// - Returns: `Self`
    @discardableResult
    func providesPresentationContextTransitionStyle(_ providesPresentationContextTransitionStyle: Bool) -> Self {
        base.providesPresentationContextTransitionStyle = providesPresentationContextTransitionStyle
        return self
    }

    /// 转场后是否恢复焦点
    /// - Parameter restoresFocusAfterTransition: 要设置的转场后是否恢复焦点
    /// - Returns: `Self`
    @discardableResult
    func restoresFocusAfterTransition(_ restoresFocusAfterTransition: Bool) -> Self {
        base.restoresFocusAfterTransition = restoresFocusAfterTransition
        return self
    }

    /// 模态转场样式
    /// - Parameter modalTransitionStyle: 要设置的模态转场样式
    /// - Returns: `Self`
    @discardableResult
    func modalTransitionStyle(_ modalTransitionStyle: UIModalTransitionStyle) -> Self {
        base.modalTransitionStyle = modalTransitionStyle
        return self
    }

    /// 自定义转场
    /// - Parameter preferredTransition: 转场对象,传 `nil` 回退到系统转场
    /// - Returns: `Self`
    @discardableResult
    func preferredTransition(_ preferredTransition: UIViewController.Transition?) -> Self {
        base.preferredTransition = preferredTransition
        return self
    }

    /// 模态呈现时是否接管状态栏外观
    /// - Parameter modalPresentationCapturesStatusBarAppearance: 要设置的模态呈现时是否接管状态栏外观
    /// - Returns: `Self`
    @discardableResult
    func modalPresentationCapturesStatusBarAppearance(_ modalPresentationCapturesStatusBarAppearance: Bool) -> Self {
        base.modalPresentationCapturesStatusBarAppearance = modalPresentationCapturesStatusBarAppearance
        return self
    }

    /// 焦点组标识符
    /// - Parameter focusGroupIdentifier: 标识符,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func focusGroupIdentifier(_ focusGroupIdentifier: String?) -> Self {
        base.focusGroupIdentifier = focusGroupIdentifier
        return self
    }

    /// 交互活动追踪的基础名称
    /// - Parameter interactionActivityTrackingBaseName: 基础名称,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func interactionActivityTrackingBaseName(_ interactionActivityTrackingBaseName: String?) -> Self {
        base.interactionActivityTrackingBaseName = interactionActivityTrackingBaseName
        return self
    }
}
