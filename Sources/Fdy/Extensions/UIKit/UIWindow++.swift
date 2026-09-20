import UIKit

// MARK: - UIWindow相关
public extension UIWindow {
    /// 获取当前应用中最合适的主窗口
    /// - Returns: 窗口,不可用时返回 `nil`
    static var fdy_keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first { !$0.isHidden && $0.isKeyWindow }
    }

    /// 获取所有有效的、非隐藏的 `UIWindow` 实例
    /// - Returns: 窗口数组
    static var fdy_windows: [UIWindow] {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .filter { !$0.isHidden }
    }
}

// MARK: - UIViewController相关
public extension UIWindow {
    /// 获取当前最顶层的可见视图控制器
    /// - Returns: 最顶层的 `UIViewController`
    static var fdy_topViewController: UIViewController? {
        var current = self.fdy_keyWindow?.rootViewController

        while let root = current {
            if let nav = root as? UINavigationController {
                current = nav.visibleViewController
            } else if let tab = root as? UITabBarController {
                current = tab.selectedViewController
            } else if let split = root as? UISplitViewController {
                // 分栏展开(未折叠)时下钻 `detail`(最后一个)，否则下钻主列(第一个)。
                // `viewControllers` 为空数组时两条分支都得到 `nil`，循环随即结束。
                if split.isCollapsed == false, let detail = split.viewControllers.last {
                    current = detail
                } else {
                    current = split.viewControllers.first
                }
            } else if let presented = root.presentedViewController {
                current = presented
            } else {
                return root
            }
        }

        return nil
    }
}

public extension UIWindow {
    /// 安全切换根视图控制器(带动画)
    ///
    /// - Parameters:
    ///   - viewController: 新的根视图控制器
    ///   - animated: 是否启用动画(默认 true)
    ///   - duration: 动画时长(默认 0.25 秒)
    ///   - type: 转场类型(默认 .fade)
    ///   - subtype: 转场方向(默认 .fromRight)
    ///   - completion: 动画完成后回调
    static func switchRootViewController(
        to viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.25,
        type: CATransitionType = .fade,
        subtype: CATransitionSubtype? = .fromRight,
        completion: (() -> Void)? = nil
    ) {
        let window: UIWindow? = UIWindow.fdy_keyWindow

        guard let window else {
            fdyG.logger.warn("⚠️ 无法切换 rootViewController：未找到 keyWindow")
            return
        }

        // 预布局新视图，避免闪屏
        viewController.view.frame = window.bounds
        viewController.view.layoutIfNeeded()

        if animated {
            let transition = CATransition()
            transition.duration = duration
            transition.type = type
            transition.subtype = subtype
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.isRemovedOnCompletion = true
            window.layer.add(transition, forKey: kCATransition)
        }
        window.rootViewController = viewController
        completion?()
    }
}
