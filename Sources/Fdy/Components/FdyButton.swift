import UIKit

/// 可扩大点击热区、并按时间窗抑制重复点击的按钮
///
/// iOS 推荐的点击目标最小尺寸为 44×44pt，视觉上要更小的按钮可以借助本类向外扩展热区；
/// 需要防止用户连点造成重复提交的按钮，可以再叠加一个最小触发间隔。
///
/// - Important: 与在 `UIButton` 扩展里 `override point(inside:with:)` 的**类级注入**不同，
///   全部逻辑只在本类（及其子类）内生效，不会污染其它 `UIButton`，
///   也不会出现「子类重写后设置静默失效」的问题。
///
/// - Important: 扩展区域**超出父视图 `bounds` 时不生效** —— `hitTest` 会先询问父视图，
///   父视图判定点不在自己范围内就直接返回 `nil`，根本不会询问本按钮。
///
/// - Example:
/// ```swift
/// let button = FdyButton(type: .custom)
///     .fdy
///     .expandClickArea(10)          // 向四周各扩展 10pt
///     .repeatClickInterval(0.5)     // 0.5s 内重复触发只放行第一次
///     .build()
///
/// // 或不使用链式语法
/// let other = FdyButton()
/// other.fdy_expandSize = 10
/// other.fdy_repeatClickInterval = 0.5
/// ```
open class FdyButton: UIButton {
    /// 按钮点击处理回调。子类可重写或在初始化后设置
    open var clickBlock: FdyAction1<FdyButton>?

    // MARK: - 点击热区

    /// 向四周扩展的尺寸；`<= 0` 表示不扩展
    ///
    /// - Note: 直接赋值即可，无需触发 `setNeedsLayout` —— 本属性只参与
    ///   `point(inside:with:)` 的命中判定，不影响布局与绘制。
    public var fdy_expandSize: CGFloat = 0

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard fdy_expandSize > 0 else { return super.point(inside: point, with: event) }
        return bounds.insetBy(dx: -fdy_expandSize, dy: -fdy_expandSize).contains(point)
    }

    // MARK: - 防重复点击

    /// 同一业务动作两次派发之间的最小间隔（秒）；`<= 0` 表示不限制
    ///
    /// - Important: 计时**按业务动作分别进行**（键为 selector 名或 `UIAction.identifier`），
    ///   因此「`.touchDown` 做按压反馈 + `.touchUpInside` 做业务」这类组合不会互相挤占时间窗 ——
    ///   若共用同一个时间窗，`touchDown` 会把 `touchUpInside` 的业务动作静默吃掉。
    ///   同一个 selector 注册在多个 control event 上时视为同一动作，一个时间窗内只放行一次。
    ///
    /// - Note: 修改该值不会追溯既往 —— 在此之前的派发不参与计时。
    public var fdy_repeatClickInterval: TimeInterval = 0

    /// 各业务动作上次实际派发的时刻
    private var fdy_lastFireTimes: [String: CFTimeInterval] = [:]

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

    /// 判断某个业务动作当前是否允许派发，并在放行时记录时刻
    /// - Parameter key: 业务动作标识
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
//
// 与 `FdyTextView` 保持一致的组件约定：**显式实现**协议成员(而不是依赖协议扩展的空默认实现) ——
// 只有成为类成员才有 vtable 槽位，子类的 `override` 才会被 `init` 里的调用命中。
// 其余成员(`bindViewModel` / `fetchData` / `bindData`)沿用协议的默认实现。
@objc extension FdyButton: FdySetupable {
    /// 配置 UI。子类重写以集中设置外观
    open func setupUI() {}

    /// 绑定事件。子类重写以集中注册 target/action
    open func bindEvents() {}
}

// MARK: - 链式方法
public extension FdyWrapper where Base: FdyButton {
    /// 扩大按钮的点击区域
    ///
    /// - Note: 命中判定写在本类自身，只对该类及其子类生效，不污染其它 `UIButton`。
    /// - Parameter size: 向四周扩展的像素大小，非正值视为不扩展
    /// - Returns: `Self`
    @discardableResult
    func expandClickArea(_ size: CGFloat = 10) -> Self {
        base.fdy_expandSize = size
        return self
    }

    /// 设置防重复点击的最小间隔
    ///
    /// - Note: 计时按业务动作分别进行，非正值表示不限制。
    /// - Parameter interval: 同一业务动作两次派发之间的最小秒数
    /// - Returns: `Self`
    @discardableResult
    func repeatClickInterval(_ interval: TimeInterval) -> Self {
        base.fdy_repeatClickInterval = interval
        return self
    }
}

extension FdyButton {
    /// 按钮点击处理
    @objc func clickHandler(_ sender: FdyButton) {
        if let block = self.clickBlock {
            block(sender)
        }
    }
}

// MARK: - 链式配置(自定义)
public extension FdyWrapper where Base: FdyButton {
    /// 绑定点击处理回调
    /// - Warning: 闭包被按钮**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 点击处理回调
    /// - Returns: `Self`
    func clickBlock(_ block: @escaping FdyAction1<FdyButton>) -> Self {
        base.clickBlock = block
        base.removeTarget(base, action: #selector(FdyButton.clickHandler(_:)), for: .touchUpInside)
        base.addTarget(base, action: #selector(FdyButton.clickHandler(_:)), for: .touchUpInside)
        return self
    }
}
