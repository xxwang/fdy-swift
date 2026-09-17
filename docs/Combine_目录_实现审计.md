# Combine 目录实现审计

> 排查范围：`Sources/Fdy/Combine/` 全部 13 个文件（543 行）。
> 方法：读源码 + 模拟器实测（iOS 26.5 iPhone 17 Pro / **iOS 18.0 iPhone 16 Pro 双运行时对照**）。
> 探针留档：`.build/probe/ime/App.swift`（文本通道）、`.build/probe/controls/App.swift`（值类控件）。
> **只做只读诊断，源码一行未动。**

## 一、结论：一个统一规律 + 两类缺陷

### 统一规律

**KVO 只覆盖「代码赋值」，控件事件/通知只覆盖「用户交互与 UIKit 内部变更」，两者互补且不重叠。**
库里每个属性**只挂了一路**，因此必然半边失明 —— 具体丢哪半边，逐类不同，必须实测。

实测的互补性（两个运行时一致）：

| 驱动方式 | KVO 通知 | `.valueChanged` |
| --- | --- | --- |
| `slider.value = 0.5`（公开 setter） | **是** | 否 |
| `seg.selectedSegmentIndex = 1` | **是** | 否 |
| `sendActions(for: .valueChanged)`（仅发事件） | 否 | **是** |
| `setValue(_:animated:)` / `setOn(_:animated:)` | **否** | **否** |

### 汇总表（每个 publisher 的覆盖与失明）

| 文件 | Publisher | 通道 | 已实测覆盖 | 已实测失明 | 证据强度 |
| --- | --- | --- | --- | --- | --- |
| `UILabel+Combine++` | `fdy_textPublisher` | KVO | 代码赋值 | 无（UILabel 无用户输入） | 读源码可判定 ✅ 不用改 |
| `UILabel+Combine++` | `fdy_attributedTextPublisher` | KVO | 代码赋值 | 同上 | 同上 |
| `UITextField+Combine++` | `fdy_textPublisher` | KVO | 代码赋值、`resign` 同步 | **逐键输入全盲** | 跨版本实测 |
| `UITextField+Combine++` | `fdy_attributedTextPublisher` | KVO | 同上 | 同上（未单独测，同构） | 推断 |
| `UITextView+Combine++` | `fdy_textPublisher` | KVO | 仅订阅初值 | **打字全程 0 次**（含 `resign`） | 跨版本实测 |
| `UITextView+Combine++` | `fdy_attributedTextPublisher` | KVO | 同上 | 同上（未单独测，同构） | 推断 |
| `UISlider+Combine++` | `fdy_valuePublisher` | KVO | `value = x` | **`setValue(_:animated:)`** | 跨版本实测 |
| `UISwitch+Combine++` | `fdy_isOnPublisher` | KVO | `isOn = x` | **`setOn(_:animated:)`** | 跨版本实测 |
| `UIStepper+Combine++` | `fdy_valuePublisher` | KVO | `value = x` | 用户点击（未验证） | 未验证 |
| `UISegmentedControl+Combine++` | `fdy_selectedSegmentIndexPublisher` | KVO | `selectedSegmentIndex = x` | 用户点击（未验证） | 未验证 |
| `UIScrollView+Combine++` | 8 个 delegate publisher | delegate 代理 | ✅ 动画滚动逐帧（20/21 帧）+ 动画结束 | — | 跨版本实测，**健康** |
| `UIControl+Combine++` | `fdy_publisher(for:)` 等 | target-action | ✅ | — | 读源码 + 用得上 |
| `UIView+Combine++` | 8 个手势 publisher | target-action | 未跑（无触摸注入手段） | — | 未验证 |

## 二、本轮新发现（与文本输入法无关）

### 2.1 `setValue(_:animated:)` / `setOn(_:animated:)` 是「无通知写入」——两个通道都不发

这是本次最实用的一条。**值确实变了，但没有任何通道通知。**

UISlider（iOS 26.5 与 18.0 逐行一致）：

| 步骤 | kvo | valueChanged | 读回的 `value` |
| --- | --- | --- | --- |
| 初始 | 1 | 0 | 0.0 |
| `value = 0.5`（公开 setter） | **2** | 0 | 0.5 |
| `setValue(0.6, animated: false)` | **2（不变）** | 0 | **0.6** |
| `setValue(0.9, animated: true)` | **2（不变）** | 0 | **0.9** |
| 等 0.8s 后再采样 | 2 | 0 | 0.9 |

UISwitch 同一模式：

| 步骤 | kvo | valueChanged | 读回的 `isOn` |
| --- | --- | --- | --- |
| `isOn = true`（公开 setter） | **2** | 0 | true |
| `setOn(false, animated: false)` | **2（不变）** | 0 | **false** |
| `setOn(true, animated: true)` | **2（不变）** | 0 | **true** |

结论：

- **不是「动画」的问题** —— `animated: false` 一样不发。原因是 `setValue(_:animated:)` /
  `setOn(_:animated:)` 是**独立方法**，不走 `value` / `isOn` 的 setter；
- 于是 `fdy_valuePublisher` / `fdy_isOnPublisher` 的订阅者会**一直持有过期值**，
  而控件本身已是新值。用于 `<<<` 双向绑定时会**把旧值写回去**；
- 补 `.valueChanged` 也救不了这一格 —— 实测它同样不发。

即：**只要用了这两个 animated setter，本库现有任何通道都观察不到。** 这是硬边界，只能靠接入方规避
（改用 `value = x` 后再自行 `sendActions`）或本库自行补 KVO 之外的手段。

### 2.2 「UIKit 内部路径绕过 KVO」的正面证据（仅 iOS 26.5，版本相关）

`UISlider.accessibilityIncrement()` 不是公开 setter，而是 UIKit 自己实现的值调整路径
（VoiceOver 走的那条），是本次能找到的、最接近「用户拖拽」的可编程代理：

| 运行时 | 调用前 | 调用后 | 说明 |
| --- | --- | --- | --- |
| iOS 26.5 | kvo=2 valueChanged=0 value=0.9 | **kvo=2 valueChanged=1 value=1.0** | 值变了、`.valueChanged` 发了、**KVO 没发** |
| iOS 18.0 | kvo=2 valueChanged=0 value=0.9 | kvo=2 valueChanged=0 value=0.9 | **空操作**，无数据 |

**这条只在 iOS 26.5 上成立，且是代理不是真实拖拽** —— 作为弱证据记录，不作为结论。
但它与 2.1 指向同一件事：KVO 在这些控件上不能假定「任何非 setter 写入都会通知」。

`UISwitch.accessibilityActivate()` 与 `UIStepper.accessibilityIncrement()` 两个运行时都无效果，无数据。

### 2.3 `UIScrollView` 是健康的那个

`contentOffset` 的 KVO **连动画内部路径都可靠**，与 UISlider 形成鲜明对照：

| 步骤 | kvo | delegate `didScroll` |
| --- | --- | --- |
| `contentOffset = (0,50)` | 2 | 1 |
| `setContentOffset((0,100), animated: false)` | 3 | 2 |
| `setContentOffset((0,300), animated: true)` + 跑动画 | **22**（逐帧） | **20**（逐帧） |
| 动画结束后 | 22 | 20（`didEndScrollingAnimation` = 1） |

iOS 18.0 同结构（23 / 21，仅帧数差 1）。

**两个结论**：
1. `ScrollViewDelegateProxy` 的代理设计**实测成立**，8 个 publisher 的事件源是通的；
2. `contentOffset` 的 KVO 可靠，但库里**没有**提供它的值 publisher —— 只有事件。
   这是功能缺口（`fdy_contentOffsetPublisher` 成本极低且有实测支撑）。

## 三、代码级缺陷清单（读源码即可确认，按严重度）

### D1（P0）`ScrollViewDelegateProxy` 缓存后不再同步 `delegate` —— 静默全面失效

`UIScrollView+Combine++.swift:75–83`：

```swift
if let existing = fdy_getAssociatedObject(forKey: &Self.cc_delegateProxyKey) as? ScrollViewDelegateProxy {
    return existing          // ← 直接返回缓存，不检查自己是否还是 delegate
}
let proxy = ScrollViewDelegateProxy()
proxy.originalDelegate = self.delegate
self.delegate = proxy
```

首次访问任一 `fdy_didScrollPublisher` 之类属性时，代理会**顶替**当前 delegate，此后：

- 接入方若再写 `scrollView.delegate = X`，代理被静默顶掉，**8 个 publisher 全部失效**，
  且再次访问只会拿到一个「已不是 delegate 的缓存代理」，**永远不恢复、无任何报错**；
- `originalDelegate` 是 `weak`，原 delegate 被释放后转发链断掉；
- 没有任何 `fdy_detach` 式 API 可以还原或主动刷新。

与 UITextField 的 KVO 失明**同构**：都是「静默失效」。

### D2（P0）每属性单通道 —— 半边失明

即第一节的统一规律，涉及 8 个文件。修法是一致的：**两路 merge + 去重**。

```swift
// 以 UISlider 为例（与文档《UITextField_Combine_监听时序实测》方案 2 同构）
var fdy_valuePublisher: ControlProperty<Float> {
    let set = publisher(for: \.value, options: [.new])                       // 代码赋值
    let used = fdy_publisher(for: .valueChanged)                             // 用户/内部
        .map { [weak self] _ in self?.value ?? 0 }
    let values = set
        .merge(with: used)
        .prepend(value)
        .removeDuplicates()                                                  // 见 D4
        .eraseToAnyPublisher()
    return ControlProperty(values: values, setter: { self.value = $0 })
}
```

### D3（P1）`SubscribePublisher` / `ControlEventSubscription` 忽略 demand

`Internals.swift:36` 的 `request(_ demand:)` 是空实现；三处构造点
（`UIControl+Combine++.swift:14`、`:29`、`UIView+Combine++.swift` 的 `cc_event`、`UIScrollView` 之外的
`fdy_publisher(for:)`）都是 `_ = subscriber.receive(...)`，**返回值（新增 demand）被丢弃**。

后果：下游请求 `.none` 时仍会收到值，违反 Combine 契约。多数下游请求 `.unlimited` 所以现在不炸，
但这是隐患；`prefix(1)` 这类限流算子依赖的是 `cancel()` 而非 demand，目前恰好能工作。

另外 `subscriber.receive(subscription:)` 是在 `addTarget` **之后**调用的，顺序反了
（标准做法是先给 subscription 再开始发事件），当前无害但不规范。

### D4（P1）`ControlProperty` 没有回声抑制 —— 修好 D2 后会激活双向绑定死循环

`ControlProperty+Combine++.swift` 提供 `bind(from:)` / `<<<` 写回控件，但**不回显抑制**。
链路：上游写回 → 控件发值 → 上游 `sink` 再写回 → ……

- **现在为什么没炸**：UITextField 的 KVO 对打字失明（D2），写回后 KVO 也不复用同一值重发，
  链路自己断了 —— 也就是说 **D2 的 bug 掩盖了 D4 的 bug**；
- **为什么必须一起修**：一旦按 D2 把 KVO 与事件 merge，写回会立刻被自己的通道观察到；
  若上游是 `@Published`（**不做去重**），就是无限循环。
  实测支撑：`resign` 时 KVO 会用**同一个值**重发一次（见文本探针 E1 行），必须由 `removeDuplicates()` 挡掉。

建议：把 `removeDuplicates()` 定为 `ControlProperty` 的默认语义并写进文档注释，
或在 `bind(from:)` 里做 echo 标记。

### D5（P2）同一模块内两套关联对象 helper 并存

| 位置 | API |
| --- | --- |
| `Combine/Internals.swift:43,52` | `fdy_setAssociatedObject(_:forKey:policy:)` / `fdy_getAssociatedObject(forKey:)` |
| `Core/Extensions/Foundation/NSObject++.swift:26,38,46` | `fdy_SetAO` / `fdy_GetAO<T>`（泛型）/ `fdy_GetAO`（`Any?`） |

`Internals.swift` 的注释理由是「避免依赖 FdyCore」，但 `Package.swift` 只有**单个 target `Fdy`** ——
`Core/` 与本目录**同属一个模块**，前提不成立。两套语义还不一致（Core 侧多一个泛型版）。
建议收敛为一套，否则后续谁也不知道该用哪个。

### D6（P2）`ScrollViewDelegateProxy.responds(to:)` 断言过宽 + `forwardingTarget` 无条件返回

`UIScrollView+Combine++.swift:22–31`：`super.responds(to:)` 为真即返回 `true`；
`forwardingTarget(for:)` 则**无条件**返回 `originalDelegate`（不检查其是否真的响应）。
原 delegate 也不实现的 selector 会被转发过去，最终以**原 delegate 的身份**抛
`unrecognized selector`，错误归属误导排查。

### D7（P2）`scrollViewDidEndDragging` 丢弃 `willDecelerate`，注释与实现不符

`UIScrollView+Combine++.swift:36–40` 把 `decelerate` 参数丢掉，publisher 类型是 `ControlEvent<Void>`，
而文档注释写「结束拖拽（**含是否将继续减速**）」。要么把 payload 改成 `Bool`，要么改注释。

### D8（P2）`ScrollViewDelegateProxy` 无前缀且是 internal

`final class ScrollViewDelegateProxy`（`UIScrollView+Combine++.swift:8`）既无 `private` 也无 `fdy_` 前缀，
作为库会以 internal 名义暴露；与其他库里同名类型有冲突风险。`ClosureTarget`、
`ControlEventSubscription` 同理（后者语义上是内部实现，却被 `ControlEvent` 的构造路径依赖）。

### D9（P2）`UIView+Combine++` 的 getter 有副作用，且手势缓存不可扩展

- 读 `fdy_tapGesturePublisher` 这个**属性**会 ① 永久把 `isUserInteractionEnabled` 改成 `true`；
  ② 首次读就 `addGestureRecognizer` 并缓存。getter 有不可撤销的写副作用。
- `cc_cachedGesture(key:make:)` 按字符串 key 缓存（`"tap"` / `"swipe-\(rawValue)"` / …），
  **同一类型无法注册多个不同配置的识别器**（例如单击与双击两个 tap）。
- `cc_event` 每次订阅给同一识别器加一个 `ClosureTarget`，多订阅者共用同一识别器 ——
  这本身是设计选择，但没有任何文档说明。

### D10（P3）关联键 `static var UInt8` 的 Swift 6 阻塞

本目录 2 处：`UIScrollView+Combine++.swift:74` 的 `cc_delegateProxyKey`、
`UIView+Combine++.swift:7` 的 `cc_gestureCacheKey`。
与《UIButton_Extensions_优化方案》P1-4 同源（全库 9 处 / 7 个文件，其中 Combine 目录占 2 个文件），
修法同为 `nonisolated(unsafe)`。**不重复展开，按那份方案的批次 1 一起做即可。**

## 四、明确的健康项（不用动）

- `UIScrollView+Combine++.swift` 的 delegate 代理**实测有效**（逐帧 20/21 次 + 动画结束 1 次）。
- `UIScrollView.contentOffset` 的 KVO **连动画内部路径都可靠** —— 与 UISlider 相反，
  说明「KVO 是否可靠」是**逐类实测结论，不能靠推理推广**。
- `UILabel+Combine++.swift` 的注释「**代码赋值**会发出」是**准确**的 ——
  全目录唯一一个注释与实现相符的文件（对比 `UITextField+Combine++.swift` 写「用户编辑与代码赋值均会发出」，
  前半句是错的）。这恰好说明作者知道 UILabel 与 UITextField 的差别，只是漏在了实现上。
- `UIControl+Combine++.swift` 的 target-action 桥接本身没问题：`addTarget`/`removeTarget`
  配对、`[weak self]` 到位、取消时清理，无泄漏。`fdy_valueChangedPublisher` 正是 D2 的解药，已经现成。

## 五、未验证项（不能算结论）

1. **四个值控件的真实用户点击/拖拽是否通知 KVO** —— 需要触摸注入。
   尝试用 `osascript … System Events keystroke` 注入真实按键被系统权限拦下（`-10004`），
   触摸同理未做。**这是本次最大的空白**：它决定 D2 对 `UIStepper` / `UISegmentedControl` 的实际严重程度。
   `setValue(_:animated:)` 的实测（2.1）是间接旁证，不是直接证据。
2. **`UIStepper` / `UISegmentedControl` 的内部路径** —— 没有任何可编程代理能触发（`accessibilityIncrement` 无效）。
3. **`UIView+Combine++` 的 8 个手势 publisher** —— 同样需要触摸注入，本次一条都没跑。
4. **`UITextView` 的代码赋值是否发 KVO** —— 本次只测了打字与 `resign`，未测 `tv.text = x`。
5. **D4 的 Merge 修法本身** —— 未实测，是从单通道数据推导的。

## 六、复跑方式

```bash
# 值类控件
cd .build/probe/controls
xcrun -sdk iphonesimulator swiftc -target arm64-apple-ios15.0-simulator \
  -parse-as-library App.swift -o Probe
mkdir -p Probe.app && cp Probe Probe.app/ && cp Info.plist Probe.app/Info.plist
U=21956BBD-1171-453D-B94E-0D06CFA3F350     # iPhone 17 Pro / iOS 26.5
xcrun simctl boot $U && xcrun simctl install $U ./Probe.app
xcrun simctl launch --console-pty $U com.wbtest.controls
```

iOS 18.0 对照设备：`897DFB7B-177D-4A9A-9C1B-B924C3EA9DF5`。
文本通道探针见 `.build/probe/ime/`（另外的 bundle id `com.wbtest.imetime`）。
