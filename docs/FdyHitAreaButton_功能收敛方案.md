# FdyHitAreaButton 功能收敛方案

> 目标：把「扩大点击热区」与「防指定时间内重复点击」两项能力**全部收进 `FdyHitAreaButton`**，
> 库内不再保留 `UIButton` 扩展侧的入口。

---

## 一、结论先行

| # | 结论 | 依据 |
| --- | --- | --- |
| 1 | **「防重复点击」在本库是新增，不是搬家** —— 全库零实现（无 `sendAction` 重写、无 interval 字段） | `grep` 全库无命中 |
| 2 | iOS 官方提供了**可 override 的派发拦截点**，无需翻转 `isEnabled`，无视觉副作用 | `UIControl.h:127-130` |
| 3 | **拦截必须同时覆盖两个重载**，只覆盖一个会漏 | 实测 C4/C5/C6 |
| 4 | 计时键必须**按业务动作区分**，全局单时间窗有硬缺陷 | 实测 D1（`up=0` 业务丢失） |
| 5 | 能力收敛后 API 面**收窄**：`.fdy.expandClickArea` 在裸 `UIButton` 上变编译错误 | 见第五节 |

---

## 二、官方拦截点（关键发现）

`UIControl.h`（Xcode 26.2 / 27.0 两个 SDK 一致）：

```objc
/// Dispatch the target-action pair. This method is called repeatedly by
/// -sendActionsForControlEvents: and is a point at which you can observe or override behavior.
- (void)sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event;

/// Like -sendAction:to:forEvent:, this method is called by -sendActionsForControlEvents:.
/// You may override this method to observe or modify behavior. If you override this method,
/// you should call super precisely once to dispatch the action, or not call super to suppress
/// sending that action.
- (void)sendAction:(UIAction *)action API_AVAILABLE(ios(14.0)) API_UNAVAILABLE(watchos);
```

两条要点：

1. 返回类型是 **`void`**（不是历史上的 `BOOL`），头文件明确写了「**不调 `super` 即抑制派发**」。
2. **`target-action` 与 `UIAction` 是两条独立路径**，各自有一个 `sendAction` 重载 —— 只拦前者，`addAction(_:for:)` 注册的回调完全不受影响。

---

## 三、实测证据

探针：`.build/clickprobe3/`、`.build/clickprobe4/`（真 `UIApplicationMain` + `UIWindow` 环境）。
两个运行时（iOS 26.5 / iOS 18.0）**逐行一致**。

### 3.1 拦截面（clickprobe3）

| 用例 | 场景 | 结果 | 结论 |
| --- | --- | --- | --- |
| C1 | 纯 `UIButton`（无 override） | 业务增量 `1` | 基线正常派发 |
| C2 | 两个重载都 override 且都调 `super` | 业务增量 `1`，`selector` 重载命中 1 次 | **override + `super` 不破坏派发** |
| C3 | 只 override `selector` 重载、**不调 `super`** | 业务增量 `0` | **「不调 super 即抑制」成立** |
| C4 | `addAction(UIAction)` + 观察型 | `selector` 重载 `0` 次、`UIAction` 重载 `1` 次 | **`UIAction` 走独立重载** |
| C5 | 只拦 `selector` 重载 + `UIAction` | `UIAction` **仍然触发** | 只拦一个必漏 |
| C6 | 两个重载都拦 + `UIAction` | `UIAction` 触发 `0` | **必须两个都 override** |
| C7 | 完整防重复（`interval=0.3`，注册 `touchUpInside` + `primaryActionTriggered`） | 3 次调用 → 业务增量 `1`、放行 `1`、拦截 `5` | 一次触摸派发 2 次，时间窗内只放行 1 次 |
| C9 | `interval = 0` | 业务增量 `1`、拦截 `0` | 不设间隔时零影响 |

> C7 的「拦截 5」说明：一次 `touchUpInside` 会同时触发注册在 `touchUpInside` 与
> `primaryActionTriggered` 上的动作 → 共 2 次 `sendAction`。时间窗内第二次被拦，这正是
> 「一次用户点击只触发一次业务」所需的效果。

### 3.2 计时粒度（clickprobe4）—— 方案 A 的硬缺陷

| 用例 | 场景 | 方案 A（全局单时间窗） | 方案 B（按业务动作计时） |
| --- | --- | --- | --- |
| D1/D2 | `.touchDown` 做按压反馈 + `.touchUpInside` 做业务，按住 0.05s | **`up = 0`（业务丢失）** | `down=1 up=1` ✅ |
| D3 | 同一 selector 注册在 `touchUpInside` + `primaryActionTriggered` | — | `up=1`、拦截键 `["onUp:"]` ✅ |
| D4 | 两个不同业务 selector | — | 各自放行一次 ✅ |
| D5 | 连续两次完整点击（< interval） | — | `down=1 up=1` ✅ |
| D6 | 拦截后等待超时再点 | — | 正常放行 ✅ |
| D8 | 两个按钮实例互不干扰 | — | ✅ |

**方案 A 被否决**：只要按钮同时注册了 `.touchDown`（按压反馈常规做法），
`touchDown` 会占用时间窗，导致 `.touchUpInside` 的业务动作被静默丢弃。

---

## 四、目标形态

单文件承载全部逻辑 —— `Sources/Fdy/Core/Components/FdyHitAreaButton.swift`：

```swift
open class FdyHitAreaButton: UIButton {
    // MARK: - 点击热区

    /// 向四周扩展的尺寸；`<= 0` 表示不扩展
    public var fdy_expandSize: CGFloat = 0

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard fdy_expandSize > 0 else { return super.point(inside: point, with: event) }
        return bounds.insetBy(dx: -fdy_expandSize, dy: -fdy_expandSize).contains(point)
    }

    // MARK: - 防重复点击

    /// 同一业务动作两次派发之间的最小间隔（秒）；`<= 0` 表示不限制
    public var fdy_repeatClickInterval: TimeInterval = 0

    /// 各业务动作上次派发的时刻；键 = selector 名 / `UIAction.identifier`
    private var fdy_lastFireTimes: [String: CFTimeInterval] = [:]

    override open func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        guard fdy_shouldFire(key: NSStringFromSelector(action)) else { return }
        super.sendAction(action, to: target, for: event)
    }

    override open func sendAction(_ action: UIAction) {
        guard fdy_shouldFire(key: action.identifier.rawValue) else { return }
        super.sendAction(action)
    }

    private func fdy_shouldFire(key: String) -> Bool {
        guard fdy_repeatClickInterval > 0 else { return true }
        let now = CACurrentMediaTime()
        if let last = fdy_lastFireTimes[key], now - last < fdy_repeatClickInterval { return false }
        fdy_lastFireTimes[key] = now
        return true
    }
}

// MARK: - 链式
public extension FdyWrapper where Base: FdyHitAreaButton {
    @discardableResult
    func expandClickArea(_ size: CGFloat = 10) -> Self { ... }

    @discardableResult
    func repeatClickInterval(_ interval: TimeInterval) -> Self { ... }
}
```

### 命名与默认值（拟）

| 项 | 拟用值 | 理由 |
| --- | --- | --- |
| 属性 | `fdy_repeatClickInterval: TimeInterval` | 与 `fdy_expandSize` 同风格；语义直白 |
| 链式 | `repeatClickInterval(_:)` | 与 `expandClickArea(_:)` 同层级 |
| 默认值 | `0`（不限制） | 属 opt-in 能力，不该改变既有按钮行为 |
| `expandClickArea` 默认 | `10` | 保持现状不动 |

---

## 五、改动清单

| 文件 | 动作 | 说明 |
| --- | --- | --- |
| `Core/Components/FdyHitAreaButton.swift` | **改写** | 承载两项能力 + 链式入口；顺带清掉末尾 09:38 被外部追加的 5 行空壳 `extension` |
| `Core/Extensions/UIKit/UIButton++.swift` | **删 3 段** | 删 `private extension UIButton { enum FdyKeys }`、`extension UIButton { override point(inside:) }`、`func fdy_expandClickArea(_:)`；**保留** `fdy_viewSize` |
| `Core/Chain/UIKit/UIButton+Chain.swift` | **删 2 段** | 删 `FdyWrapper<UIButton>.expandClickArea`（deprecated 版）与末尾 `FdyWrapper<FdyHitAreaButton>` 扩展（迁入 Components 文件） |
| `README.md` | **改 2 处** | 补防重复点击用法；把「全局入口已废弃」改为「已移除」 |

### 影响面（breaking change）

| 调用方 | 影响 |
| --- | --- |
| 库外 `anyUIButton.fdy.expandClickArea(_:)` | **编译错误** —— 这正是「外面不留」的目的 |
| 库外 `fdy_expandClickArea(_:)` | 无影响（它本就是 `internal`，库外调不到） |
| 库内 | **零引用**（已 grep 确认），无回归风险 |
| 全局副作用 | 删除类级注入后，UIKit 内部 `UIButton` 子类（`_UIStepperButton` 等）不再被注入 —— 顺带修掉一处全局污染 |

---

## 六、已知约束

| 约束 | 说明 |
| --- | --- |
| **工具链** | `sendAction` 的 `void` 声明在 **Xcode 26.2 与 27.0** 的 SDK 中均已确认。更早的 SDK（`BOOL` 返回）下本写法会编译失败 —— 本机无旧 SDK，未实测；如有旧工具链消费方需复核 |
| **最低运行版本** | iOS 18 起（`Package.swift` 声明），实测 iOS 18.0 与 26.5 行为逐行一致 |
| **真机 / 真实触摸** | 未验证 —— 触摸注入被系统权限拦（`osascript -10004`）。`sendActions(for:)` 与真实触摸在 `sendAction` 之后完全同路径，但 event 参数为 `nil`（真实触摸非 `nil`），当前实现不依赖该参数 |
| **线程** | `sendAction` 只在主线程触发；跨线程调 `sendActions(for:)` 不在保障范围（UIKit 本身非线程安全） |

---

## 七、落地记录（2026-09-17）

大人确认后已按上表命名与默认值落地，`Sources/` 改动如下：

| 文件 | 结果 |
| --- | --- |
| `Core/Components/FdyHitAreaButton.swift` | 承载 `fdy_expandSize` + `fdy_repeatClickInterval` + 两个 `sendAction` 重载 + 链式 `expandClickArea` / `repeatClickInterval`；末尾外部追加的空壳 `extension` 已清除 |
| `Core/Extensions/UIKit/UIButton++.swift` | 由 73 行缩至 20 行，仅保留 `fdy_viewSize` |
| `Core/Chain/UIKit/UIButton+Chain.swift` | 删掉 `FdyWrapper<UIButton>.expandClickArea` 与 `FdyWrapper<FdyHitAreaButton>` 扩展 |
| `README.md` | 补防重复点击用法；「入口已废弃」→「入口已移除」 |

### 验证结果

| 项 | 结果 |
| --- | --- |
| 整模块 `swiftc -typecheck`（251 文件） | **0 error / 0 warning** |
| `swiftformat --lint Sources/` | **0/251** |
| 行为回归（真实 Fdy 模块 + 探针 app，19 项） | **全部符合预期**，iOS 18.0 与 26.5 **逐行一致** |

关键证据：

| 编号 | 断言 | 结果 |
| --- | --- | --- |
| H4a | `UIButton` 自身方法表含 `pointInside:withEvent:` | **false** —— 类级注入已彻底移除 |
| H4c/d/e | `FdyHitAreaButton` 自身方法表含 `pointInside:withEvent:` / `sendAction:to:forEvent:` / `sendAction:` | **true** —— 三项都在类内 |
| H4g | 裸 `UIButton` 点 `x = -10` | **false** —— 全局热区不再存在 |
| H6 | `fdy_repeatClickInterval = 0.4` 连点三次 | 业务触发 **1** 次；等待 0.45s 后再点 → **2** 次 |
| H7 | `.touchDown` + `.touchUpInside` 组合（0.4s 窗） | `down=1 / up=1` —— 未互相挤占 |
| H8 | 同一 selector 注册 `touchUpInside` + `primaryActionTriggered` | 只放行 **1** 次 |
| H10 | `addAction(UIAction)` 连点两次 | 触发 **1** 次 |
| H12 | 二级子类 override `sendAction` + `super` | hook 2 次、业务 1 次 —— 防重复逻辑可被继承 |

### 库外 API 面收窄（`swiftc -typecheck` 实测）

| 调用 | 结果 |
| --- | --- |
| `FdyHitAreaButton().fdy.expandClickArea(10)` | 编译通过 |
| `FdyHitAreaButton().fdy.repeatClickInterval(0.3)` | 编译通过 |
| `UIButton().fdy.expandClickArea(10)` | `error: referencing instance method 'expandClickArea' on 'FdyWrapper' requires that 'UIButton' inherit from 'FdyHitAreaButton'` |
| `UIButton().fdy.repeatClickInterval(0.3)` | 同上 |
| `UIButton().fdy_expandClickArea(10)` | `error: value of type 'UIButton' has no member 'fdy_expandClickArea'` |

错误信息自带迁移指引，不需要额外文档说明改法。
