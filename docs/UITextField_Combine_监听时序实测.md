# UITextField / UITextView 文本监听「不即时」根因实测

> 结论基于 iOS 26.5（iPhone 17 Pro）与 iOS 18.0（iPhone 16 Pro）双运行时实测，
> 两者**逐位一致** —— 这是 iOS 15 时代的既有语义，不是新系统的行为变化。
> 探针留档：`.build/probe/ime/App.swift`。

## 一、问题复述

`Sources/Fdy/Combine/UITextField+Combine++.swift` 的 `fdy_textPublisher`
（以及 `UITextView+Combine++.swift` 的同名属性）在用户输入时**不即时**触发，
要等到「停止输入」才收到内容。

## 二、根因：KVO 只能观察到 `setText:`，而打字不走 setText

两个属性都用了同一条路径：

```swift
values: publisher(for: \.text, options: [.initial, .new]).eraseToAnyPublisher()
```

KVO 观察的是**属性的 setter**。而 `UITextField` / `UITextView` 在用户打字时，
文本由 UIKit 的文本输入系统（`UIKeyInput` / TextKit）直接写入内部存储，
**不经过 `text` 属性的 setter**。因此 KVO 收不到。

真正会走 `setText:` 的只有两种情形：

1. **代码赋值** —— `textField.text = "..."`；
2. **`UITextField` 结束编辑** —— `resignFirstResponder()` 时 UIKit 把内部文本同步回属性。

第 2 条正是「停止输入才收到内容」的来源。`UITextView` 连第 2 条都没有。

## 三、实测数据

### UITextField（四条通道计数）

`kvo` = `publisher(for: \.text)`，`editingChanged` = `addTarget(.editingChanged)`，
`notif` = `UITextField.textDidChangeNotification`，`delegate` = `shouldChangeCharactersIn`。

| 步骤 | `text` 取值 | `markedTextRange` | kvo | editingChanged | notif | delegate |
| --- | --- | --- | --- | --- | --- | --- |
| S0 初始 | `""` | no | 1 | 0 | 0 | 0 |
| F1 `insertText("a")` | `"a"` | no | 1 | 1 | 1 | 0 |
| F2 `insertText("b")` | `"ab"` | no | 1 | 2 | 2 | 0 |
| F3 `tf.text = ""` | `""` | no | **2** | 2 | 2 | 0 |
| M1–M5 `setMarkedText` n→nihao | `"n"`…`"nihao"` | **YES** | 2 | 3→7 | 3→7 | 0 |
| C1 `insertText("你好")` 上屏 | `"你好"` | no | 2 | 8 | 8 | 0 |
| M6 `setMarkedText("shi")` | `"你好shi"` | YES | 2 | 9 | 9 | 0 |
| C2 `unmarkText()` | `"你好shi"` | no | 2 | 10 | 10 | 0 |
| F4 `insertText("x")` | `"你好shix"` | no | 2 | 11 | 11 | 0 |
| F5 `deleteBackward()` | `"你好shi"` | no | 2 | 12 | 12 | 0 |
| E1 `resignFirstResponder()` | `"你好shi"` | no | **3** | 12 | 12 | 0 |
| E2 `becomeFirstResponder()` | `"你好shi"` | no | 3 | 12 | 12 | 0 |
| F6 `insertText("z")` | `"你好shiz"` | no | 3 | 13 | 13 | 0 |
| M7 `setMarkedText("wo")` | `"你好shizwo"` | YES | 3 | 14 | 14 | 0 |
| E4 组字中 `resign` | `"你好shizwo"` | **YES** | **4** | 14 | 14 | 0 |

**KVO 通道收到的完整值序列**（全程 4 次）：

```
"", "", "你好shi", "你好shizwo"
```

第 3、4 次都发生在 `resignFirstResponder()` 那一刻 —— 即「停止输入后才收到」。

第 4 次还带一个次生问题：**在组字未上屏（`markedTextRange != nil`）时结束编辑，
KVO 发出的是拼音串 `"你好shizwo"`，不是上屏后的中文。**

**`.editingChanged` / `textDidChange` 在 handler 内读到的值序列**（14 次，逐键即时，
且**读到的已是更新后的值**，不存在读到旧值的时序陷阱）：

```
"a", "ab", "n", "ni", "nih", "niha", "nihao", "你好", "你好shi",
"你好shi", "你好shix", "你好shi", "你好shiz", "你好shizwo"
```

### UITextView（对照）

| 步骤 | `text` 取值 | `markedTextRange` | kvo | notif |
| --- | --- | --- | --- | --- |
| S0 初始 | `""` | no | 1 | 0 |
| F1 `insertText("a")` | `"a"` | no | 1 | 1 |
| F2 `insertText("b")` | `"ab"` | no | 1 | 2 |
| M1 `setMarkedText("ni")` | `"abni"` | YES | 1 | 3 |
| M2 `setMarkedText("nihao")` | `"abnihao"` | YES | 1 | 4 |
| C1 `insertText("你好")` | `"ab你好"` | no | 1 | 5 |
| E1 `resignFirstResponder()` | `"ab你好"` | no | **1** | 5 |

**KVO 值序列：`""`** —— 全程只发出订阅初值，一次都没再触发。
UITextView 由 TextKit 直接写 `NSTextStorage`，连 resign 都不经过 `setText:`，
比 UITextField 更彻底地失效。通知通道则每次变化都触发。

### 关于 delegate 通道

`delegate = 0` 全程为 0，**但这不代表 delegate 有问题**：`insertText(_:)` /
`setMarkedText(_:selectedRange:)` 是 `UIKeyInput` 层的方法，程序化调用会绕过
`textField(_:shouldChangeCharactersIn:replacementString:)`。本次尝试用硬件键盘注入
真实按键来覆盖这条路径，被系统权限拦下（System Events `-10004`），**未能验证**。
按 Apple 文档它应逐键触发，但本报告不将其计入结论。

## 四、与现有代码的对照

| 文件 | 位置 | 状态 |
| --- | --- | --- |
| `Sources/Fdy/Combine/UITextField+Combine++.swift` | `fdy_textPublisher` L9 | KVO，用户输入收不到 |
| 同上 | `fdy_attributedTextPublisher` L17 | 同一写法，同一问题 |
| `Sources/Fdy/Combine/UITextView+Combine++.swift` | `fdy_textPublisher` L9 | KVO，**完全失效** |
| 同上 | `fdy_attributedTextPublisher` L17 | 同一写法，同一问题 |

两处文档注释都写着「用户编辑与代码赋值均会发出」—— **对「用户编辑」这一半是错的**。

已有的可用件：`UIControl.fdy_publisher(for:)`（`UIControl+Combine++.swift` L9）
已经能产出 `.editingChanged` 事件，无需新增 API。

仓库内 `fdy_textPublisher` / `fdy_publisher(for:` 均**无内部调用点**（库自身不消费），
影响面在外部接入方，无法从本仓库统计。

## 五、修复方案（三种，按侵入度排序）

### 方案 1：最小改动 —— 换成事件通道

```swift
// UITextField
public var fdy_textPublisher: ControlProperty<String?> {
    let values = fdy_publisher(for: .editingChanged)
        .map { [weak self] _ in self?.text }
        .prepend(text)
        .eraseToAnyPublisher()
    return ControlProperty(values: values, setter: { self.text = $0 })
}

// UITextView（非 UIControl，没有 editingChanged，走通知）
public var fdy_textPublisher: ControlProperty<String?> {
    let values = NotificationCenter.default
        .publisher(for: UITextView.textDidChangeNotification, object: self)
        .map { [weak self] _ in self?.text }
        .prepend(text)
        .eraseToAnyPublisher()
    return ControlProperty(values: values, setter: { self.text = $0 })
}
```

- ✅ 逐键即时，已实测。
- ⚠️ **副作用**：失去「代码赋值也发出」这一路。实测 F3 证明原 KVO 确实能收到
  `tf.text = ""`，换成事件通道后收不到。用于 `ControlProperty` 双向绑定时，
  这反而消除了「写回再回声」的隐患；但若有代码依赖这一路，属破坏性变更。

### 方案 2：完整覆盖 —— 两路 Merge

KVO 并非无用，它恰好就是**代码赋值通道**。把两路合起来可同时保住即时性与代码赋值：

```swift
public var fdy_textPublisher: ControlProperty<String?> {
    let typed = fdy_publisher(for: .editingChanged)
        .map { [weak self] _ in self?.text }
    let assigned = publisher(for: \.text, options: [.new])
    let values = typed
        .merge(with: assigned)
        .prepend(text)
        .removeDuplicates()          // 去重：resign 时 KVO 会重发一次同值
        .eraseToAnyPublisher()
    return ControlProperty(values: values, setter: { self.text = $0 })
}
```

- ✅ 逐键即时 + 保留代码赋值。
- ⚠️ `removeDuplicates()` 会把「连续两次同值」合并掉，这是必要的（实测 E1
  `resign` 时 KVO 用 `"你好shi"` 重发了一次 F5 已发过的值）。
- ⚠️ 实现复杂度上升；`merge` 后两条来源的语义差异需要注释说清。
- 未实测 —— 本次探针只覆盖了单通道行为。

### 方案 3：不改实现，只改文档

保留现状，至少把 `fdy_textPublisher` 的注释改成符合事实的描述，
并在库文档中指明「需要逐键即时请用 `fdy_publisher(for: .editingChanged)`」。
不推荐 —— 一个默认行为反直觉的 API 会持续消耗接入方的时间。

## 六、必须同步确认的一个使用方决策

`.editingChanged` 在**中文组字期会发出拼音中间值**（实测 `"n", "ni", "nih", "niha", "nihao"`）。
是否过滤取决于用途：

- **字数统计 / 实时预览 / 搜索建议**：不过滤，正是要的即时性；
- **长度截断 / 提交校验 / 去重比较**：应加 `markedTextRange == nil` 过滤，
  否则会拿拼音串做判断。`UITextView++.swift:37` 的 `fdy_inputRestrictions`
  已经是这个思路，两处应当口径一致。

建议**不在库层默认过滤**，把选择权留给调用方；但在注释里写明这一点。

## 七、本次未验证项

1. **delegate 逐键回调** —— 硬件键盘注入被系统权限拦截，未测到。
2. **方案 2 的 Merge 实现** —— 未实测，仅从单通道数据推导。
3. **真机行为** —— 全部数据来自模拟器。文本输入通路在模拟器与真机上一致，
   风险低，但严格说未在真机复核。

## 八、复跑方式

```bash
cd .build/probe/ime
xcrun -sdk iphonesimulator swiftc -target arm64-apple-ios15.0-simulator \
  -parse-as-library App.swift -o Probe
mkdir -p Probe.app && cp Probe Probe.app/ && cp Info.plist Probe.app/Info.plist
xcrun simctl boot 21956BBD-1171-453D-B94E-0D06CFA3F350   # iPhone 17 Pro / iOS 26.5
xcrun simctl install 21956BBD-1171-453D-B94E-0D06CFA3F350 ./Probe.app
xcrun simctl launch --console-pty 21956BBD-1171-453D-B94E-0D06CFA3F350 com.wbtest.imetime
```

换 iOS 18.0 设备 UDID `897DFB7B-177D-4A9A-9C1B-B924C3EA9DF5` 可复现 A/B。
