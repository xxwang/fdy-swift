import UIKit
import os.log

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIAlertController {
    /// 标题
    /// - Parameter title: 标题文本
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        base.title = title
        return self
    }

    /// 副标题(消息内容)
    /// - Parameter message: 消息文本
    /// - Returns: `Self`
    @discardableResult
    func message(_ message: String?) -> Self {
        base.message = message
        return self
    }

    /// 添加一个已构建好的`UIAlertAction`
    /// - Parameter action: `UIAlertAction`实例
    /// - Returns: `Self`
    @discardableResult
    func addAction(_ action: UIAlertAction) -> Self {
        base.addAction(action)
        return self
    }

    /// 快捷添加一个`UIAlertAction`(通过标题和回调)
    /// - Parameters:
    ///   - title: 按钮文字
    ///   - style: 按钮样式(`.default` / `.cancel` / `.destructive`)
    ///   - handler: 点击后的回调
    /// - Returns: `Self`
    @discardableResult
    func addAction(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: FdyAction1<UIAlertAction>? = nil
    ) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        base.addAction(action)
        return self
    }

    /// 添加一个`UITextField`
    /// - Parameter configurationHandler: 配置 `UITextField` 的闭包
    /// - Returns: `Self`
    @discardableResult
    func addTextField(configurationHandler: FdyAction1<UITextField>? = nil) -> Self {
        base.addTextField(configurationHandler: configurationHandler)
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension FdyWrapper where Base: UIAlertController {
    /// 从指定的`viewController` 弹出`UIAlertController`,返回 `Self` 表示已入队主线程展示
    /// - Parameters:
    ///   - viewController: 指定的来源控制器,传 `nil` 时取当前顶层控制器
    ///   - animated: 是否启用动画
    /// - Returns: `Self`
    @discardableResult
    func show(from viewController: UIViewController? = nil, animated: Bool = true) -> Self {
        DispatchQueue.main.async {
            guard let target = viewController ?? UIWindow.fdy_topViewController else {
                os_log(.error, "⚠️ [UIAlertController.show] 无法找到顶层 ViewController,弹窗未显示")
                return
            }

            if let presented = target.presentedViewController, presented.isBeingPresented || presented.isBeingDismissed {
                os_log(.error, "⚠️ [UIAlertController.show] 目标 ViewController 正在处理其他弹窗,跳过本次弹窗")
                return
            }
            target.present(self.base, animated: animated)
        }
        return self
    }

    /// 首选操作(高亮显示的那个按钮)
    /// - Parameter preferredAction: 操作,传 `nil` 取消高亮
    /// - Returns: `Self`
    @discardableResult
    func preferredAction(_ preferredAction: UIAlertAction?) -> Self {
        base.preferredAction = preferredAction
        return self
    }

    /// 提示严重级别
    /// - Parameter severity: 要设置的提示严重级别
    /// - Returns: `Self`
    @discardableResult
    func severity(_ severity: UIAlertControllerSeverity) -> Self {
        base.severity = severity
        return self
    }
}
