# Combine 目录 修复与优化方案

> 依据：[《Combine 目录实现审计》](./Combine_目录_实现审计.md) 的 10 条缺陷 + 5 条未验证项。
> 本轮做的事：**把每条结论落成补丁，再用模拟器实测验证修法本身成立**（不靠推导）。
> 状态：**源码一行未动**。补丁在模块副本上生成并验证。
>
> - 补丁：`docs/Combine_目录_修复优化方案.patch` —— 11 文件，+300 / −109，`git apply --check` 通过
> - 探针：`.build/probe/combinefix/App.swift` —— T1–T7 覆盖 7 类修法，含「现状 vs 修复」并排对照
> - 实测环境：iPhone 17 Pro / **iOS 26.5** 与 iPhone 16 Pro / **iOS 18.0**，两版本结果**逐位一致**

## 一、一句话结论

审计里的 10 条缺陷，**7 条可以在不改任何公开 API 签名的前提下修掉**，且每条都有实测支撑；
剩下 3 条属于「需要拍板的语义变更」或「需要补 API」。

核心修法只有一个动作：**把「每属性单通道」换成「两路 merge + 去重」**，再补上 subscription 的
demand 语义、代理的重新接管、以及 animated setter 的补发。

## 二、修法验证结果（先看证据）

探针 T1–T7 全部在 iOS 26.5 与 18.0 上跑了一遍，输出一致。

| 用例 | 现状实现 | 候选修复实现 | 判定 |
| --- | --- | --- | --- |
| **T1** 文本逐键 | KVO 整场 4 次（仅代码赋值 + resign 同步） | merged 逐键即时：`["", "a", "ab", "abn", "abnni", "abn你好", "abn你好shi", "代码赋值", "代码赋值z"]` | ✅ 修好 |
| **T1-4A** 完成态 `resign` | KVO +1 次（同值重发） | merged 增量 **0** —— 被 `removeDuplicates()` 挡掉 | ✅ 必要性坐实 |
| **T1-4B** 组字中 `resign` | KVO +1 次（同值） | merged 增量 **0** | ✅ 同上 |
| **T2** 回声抑制 | 双向绑定**写回 30 次触顶**（= 死循环） | 写回 **2 次收敛** | ✅ `removeDuplicates()` 是前提，非优化 |
| **T3** UITextView 打字 | KVO 仅 1 次（订阅初值） | merged 逐键：`["", "a", "ab", "abnihao", "ab你好", "代码赋值"]` | ✅ 修好 |
| **T4** `attributedText` 去重 | （原实现无去重） | `isEqual` 比较生效：同内容新实例被抑制 | ✅ 可行 |
| **T5** slider 值流 | `setValue(0.6/0.7, animated:)` 两通道皆无 | 补 `sendActions` 后 `0.9` 到手 → merged `["0.0","0.5","0.9"]` | ✅ 补发有效 |
| **T5** switch | `setOn(true, animated:)` 两通道皆无 | 补 `sendActions` 后 merged 收到 `true` | ✅ 补发有效 |
| **T5** stepper / segmented | — | `[0.0, 3.0]` / `[-1, 2]`，同值两路被去重 | ✅ 去重有效 |
| **T5** 订阅初值重放 | 现有行为 | 新订阅立即收到当前值一次 | ✅ 未回归 |
| **T6** demand | `demand = .none` 仍投递 **1 次**（违约） | 投递 **0 次**；`request(.max(2))` 后连发 3 次只收到 2 次 | ✅ 修好 |
| **T7** 滚动代理 | 被顶掉后 `didScroll` **0 次**，永不恢复 | 重新接管后 **1 次**，且外部 delegate 被转发 **1 次** | ✅ 修好 |
| **编译** | — | 250 文件整模块类型检查 **0 error / 0 warning**；`static var UInt8` 关联键 **9 → 7** | ✅ 补丁可编译 |

> T2 的 30 次是探针设的上限，不是收敛值 —— 它就是死循环。

## 三、逐条修法

### 3.1 D2（P0）每属性单通道 → 两路 merge + 去重

**改动文件**：`UITextField` / `UITextView` / `UISlider` / `UISwitch` / `UIStepper` / `UISegmentedControl`（6 个）。

以 `UITextField` 为例：

```swift
// 现状：只有 KVO 一路 —— 用户打字全程失明
var fdy_textPublisher: ControlProperty<String?> {
    ControlProperty(
        values: publisher(for: \.text, options: [.initial, .new]).eraseToAnyPublisher(),
        setter: { self.text = $0 }
    )
}

// 修复：属性通道（代码赋值）+ 事件通道（用户输入）+ 去重
var fdy_textPublisher: ControlProperty<String?> {
    let assigned = publisher(for: \.text, options: [.initial, .new])
    let typed = fdy_publisher(for: .editingChanged).map { [weak self] _ in self?.text }
    return ControlProperty(
        values: assigned.merge(with: typed).removeDuplicates().eraseToAnyPublisher(),
        setter: { [weak self] in self?.text = $0 }
    )
}
```

四条要点：

1. **`.initial` 保留**，所以「订阅立即重放当前值」的既有语义不变（T5-replay 已复核）。
2. **`UITextView` 没有 `.editingChanged`**（它不是 `UIControl`），事件通道改用
   `NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)`
   —— 实测逐键触发、含组字期。
3. **`attributedText` 不能用 `removeDuplicates()`**（`NSAttributedString` 不是 `Equatable`，编译不过），
   改用 `removeDuplicates { $0.isEqual($1) }` 形式 —— 实测同内容新实例被正确抑制（T4）。
4. **setter 改 `[weak self]`**：现状 `{ self.text = $0 }` 会让 `ControlProperty` 强持有控件。
   顺带说明：KVO 的 `publisher(for:)` 本身也强持有对象，所以订阅存活期间控件不会被释放 ——
   这类「订阅即持有」是既有事实，本轮不改语义，只把 setter 的强持有去掉。

**这一条顺带消灭了一个未知项**：审计未验证「用户点击 `UIStepper` / `UISegmentedControl` 是否通知 KVO」。
两路都挂上以后，**只要两路中有一路触发就能收到** —— 该未知不再影响功能正确性
（唯一例外是两路都不发的 animated setter，见 3.6）。

### 3.2 D4（P1）回声抑制 → 以 `removeDuplicates()` 为默认语义

现状「没炸」是因为 D2 的 bug 把写回链路自己切断了；**修 D2 就会激活死循环**（T2 实测：无去重写回 30 次触顶）。
因此 `removeDuplicates()` 不是可选优化，是修 D2 的前置条件。

- **行为变更**：赋**同一个值**不再重复发出。`UILabel` 也一并统一到该语义（现状 `label.text = "a"` 连写两次会发两次）。
- 依赖「每次赋值都要触发一次」的场景（例如靠赋值驱动动画）应改用事件通道，而不是值流。
- 文档注释里写明该语义，避免接入方踩到。

`bind(from:)` 保持不动：值流的去重已经足够阻断回声，再加一层写回比对会引入新的「静默丢弃」语义。

### 3.3 D3（P1）subscription：demand 计数 + 订阅顺序

**改动文件**：`Internals.swift`（`ControlEventSubscription` 重写）、`UIControl+Combine++.swift`、`UIView+Combine++.swift`。

```swift
final class ControlEventSubscription: Subscription {
    let target = ClosureTarget()
    var deliver: (() -> Subscribers.Demand)?      // 投递一次事件，返回下游新增 demand
    var cancelled: Bool { isCancelled }

    private var demand: Subscribers.Demand = .none
    private var isCancelled = false
    private let cleanup: (ClosureTarget) -> Void

    init(cleanup: @escaping (ClosureTarget) -> Void) {
        self.cleanup = cleanup
        target.onInvoke = { [weak self] in self?.flush() }   // 弱引用回指，避免 target↔subscription 环
    }

    func request(_ demand: Subscribers.Demand) {
        guard !isCancelled else { return }
        self.demand += demand
    }

    func cancel() {
        guard !isCancelled else { return }
        isCancelled = true
        target.onInvoke = nil
        deliver = nil                                        // 断开对下游的强引用
        cleanup(target)
    }

    private func flush() {
        guard !isCancelled, demand > 0 else { return }
        demand -= 1
        demand += deliver?() ?? .none
    }
}
```

构造点同步改为「**先交付 subscription，再挂 target**」，并补上竞态判断：

```swift
subscriber.receive(subscription: subscription)   // 顺序修正（初版在 addTarget 之后）
guard !subscription.cancelled else { return }    // 订阅方可能在 receive(subscription:) 内就取消
self.addTarget(subscription.target, action: #selector(ClosureTarget.invoke), for: events)
```

**副作用提醒**：demand 语义变严后，**订阅了但从不 `request` 的下游将收不到事件**。这是 Combine 契约的正确行为；
若接入方自己手写了 `Subscriber` 却忘了 `request(.unlimited)`，修复后会「静默收不到」——这是从「违约投递」变成「合规不投递」，
需要写进迁移说明。

### 3.4 D1（P0）滚动代理被顶掉后重新接管

```swift
private var cc_delegateProxy: FdyScrollViewDelegateProxy {
    if let existing = fdy_GetAO(forKey: &Self.cc_delegateProxyKey) as? FdyScrollViewDelegateProxy {
        let isAlreadyAttached = (delegate as AnyObject?) === existing
        if !isAlreadyAttached {
            existing.originalDelegate = delegate   // 把接入方新设的 delegate 记为转发目标
            delegate = existing                    // 重新接管
        }
        return existing
    }
    let proxy = FdyScrollViewDelegateProxy()
    proxy.originalDelegate = delegate
    delegate = proxy
    fdy_SetAO(proxy, forKey: &Self.cc_delegateProxyKey)
    return proxy
}
```

- 实测（T7）：初版被顶掉后 `didScroll` 0 次且永不恢复；修复版重新接管后 1 次，外部 delegate 也被正常转发 1 次。
- **残余限制（写进文档，不改）**：接管动作发生在**再次访问 publisher 属性**时。若接入方设完 `delegate` 就再也不碰 fdy 的
  publisher，订阅仍会停摆。彻底解法是提供 `fdy_attachScrollDelegateProxy()` 显式接管 API，但那会鼓励
  「库替接入方管 delegate」的用法 —— 我倾向**保持隐式接管 + 明确文档**。
- `responds(to:)` 保留；`forwardingTarget(for:)` 补上「原 delegate 确实响应才转发」的判断，避免以原 delegate 身份抛
  `unrecognized selector`（错误归属误导排查）。

### 3.5 D5 / D6 / D7 / D8 / D10

| 项 | 改法 |
| --- | --- |
| **D5** 两套关联对象 helper | 删掉 `Internals.swift` 里的 `fdy_setAssociatedObject` / `fdy_getAssociatedObject`，统一用 `Core` 的 `fdy_SetAO` / `fdy_GetAO`（含泛型版，省掉手写 `as?`） |
| **D6** `forwardingTarget` 无条件转发 | 改为 `if let originalDelegate, originalDelegate.responds(to: aSelector)` 才转发；原 delegate 是 `weak`，释放后转发链自然断开（写进注释） |
| **D7** `willDecelerate` 被丢弃 | 内部 subject 改为 `PassthroughSubject<Bool, Never>`；**新增** `fdy_didEndDraggingWithDecelerationPublisher: ControlEvent<Bool>`，老 publisher 改为 `.map { _ in () }` 并修正注释 —— **零破坏**（备选：直接把老 publisher 载荷改 `Bool`，但会破坏既有调用点） |
| **D8** 代理类型无前缀且 internal | `ScrollViewDelegateProxy` → `private final class FdyScrollViewDelegateProxy`（仅本文件使用） |
| **D10** `static var UInt8` 关联键 | Combine 目录 2 处加 `nonisolated(unsafe)`（与《UIButton_Extensions_优化方案》P1-4 同一批，全库 9 → 7 处） |

### 3.6 animated setter：硬边界 + 补发 API

`setValue(_:animated:)` / `setOn(_:animated:)` 实测**两个通道都不发**（`animated: false` 同样不发，与动画无关），
merge 也救不了 —— 唯一解是调用方在赋值后补发事件。所以补两个薄封装：

```swift
/// 原生 setValue(_:animated:) 不发任何通知，订阅者会一直持有过期值
func fdy_setValue(_ value: Float, animated: Bool) {
    setValue(value, animated: animated)
    sendActions(for: .valueChanged)
}
// UISwitch 同理：fdy_setOn(_:animated:)
```

- 实测有效：补发后 merged 流拿到 `0.9` / `true`（T5）。
- 副作用：事件会被**所有** `.valueChanged` 监听者收到（含接入方自己 `addTarget` 的），需在注释写明。

## 四、批次与推进顺序

| 批次 | 内容 | 破坏性 | 文件 |
| --- | --- | --- | --- |
| **A** | D2 两路 merge + D4 去重 + D3 demand/顺序 + D1 代理接管 + D5/D6/D8/D10 | 公开签名**零变更**；行为变更 2 处（用户输入开始发值 = 修复；同值不再重发 = 见 §5 决策 1） | 10 |
| **B** | 新增 `fdy_contentOffsetPublisher`、`fdy_didEndDraggingWithDecelerationPublisher`、`fdy_tapGesturePublisher(numberOfTaps:)`、`fdy_setValue(_:animated:)`、`fdy_setOn(_:animated:)`；README 补文档 | 纯新增，**零破坏** | 4 + README |
| **C** | 可选清理：`Combine` 目录私有符号的 `cc_` 前缀统一为 `fdy_`；`fdy_tapPublisher` 复用 `fdy_publisher(for:)`（已在补丁中） | 无公开影响 | — |
| **D** | 补齐验证空白：`UIStepper`/`UISegmentedControl` 真实点击、`UIView` 手势 publisher —— 需要 XCUITest 触摸注入 | 无代码影响 | — |

补丁已包含 **A + B**。C 的一部分（`fdy_tapPublisher` 复用）也已在补丁里；其余前缀统一建议单独一次
「只改名」提交，便于 review。

**README 需要同步的内容**（批次 B 附带）：新增的 5 个 API、`setValue(_:animated:)` 不发通知的硬边界、
`ControlProperty` 的「同值不重发」语义、以及 `UIScrollView` 代理的接管说明。

## 五、需要大人拍板的 3 件事

| # | 决策 | 我的建议 |
| --- | --- | --- |
| 1 | `removeDuplicates` 是否定为 `ControlProperty` 的统一语义（**同值赋值不再重发**，`UILabel` 也受影响） | **要**。它是回声抑制的前提，T2 已实测；否则修完 D2 立刻死循环 |
| 2 | `fdy_didEndDraggingPublisher` 的载荷：加新 publisher（零破坏）还是直接把老的改成 `ControlEvent<Bool>`（更干净但破坏调用点） | 补丁里走的是**加新 publisher**；若这个库还没有外部使用方，直接改老的更干净 |
| 3 | 是否保留 `fdy_setValue(_:animated:)` / `fdy_setOn(_:animated:)` 这类「补发事件」封装 | **保留**。实测是唯一能覆盖 animated setter 的手段；命名上 `fdy_` 前缀与原生 `setValue` 并列不冲突 |

## 六、验收标准（可复跑）

```bash
cd <repo>

# 1) 整模块类型检查（基线：0 error / 0 warning）
SDK=$(xcrun --sdk iphonesimulator --show-sdk-path)
find Sources/Fdy -name '*.swift' | sort > .build/fixcheck/sources.txt
xcrun --sdk iphonesimulator swiftc -typecheck -target arm64-apple-ios18.0-simulator \
  -sdk "$SDK" -swift-version 5 -module-name Fdy @.build/fixcheck/sources.txt

# 2) 补丁可应用性（不落盘）
git apply --check -p1 docs/Combine_目录_修复优化方案.patch

# 3) 行为回归探针（T1–T7，逐条对照本文表格）
cd .build/probe/combinefix
xcrun -sdk iphonesimulator swiftc -target arm64-apple-ios18.0-simulator -parse-as-library App.swift -o Probe
mkdir -p Probe.app && cp Probe Probe.app/ && cp Info.plist Probe.app/Info.plist
U=21956BBD-1171-453D-B94E-0D06CFA3F350     # iPhone 17 Pro / iOS 26.5
xcrun simctl boot $U; xcrun simctl install $U ./Probe.app
xcrun simctl launch --console-pty $U com.wbtest.combinefix
```

iOS 18.0 对照设备：`897DFB7B-177D-4A9A-9C1B-B924C3EA9DF5`（本轮已跑，结果一致）。

## 七、仍未验证 / 不在本方案内

1. **`UIStepper` / `UISegmentedControl` 真实点击是否通知 KVO**、`UIView` 的 8 个手势 publisher ——
   仍需触摸注入（XCUITest）。§3.1 说明了两路合并后该未知**不再影响正确性**，但若要写进文档当结论，得补测。
2. **真机复核**：本轮全部数据来自模拟器。
3. **Swift 6 语言模式**：修掉 Combine 的 2 处关联键只是**必要条件之一**。实测 `-swift-version 6` 下整模块的
   **第一个拦路虎不在 Combine**，而是 `Core/Common/FdyAppearance.swift:5`：
   `static property 'shared' is not concurrency-safe because non-'Sendable' type 'FdyAppearance' may have shared mutable state`。
   也就是说 Swift 6 迁移是独立一条线，别指望「修完 Combine 就能切」。
4. **`UIView+Combine++` 的 `isUserInteractionEnabled = true` 写副作用**：本轮**未改**（改动语义有破坏风险），
   只在文档注释里写明。若要去掉，需要新增显式 API 或让调用方自己开。
5. **`ControlProperty` 是否该提供「不过滤的原始流」**：现状是值流一律去重，若后续有场景需要「每次赋值都收到」，
   需要另开一个 event 类 publisher —— 本轮不做。

## 八、落地记录（2026-09-16，分支 `Swift6`）

补丁已应用到 `Sources/`。`git diff --stat`：**11 files changed, +292 / −99**，全部在 `Sources/Fdy/Combine/`。
撤销方式：`git apply -R -p1 docs/Combine_目录_修复优化方案.patch`（已 `--check` 通过）。

### 8.1 落盘四道验证

| # | 验证 | 结果 |
| --- | --- | --- |
| 1 | `diff -rq Sources/Fdy .build/patchcheck/Fdy`（与先前通过编译的副本逐字节比对） | 完全一致 |
| 2 | 整模块类型检查（`-swift-version 5`，250 文件，与基线同参数） | **0 error / 0 warning** |
| 3 | `swiftformat --lint Sources/` | 基线 0/250；落盘后曾出现 **3 处**（见 8.3），已修 → **0/250** |
| 4 | 真实模块回归（`import Fdy`，见 8.2） | R1–R8 全部符合预期；iOS 18.0 与 26.5 逐行一致 |

### 8.2 本轮回归方式升级：跑真实模块，而非复刻实现

上一轮（`.build/probe/combinefix`）是「把现状实现与候选修复实现都复刻进探针并排跑」，
它证明的是**修法成立**，不等于**落地代码正确**。本轮改为把 `Sources/Fdy` 编译成
iOS 模拟器动态库、探针 `import Fdy` 只调公开 API，测的是要真正发布的代码：

```bash
# 1) 把真实模块编译成库（install_name 必须改成 @rpath，否则探针会去找构建期相对路径）
SDK=$(xcrun --sdk iphonesimulator --show-sdk-path)
xcrun --sdk iphonesimulator swiftc -emit-library -emit-module -module-name Fdy \
  -target arm64-apple-ios18.0-simulator -sdk "$SDK" -swift-version 5 \
  -emit-module-path .build/regress/lib/Fdy.swiftmodule \
  -Xlinker -install_name -Xlinker @rpath/libFdy.dylib \
  -o .build/regress/lib/libFdy.dylib @.build/fixcheck/sources-after.txt

# 2) 编译探针（dylib 放进 app 内 Frameworks）
cd .build/regress
xcrun --sdk iphonesimulator swiftc -target arm64-apple-ios18.0-simulator -sdk "$SDK" \
  -swift-version 5 -parse-as-library -I lib -L lib -lFdy \
  -Xlinker -rpath -Xlinker @executable_path/Frameworks App.swift -o Probe
mkdir -p Probe.app/Frameworks && cp Probe Probe.app/ && cp Info.plist Probe.app/Info.plist \
  && cp lib/libFdy.dylib Probe.app/Frameworks/
codesign --force --sign - Probe.app/Frameworks/libFdy.dylib; codesign --force --sign - Probe.app

# 3) 跑
U=21956BBD-1171-453D-B94E-0D06CFA3F350     # iPhone 17 Pro / iOS 26.5
xcrun simctl install $U ./Probe.app && xcrun simctl launch --console-pty $U com.wbtest.regress
```

| 用例 | 落地代码实测结果 |
| --- | --- |
| R1 `UITextField.fdy_textPublisher` | 逐键 `["", "a", "ab", "abni", "ab你好", "代码赋值"]`；`resign` 时裸 KVO `1→2` 次而真实通道 **0 增量**（去重挡住 UIKit 的同步写回）；同值重赋 0 增量 |
| R2 回声抑制 | 上游发 1 次 → 写回 **2 次后收敛**（上限 30）；最终 `text == "hello"` |
| R3 `UITextView.fdy_textPublisher` | 逐键 `["", "a", "ab", "abnihao", "ab你好", "代码赋值"]`；裸 KVO 整场仅 2 次（印证「KVO 对 UITextView 完全失明」） |
| R4 `fdy_attributedTextPublisher` | 订阅=1 / 首次赋值=2 / **同内容新实例=2** / 不同内容=3 → `isEqual` 去重生效 |
| R5 值类控件 | 原生 `setValue(0.6/0.7, animated:)` 与 `setOn(_, animated:)` 增量均为 **0**（已知缺口）；`fdy_setValue(0.9, animated:)` 收到 `0.9`；`fdy_setOn` 依次收到 `true`/`false`；`UIStepper` → `[0.0, 3.0]`；`UISegmentedControl` → `[-1, 2]`，同值补发被去重抑制 |
| R6 demand 契约 | 未 `request` 时连发 2 次收到 **0**；`request(.max(2))` 后连发 3 次收到 **2**（超出被丢弃） |
| R7 滚动代理 | 首次订阅后 publisher 1 次 + 原 delegate 被转发 1 次；被外部顶替后增量 **0**；再次访问 publisher 后**自动重新接管**（增量 2 = 两个订阅者各 1） |
| R8 `fdy_contentOffsetPublisher`（新增） | 订阅重放 1 次；直接赋值 1 次；`setContentOffset(animated:)` 期间 **19 帧**；`bind(from:)` 写回成功 |

iOS 18.0（`897DFB7B-177D-4A9A-9C1B-B924C3EA9DF5`）复跑：**52 行有效输出中仅 `runtime` 一行不同**，其余逐字节一致。

### 8.3 落盘时修掉的三处格式化问题

补丁是我的手写产物，落盘后 `swiftformat` 报了 3 处（基线 0 处，即全部由本补丁引入），已修：

| 文件 | 规则 | 改法 |
| --- | --- | --- |
| `Internals.swift:38` | `wrapPropertyBodies` | `var cancelled: Bool { isCancelled }` → 展开为多行 |
| `UIView+Combine++.swift:7` | `modifierOrder` | `nonisolated(unsafe) private static` → `private nonisolated(unsafe) static` |
| `UIScrollView+Combine++.swift:87` | `modifierOrder` | 同上 |

格式化后重跑类型检查（0/0）与 R1–R8 回归，**52 行输出与格式化前逐字节一致** —— 纯样式改动，无行为影响。

### 8.4 对 §七第 3 条（Swift 6）的重要澄清

§七第 3 条那句「Swift 6 迁移是独立一条线」**成立，但本轮发现之前的判断方式有缺陷**，必须更正：

- 整模块跑 `-swift-version 6`，补丁前后都是 **1 error / 922 warnings**，且逐条诊断集合**完全一致**。
  这看起来像「补丁对 v6 毫无影响」，但**是假象**：编译在 `Core/Common/FdyAppearance.swift:5` 的
  首个 error 处**中止**，而 `Core/Extensions/`（关联键所在目录）按文件序排在最后，
  该目录**一条诊断都没产出**（`grep -cE '^Sources/Fdy/Core/Extensions/.*: (error|warning):'` = 0）。
- 用**真实 UIKit 结构**单独复现（而非上一轮的顶层 `enum FdyKeys` 写法）：

  ```swift
  import UIKit
  public extension UIButton {
      fileprivate enum FdyKeys {
          static var expandSizeKey: UInt8 = 0
      }
  }
  ```
  在 `-swift-version 6` 下**确实报** `#MutableGlobalVariable`；加 `nonisolated(unsafe)` 后干净。
  所以「关联键是 v6 阻塞」的结论**仍然成立**，只是证据从「顶层片段」换成了「真实声明结构」。
- 解除首阻塞后**串出下一个**：`FdyHelper.shared`、`FdyPath.shared`…共 **12 个**非 Sendable 单例
  （`grep -rn "static let shared"`）。把它们一律加 `nonisolated(unsafe)` 会在 `FdyHaptic` 上撞到
  `main actor-isolated default value in a nonisolated(unsafe) context` —— 说明**单例这条线要逐个按语义处理**
  （`@MainActor` / `Sendable` / 初始化隔离），不是批量替换。
- **结论**：本补丁把关联键从 9 处减到 7 处，属于 v6 迁移的必要准备，但 v6 是独立工作项，
  且它第一道门是**单例的隔离语义**，不是关联键。

---

## 九、批次 C / D 状态（2026-09-17，分支 `Swift6`）

### 9.1 批次 C 已落地：`cc_` 前缀统一为 `fdy_`

纯改名，**无公开影响**（29 处，全部是 `private` 成员）：

| 文件 | 旧名 → 新名 |
| --- | --- |
| `UIView+Combine++.swift` | `cc_gestureCacheKey` / `cc_gestureCache` / `cc_cachedGesture` / `cc_event` → `fdy_` 同后缀 |
| `UIScrollView+Combine++.swift` | `cc_delegateProxyKey` / `cc_delegateProxy` → `fdy_` 同后缀 |

`grep -rn "cc_" Sources/` 计数 **0**；整模块 `-typecheck`（251 文件）**0 error / 0 warning**；
`swiftformat --lint Sources/` **0 / 251**。

### 9.2 批次 B 的 README 已同步

`README.md` 的 `## CombineCocoa` 段补齐：新增的 5 个 API、`removeDuplicates` 的「同值不重发」语义、
文本输入逐键实时的原因、原生 animated setter 两个通道都不发通知的硬边界、滚动代理的接管与重新接管行为，
以及 `slider.fdy_setValue(0.9, animated:)` / `switchView.fdy_setOn(true, animated:)` 两个示例。

### 9.3 批次 D 仍未做（环境阻塞）

`UIStepper` / `UISegmentedControl` 的真实点击、8 个手势 publisher 的真实触发，需要 **XCUITest 触摸注入**
或向 Simulator 窗口投递系统级事件。本机沙箱下：

- `osascript … System Events` 被系统权限拦下（`-10004`）；
- `simctl` 本身不提供触摸注入子命令。

故本条继续挂起。可用的替代（成本更高）是建一个最小 Xcode 工程跑 `xcodebuild test`。
本轮对 `UIStepper` / `UISegmentedControl` 的覆盖仍是**程序化写值**（`R5` 用例），不是真实点击。
