# UIButton.Configuration 多状态按钮实现指南

> 目标：一个按钮同时具备 **背景图 + 图标 + 标题**，且 **normal / highlighted / selected / disabled** 四态的这三件套各不相同。
>
> 全部结论来自模拟器真实渲染实测（iOS 18.0 与 26.5 双运行时逐行一致），非文档推导。
> 探针：`.build/cfgprobe/`（F 段）、`.build/cfgprobe2/`（G 段）。

## 一、核心心智模型

传统 API 里「状态」是配置的一部分：

```swift
// 传统：每个状态各存一份，UIKit 按 state 挑
button.setBackgroundImage(imgNormal, for: .normal)
button.setBackgroundImage(imgPressed, for: .highlighted)
```

配置模式把这个模型**反过来**：`UIButton.Configuration` 就是**一份当前状态下的完整外观**，
它自己不带「状态维度」。多状态的实现方式是——**状态变了，重算整份配置**：

```swift
button.configurationUpdateHandler = { button in
    var c = template                       // ← 从外部模板出发
    if button.state.contains(.disabled) { /* 换成禁用态的图/图标/标题 */ }
    button.configuration = c               // ← 整份写回
}
```

所以问题从「给每个状态配一份资源」变成「**在回调里按 state 分支**」。

## 二、实测证据（双运行时一致）

### 2.1 什么操作会触发回调

| 操作 | handler 是否被调用 | 备注 |
| --- | --- | --- |
| 设 `configurationUpdateHandler`（即使没设 `configuration`） | ✅ 被调 1–2 次 | 官方注释属实：设 handler 即强制进入配置模式 |
| 设 `configuration` | ✅ 1 次 | |
| `setNeedsUpdateConfiguration()` | ✅ 新增 1 次 | 官方推荐的主动刷新入口 |
| `isHighlighted = true` | ✅ 新增 1 次 | |
| `isEnabled = false` | ✅ 新增 1 次 | |
| `isSelected = true` | ✅ 新增 1 次 | |

> ⚠️ **验证方法学**：配置更新在**下一个 layout 周期**执行。赋值后同步读 handler 调用次数
> 会读到 `0`，必须让 runloop 转一圈（`RunLoop.current.run(until:)`）。
> 第一版探针没做这一步，得出过「`isHighlighted` 不触发 handler」的错误结论。

### 2.2 只设 handler、不设 configuration 时

```
G4 只设 handler（不设 configuration）→ handler 调用 2 次，其中读到 configuration == nil 的有 2 次
```

handler 确实在跑，但 `button.configuration` 读出来**是 nil**。所以：
- 回调里不能无条件 `button.configuration!`
- 想读回也要写 `button.configuration ?? .plain()` —— 但读回本身就是坑，见 2.3

### 2.3 ⚠️ 读回式写法会造成状态污染

这是本节最重要的一条。

```swift
// ❌ 读回式：从「当前生效配置」出发
button.configurationUpdateHandler = { button in
    var c = button.configuration ?? .plain()
    if button.state.contains(.highlighted) { c.title = "HL" }
    button.configuration = c
}

// ✅ 模板式：从「外部只读模板」出发
button.configurationUpdateHandler = { button in
    var c = template
    if button.state.contains(.highlighted) { c.title = "HL" }
    button.configuration = c
}
```

实测（模板 `title = "BASE"`，只在高亮时改成 `"HL"`）：

| 写法 | 高亮中 | **取消高亮后** |
| --- | --- | --- |
| 读回式 | `HL` | **`HL`** ← 卡住，回不去 |
| 模板式 | `HL` | `BASE` ✅ |

**机理**：`automaticallyUpdatesConfiguration` 默认为 `YES`，UIKit 会在状态变化时调用
`-[UIButtonConfiguration updatedConfigurationForButton:]` 做**内部派生**（淡化、调色），
并把派生结果写回 `button.configuration`。于是读回式拿到的其实是「上一次派生后的产物」，
状态回退时它已经不含原始值了。

→ **结论：任何情况下都不要从 `button.configuration` 读回，永远从外部模板出发。**

### 2.4 ⚠️ 自定义背景图不会自动变淡/变灰

这是「为什么必须自己写状态分支」的直接原因。像素采样同一按钮（`background.image` 为纯红图，
采样点取右侧边缘，避开文字与图标）：

| 状态 | 自定义 `background.image` | 对照：`baseBackgroundColor = .red` |
| --- | --- | --- |
| normal | `r255 g0 b0 a255` | `r255 g0 b0 a255` |
| highlighted | `r255 g0 b0 a255` ← **完全没变** | `r191 g0 b0 a191` ← 自动变淡 |
| disabled | `r255 g0 b0 a255` ← **完全没变** | `r14 g14 b15 a31` ← 自动变半透明灰 |

且实测 `button.configuration?.background.image` 在高亮前后是**同一个对象**（UIKit 没有换图）。

**分界线**：
- **颜色路径**（`baseBackgroundColor` / `baseForegroundColor`）→ UIKit 自动派生各态
- **图片路径**（`background.image` / `image`）→ UIKit **完全不派生**，各态同图

这就是 `adjustsImageWhenHighlighted` / `adjustsImageWhenDisabled` 在配置模式下被忽略的后果
（SDK 头文件原话：「you may customize to replicate this behavior via a configurationUpdateHandler」）。

### 2.5 图标想被 `baseForegroundColor` 染色，必须设 template

| 图片渲染模式 | 实测渲染结果 | 是否被 `baseForegroundColor = .green` 染色 |
| --- | --- | --- |
| `.alwaysOriginal`（默认） | `r0 g0 b255`（保持原蓝） | ❌ |
| `.alwaysTemplate` | `r0 g255 b0`（变绿） | ✅ |

```swift
c.image = UIImage(named: "ic_heart")?.withRenderingMode(.alwaysTemplate)
// 或
c.imageColorTransformer = UIConfigurationColorTransformer { _ in .green }
```

### 2.6 `disabled` 会抑制 `highlighted`

```
G2a disabled + selected          → rawValue=6  位=DIS+SEL
G2b 在 disabled 之上再置 highlighted → rawValue=6  位=DIS+SEL
    isHighlighted 属性读回 = false
```

`UIControl.State` 位值：`highlighted = 1`，`disabled = 2`，`selected = 4`。
禁用态下设 `isHighlighted = true` 会被忽略（连属性本身都读回 `false`）。

→ **判定优先级必须是 `disabled > highlighted > selected > normal`。**
反过来先判 highlighted 会让禁用态下出现「按下效果」。

### 2.7 ⚠️ 已启用 handler 后把 `configuration` 置 nil 会崩溃

```
G6a 未设 handler → 置 configuration = nil → 未崩溃
G5a 已设 configuration + handler → 置 configuration = nil
*** NSInternalInconsistencyException:
    'Updated configuration was nil for configuration: (null)'
    -[UIButtonConfigurationVisualProvider automaticallyUpdateConfigurationIfNecessary:]
```

双运行时**都崩**，栈顶在 `automaticallyUpdateConfigurationIfNecessary:`。

→ 已进入配置模式的按钮，**不要再用 nil 清空配置**。要恢复传统外观，得先摘掉 handler：
```swift
button.configurationUpdateHandler = nil
button.configuration = nil
```

> 与本库的关系：`FdyWrapper<UIButton>.bc_configuration(_:)` 的入参是
> `UIButton.Configuration?`（可传 nil）。若调用方同时设了 `configurationUpdateHandler`，
> 传 nil 会直接崩溃 —— 属既有 API 的隐患，见第五节。

## 三、完整实现

### 3.1 推荐：子类化 + 状态表

把「状态 → 三件套」做成声明式，调用方只填表：

```swift
import UIKit

/// 四态各不相同的按钮：背景图 / 图标 / 标题三件套按状态独立配置
final class FdyVariantButton: UIButton {

    /// 单个状态的外观三件套
    struct Variant {
        var background: UIImage?
        var icon: UIImage?
        var title: String?

        init(background: UIImage? = nil, icon: UIImage? = nil, title: String? = nil) {
            self.background = background
            self.icon = icon
            self.title = title
        }
    }

    /// 只读模板 —— 回调每轮都从它出发，绝不从 button.configuration 读回
    private let template: UIButton.Configuration

    var normalVariant: Variant?      { didSet { setNeedsUpdateConfiguration() } }
    var highlightedVariant: Variant? { didSet { setNeedsUpdateConfiguration() } }
    var selectedVariant: Variant?    { didSet { setNeedsUpdateConfiguration() } }
    var disabledVariant: Variant?    { didSet { setNeedsUpdateConfiguration() } }

    init(template: UIButton.Configuration = .plain(), frame: CGRect = .zero) {
        self.template = template
        super.init(frame: frame)
        configuration = template
        configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            var configuration = template                     // ① 模板，不是 button.configuration
            let variant = resolve(for: button.state)
            configuration.background.image = variant?.background
            configuration.image = variant?.icon
            if let title = variant?.title { configuration.title = title }
            button.configuration = configuration             // ② 整份写回
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// 优先级：disabled 会抑制 highlighted（见 §2.6），故必须最先判
    private func resolve(for state: UIControl.State) -> Variant? {
        if state.contains(.disabled) { return disabledVariant ?? normalVariant }
        if state.contains(.highlighted) { return highlightedVariant ?? normalVariant }
        if state.contains(.selected) { return selectedVariant ?? normalVariant }
        return normalVariant
    }
}
```

用法：

```swift
let favorite = FdyVariantButton(template: {
    var c = UIButton.Configuration.plain()
    c.imagePlacement = .leading
    c.imagePadding = 6
    c.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
    c.background.imageContentMode = .scaleToFill      // 背景图铺满
    c.cornerStyle = .capsule
    return c
}())

favorite.normalVariant = .init(
    background: UIImage(named: "btn_bg_normal"),
    icon: UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate),
    title: "收藏"
)
favorite.highlightedVariant = .init(
    background: UIImage(named: "btn_bg_pressed"),
    icon: UIImage(systemName: "heart.fill"),
    title: "收藏"
)
favorite.selectedVariant = .init(
    background: UIImage(named: "btn_bg_selected"),
    icon: UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate),
    title: "已收藏"
)
favorite.disabledVariant = .init(
    background: UIImage(named: "btn_bg_disabled"),
    icon: UIImage(systemName: "heart"),
    title: "不可用"
)

favorite.changesSelectionAsPrimaryAction = true   // 点一下自动切 selected（实测有效）
favorite.addAction(UIAction { _ in print("tapped") }, for: .touchUpInside)
```

`changesSelectionAsPrimaryAction = true` 的实测行为：`sendActions(for: .touchUpInside)`
即触发 `isSelected` 的自动翻转（`false → true → false`），且回调收到 `.selected` 位。

### 3.2 最小版（不子类化）

```swift
var template = UIButton.Configuration.plain()
template.imagePadding = 6
template.background.imageContentMode = .scaleToFill

let button = UIButton(type: .custom)
button.configuration = template
button.configurationUpdateHandler = { button in
    var c = template                                  // ← 变量必须来自外部
    let state = button.state
    if state.contains(.disabled) {
        c.background.image = UIImage(named: "bg_disabled")
        c.image = UIImage(named: "ic_disabled")
        c.title = "不可用"
    } else if state.contains(.highlighted) {
        c.background.image = UIImage(named: "bg_pressed")
        c.image = UIImage(named: "ic_pressed")
        c.title = "收藏"
    } else if state.contains(.selected) {
        c.background.image = UIImage(named: "bg_selected")
        c.image = UIImage(named: "ic_selected")
        c.title = "已收藏"
    } else {
        c.background.image = UIImage(named: "bg_normal")
        c.image = UIImage(named: "ic_normal")
        c.title = "收藏"
    }
    button.configuration = c
}
```

> 注意 `UIButton(configuration:primaryAction:)` 的 `primaryAction` **没有默认值**，
> 所以 Swift 里不能写 `UIButton(configuration: c)`；用 `UIButton(type: .custom)` + 赋值，或显式传 `nil`。

### 3.3 实测渲染验证

用 3.1 的写法（背景图 / 图标 / 标题三件套全换）跑像素采样与颜色直方图：

| 状态 | 背景边缘像素 | 直方图主色（背景 + 图标） | 配置里的 title |
| --- | --- | --- | --- |
| normal | `r255 g0 b0` 红 | 红 ×10573 + **蓝** ×361 | `NORMAL` |
| highlighted | `r255 g255 b0` 黄 | 黄 ×10937 + **青** ×342 | `HL` |
| selected | `r255 g255 b0` 黄 | — | `SEL` |
| disabled | `r128 g128 b128` 灰 | 灰 ×10619 + **黑** ×361 | `DIS` |
| 复位 normal | `r255 g0 b0` 红 | — | `NORMAL` ✅ 无残留 |

三件套全部按状态正确切换，且复位后回到基线（模板式的收益）。

## 四、坑位速查

| # | 坑 | 后果 | 对策 |
| --- | --- | --- | --- |
| 1 | 从 `button.configuration` 读回再改 | 状态回退时残留上一态的值 | 永远从外部模板出发 |
| 2 | 自定义背景图不自动变淡/变灰 | 「按下没反馈」的观感 bug | handler 里换图，或用 `baseBackgroundColor` |
| 3 | 图标是 `.alwaysOriginal` | `baseForegroundColor` 对图标无效 | `.withRenderingMode(.alwaysTemplate)` |
| 4 | 判定顺序先判 highlighted | 禁用态出现按下效果 | `disabled > highlighted > selected > normal` |
| 5 | 已设 handler 后置 `configuration = nil` | **`NSInternalInconsistencyException` 崩溃** | 先 `configurationUpdateHandler = nil` |
| 6 | 只设 handler 不设 configuration | 回调里 `button.configuration` 为 nil | 用模板即可绕开 |
| 7 | 赋值后同步读 handler 次数 | 误判「状态变化不触发回调」 | 让 runloop 转一圈再读 |
| 8 | 背景图按控件尺寸拉伸变形 | 圆角/描边被拉坏 | 用 `resizableImage(withCapInsets:)` + `imageContentMode` |

## 五、与本库既有 API 的关系

- `FdyWrapper<UIButton>.bc_*(...)` 系列操作的是**同一份** `base.configuration`，
  与 `configurationUpdateHandler` 配合使用时，注意它们改的是「当前那一份」：
  回调里若从模板出发，用 `bc_*` 预设的模板值会被覆盖 —— 推荐**用 `bc_*` 建模板，用回调做状态分支**。
- `bc_configuration(_:)` 接受 `UIButton.Configuration?`，**传 nil 有崩溃风险**（见 §2.7）。
  建议改为：传 nil 时内部先摘 handler，或直接把入参改成非可选。
- `UIButton.Configuration` 当前**没有 `FdyExtension` conformance**（`FdyWrapper.init` 为 internal），
  故 `UIButton.Configuration+Chain.swift` 的 16 个方法对外不可达 —— 与本主题相关，仍待拍板。
