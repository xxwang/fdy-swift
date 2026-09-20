import UIKit

// MARK: - 可扩大点击热区、并按时间抑制重复点击的按钮
open class FdyButton: UIButton {
    /// 按钮点击处理回调
    open var clickBlock: FdyAction1<FdyButton>?

    /// 向四周扩展的尺寸；`<= 0` 表示不扩展
    public var fdy_expandSize: CGFloat = 0

    /// 同一业务动作两次派发之间的最小间隔（秒）；`<= 0` 表示不限制
    public var fdy_repeatClickInterval: TimeInterval = 0

    /// 各业务动作上次实际派发的时刻
    private var fdy_lastFireTimes: [String: CFTimeInterval] = [:]

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindEvents()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        bindEvents()
    }

    override open class func button() -> Self {
        return Self(type: .custom)
    }
}

// MARK: - FdySetupable
@objc extension FdyButton: FdySetupable {
    /// 配置 UI
    open func setupUI() {}

    /// 绑定事件
    open func bindEvents() {}
}

// MARK: - 辅助方法
extension FdyButton {
    /// 判断某个业务动作当前是否允许派发，并在放行时记录时刻
    /// - Returns: 允许派发返回 `true`，处于时间窗内返回 `false`
    private func fdy_shouldFire(key: String) -> Bool {
        guard fdy_repeatClickInterval > 0 else { return true }
        let now = CACurrentMediaTime()
        if let lastFire = fdy_lastFireTimes[key], now - lastFire < fdy_repeatClickInterval {
            return false
        }
        fdy_lastFireTimes[key] = now
        return true
    }

    /// 按钮点击处理
    @objc func clickHandler(_ sender: FdyButton) {
        if let block = self.clickBlock {
            block(sender)
        }
    }
}

// MARK: - 系统方法重写
extension FdyButton {
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard fdy_expandSize > 0 else { return super.point(inside: point, with: event) }
        return bounds.insetBy(dx: -fdy_expandSize, dy: -fdy_expandSize).contains(point)
    }

    /// 拦截 target-action 派发
    ///
    /// - Note: `UIControl.sendAction(_:to:for:)` 是官方文档化的拦截点 ——
    ///   「调用 `super` 一次以完成派发，或不调用 `super` 以抑制该次派发」。
    ///   相比临时翻转 `isEnabled`，此做法不产生任何视觉状态变化，也不会干扰外部状态机。
    override open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        guard fdy_shouldFire(key: NSStringFromSelector(action)) else { return }
        super.sendAction(action, to: target, for: event)
    }

    /// 拦截 `UIAction` 派发
    ///
    /// - Important: `UIAction` 走的是与 target-action **并列的另一个重载**，
    ///   只重写上一条会漏掉 `addAction(_:for:)` 注册的全部回调。
    override open func sendAction(_ action: UIAction) {
        guard fdy_shouldFire(key: action.identifier.rawValue) else { return }
        super.sendAction(action)
    }
}

// MARK: - 链式方法
public extension FdyWrapper where Base: FdyButton {
    /// 扩大按钮的点击区域
    ///
    /// - Parameter size: 向四周扩展的像素大小，非正值视为不扩展
    /// - Returns: `Self`
    /// - Note: 命中判定写在本类自身，只对该类及其子类生效，不污染其它 `UIButton`。
    @discardableResult
    func expandClickArea(_ size: CGFloat = 10) -> Self {
        base.fdy_expandSize = size
        return self
    }

    /// 防重复点击的最小间隔
    ///
    /// - Parameter interval: 同一业务动作两次派发之间的最小秒数
    /// - Returns: `Self`
    /// - Note: 计时按业务动作分别进行，非正值表示不限制。
    @discardableResult
    func repeatClickInterval(_ interval: TimeInterval) -> Self {
        base.fdy_repeatClickInterval = interval
        return self
    }

    /// 绑定点击处理回调
    /// - Parameter block: 点击处理回调
    /// - Returns: `Self`
    /// - Warning: 闭包被按钮**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    @discardableResult
    func clickBlock(_ block: @escaping FdyAction1<FdyButton>) -> Self {
        base.clickBlock = block
        base.removeTarget(base, action: #selector(FdyButton.clickHandler(_:)), for: .touchUpInside)
        base.addTarget(base, action: #selector(FdyButton.clickHandler(_:)), for: .touchUpInside)
        return self
    }
}
