import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UINavigationController {
    /// 导航控制器的代理
    ///
    /// - Parameter delegate: 代理对象,传入 `nil` 可移除代理
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UINavigationControllerDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 导航控制器交互手势识别器代理
    /// - Parameter delegate: 代理对象,传入 `nil` 可移除代理
    /// - Returns: `Self`
    @discardableResult
    func interactivePopGestureRecognizerDelegate(_ delegate: (any UIGestureRecognizerDelegate)?) -> Self {
        base.interactivePopGestureRecognizer?.delegate = delegate
        return self
    }
}

// MARK: - 链式方法
public extension FdyWrapper where Base: UINavigationController {
    /// 导航栏是否隐藏
    ///
    /// - Parameters:
    ///   - hidden: 是否隐藏导航栏
    ///   - animated: 是否使用动画过渡默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func navigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        base.setNavigationBarHidden(hidden, animated: animated)
        return self
    }

    /// 替换整个视图控制器栈
    ///
    /// - Parameters:
    ///   - viewControllers: 新的视图控制器数组
    ///   - animated: 是否使用动画过渡默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func viewControllers(_ viewControllers: [UIViewController], animated: Bool = false) -> Self {
        base.setViewControllers(viewControllers, animated: animated)
        return self
    }

    /// 键盘出现时是否隐藏栏
    /// - Parameter hidesBarsWhenKeyboardAppears: 要设置的键盘出现时是否隐藏栏
    /// - Returns: `Self`
    @discardableResult
    func hidesBarsWhenKeyboardAppears(_ hidesBarsWhenKeyboardAppears: Bool) -> Self {
        base.hidesBarsWhenKeyboardAppears = hidesBarsWhenKeyboardAppears
        return self
    }

    /// 滑动时是否隐藏栏
    /// - Parameter hidesBarsOnSwipe: 要设置的滑动时是否隐藏栏
    /// - Returns: `Self`
    @discardableResult
    func hidesBarsOnSwipe(_ hidesBarsOnSwipe: Bool) -> Self {
        base.hidesBarsOnSwipe = hidesBarsOnSwipe
        return self
    }

    /// 竖向紧凑时是否隐藏栏
    /// - Parameter hidesBarsWhenVerticallyCompact: 要设置的竖向紧凑时是否隐藏栏
    /// - Returns: `Self`
    @discardableResult
    func hidesBarsWhenVerticallyCompact(_ hidesBarsWhenVerticallyCompact: Bool) -> Self {
        base.hidesBarsWhenVerticallyCompact = hidesBarsWhenVerticallyCompact
        return self
    }

    /// 点击时是否隐藏栏
    /// - Parameter hidesBarsOnTap: 要设置的点击时是否隐藏栏
    /// - Returns: `Self`
    @discardableResult
    func hidesBarsOnTap(_ hidesBarsOnTap: Bool) -> Self {
        base.hidesBarsOnTap = hidesBarsOnTap
        return self
    }
}
