# UIButton 配置更新 · 链式方法抽取方案

> 起因：`configurationUpdateHandler` 里「按状态逐项覆盖背景图/图标/标题」是一段必然重复的样板代码。
> 本文回答「能否抽成链式方法」，并给出实测过的实现形态。
> 探针：`.build/cfgprobe3/`（H 段，20 项），数据来自 iOS 18.0 与 26.5 双运行时。

## 一、结论

**能抽，但要先认清一件事**：`configurationUpdateHandler` 是**单个可写属性**，不是事件总线。
链式方法不可能「追加」，只能**由库接管这一个 handler**，再把多个注册片段串起来。

因此抽出的是三层：

| 层 | 形态 | 作用 |
| --- | --- | --- |
| L1 逃生舱 | `bc_updateConfiguration { c, state in ... }` | 一条链式调用替代手写 handler，内部保证「从外部模板出发 + 整份写回」 |
| L2 声明式 | `bc_variant(for:) { c in ... }` | 按状态注册覆盖片段，内建 `disabled > highlighted > selected > normal` 优先级 |
| L0 托管底座 | 库持有的模板 + 片段表（关联对象） | 让上面两层共存，且单点 setter（`bc_title` 等）与模板保持同步 |

只要 L1 就能消掉 90% 的样板；L2 是「四态各异」场景的糖，代价是引入托管的关联存储。

## 二、实测依据（双运行时逐行一致）

### 2.1 重入性 —— 库可以在 handler 里写回

| 用例 | 结果 |
| --- | --- |
| 首次写回后，一次 `isHighlighted` 变化 | handler **新增 1 次** |
| 最大嵌套深度 | **1**（`重入 = 否`） |
| 「每轮都写回」（库的真实形态） | 高亮 +1 次、复位 +1 次，**累计 3 次即收敛** |

**结论**：`button.configuration = c` 不会引发再次回调，无需 `isUpdating` 防护标志。

### 2.2 模板 + 变体的解模

| 用例 | 结果 | 判定 |
| --- | --- | --- |
| 高亮来回切换 4 次的 title 序列 | `HL → BASE → HL → BASE` | 变体生效且**能正确回退模板** |
| `isEnabled = false` | `DIS` | ✅ |
| 禁用中再置高亮 | `DIS` | disabled **压过** highlighted ✅ |
| 全部复位 | `BASE` | ✅ |

### 2.3 三条会决定实现细节的硬事实

| 事实 | 实测 | 后果 |
| --- | --- | --- |
| **`contains(.normal)` 恒真** | `highlighted / disabled / selected / empty` 四种 state 全部返回 `true`（`.normal` 的 rawValue 是 0，空选项集被任何集合包含） | `.normal` 只能当**最先应用的兜底层**，不能当「精确等于 normal」判断 |
| **只改模板不请求刷新 → 不生效** | 改 `template.title = "NEWER"` 后 `settle()`，读回仍是旧值 | 单点 setter 改完模板**必须**调 `setNeedsUpdateConfiguration()` |
| **只设 handler 不落地 configuration → handler 跑但配置不落地** | `H6d`：高亮变化**触发了 1 次**；`H6a`：`configuration` 仍为 `nil` | **必须先 `base.configuration = template`** 把按钮推进配置模式（`H6b` 落地后即正常） |
| **按钮不在视图层级 → handler 一次都不跑** | `H8a/H8b`：`superview == nil` 时，显式 `setNeedsUpdateConfiguration()` 与高亮变化**都是 0 次** | 探针必须 `addSubview`；库的正确性不受影响（真实使用中按钮必在层级里），但**任何「链式配置不生效」的报障要先问这一条** |

第三条与第四条尤其重要 —— 第三条意味着「懒托管」写法（等第一次状态变化再建配置）行不通；
第四条是排查「配了没反应」时最容易忽略的前提。

### 2.4 其余交互语义

| 用例 | 结果 |
| --- | --- |
| 同一状态注册**多个**闭包 | title = `AB`（顺序应用、后见前），`imagePadding = 9` ✅ |
| 先注册变体、再改模板 | `SEL` + `.capsule` 均生效 → **注册顺序无关** ✅ |
| `setNeedsUpdateConfiguration()` 立即性 | 改模板 + 请求刷新 → 立刻读到 `NEW` ✅ |
| `configuration = nil` 前先摘 handler | 存活，`configuration = nil` ✅（不摘则崩，见《UIButton_Configuration_多状态实现.md》） |

## 三、API 设计

### L1 逃生舱

```swift
public extension FdyWrapper where Base: UIButton {
    /// 接管按钮的配置重算：每次状态变化时，从**外部只读模板**出发调用 `mutate`，再整份写回
    ///
    /// - Parameter mutate: 参数一是模板副本（`inout`），参数二是当前状态
    /// - Returns: `Self`
    @discardableResult
    func bc_updateConfiguration(
        _ mutate: @escaping (_ configuration: inout UIButton.Configuration,
                             _ state: UIControl.State) -> Void
    ) -> Self
}
```

用法 —— 正好替代上一轮那份手写 handler：

```swift
button.fdy.bc_updateConfiguration { c, state in
    if state.contains(.disabled) {
        c.background.image = UIImage(named: "bg_disabled")
        c.image  = UIImage(named: "ic_disabled")
        c.title  = "不可用"
    } else if state.contains(.highlighted) {     // disabled 已在前，天然优先
        c.background.image = UIImage(named: "bg_pressed")
        c.image  = UIImage(named: "ic_pressed")
        c.title  = "收藏"
    } else if state.contains(.selected) {
        c.background.image = UIImage(named: "bg_selected")
        c.image  = UIImage(named: "ic_selected")
        c.title  = "已收藏"
    } else {
        c.background.image = UIImage(named: "bg_normal")
        c.image  = UIImage(named: "ic_normal")
        c.title  = "收藏"
    }
}
```

### L2 声明式状态表

```swift
button.fdy
    .bc_variant(for: .normal)      { $0.title = "收藏";   $0.image = .init(named: "ic_n"); $0.background.image = .init(named: "bg_n") }
    .bc_variant(for: .highlighted) { $0.title = "收藏";   $0.image = .init(named: "ic_h"); $0.background.image = .init(named: "bg_h") }
    .bc_variant(for: .selected)    { $0.title = "已收藏"; $0.image = .init(named: "ic_s"); $0.background.image = .init(named: "bg_s") }
    .bc_variant(for: .disabled)    { $0.title = "不可用"; $0.image = .init(named: "ic_d"); $0.background.image = .init(named: "bg_d") }
```

同一状态可多次注册，按注册顺序依次应用（`H3a` 已验证），因此「公共部分 + 差异部分」可以拆开写。

## 四、实现要点

```swift
/// 托管底座：一个按钮一份，放关联对象（存 class 而非 struct，跨 ObjC 桥只传指针）
final class FdyButtonConfigurationBox {
    var template: UIButton.Configuration
    var updates: [(inout UIButton.Configuration, UIControl.State) -> Void] = []
    var variants: [UInt: [(inout UIButton.Configuration) -> Void]] = [:]   // 键必须是 rawValue
}
```

五条必须遵守的点，每条都有上面对应的实测支撑：

1. **模板用闭包捕获的 struct 快照，绝不读 `button.configuration`** —— 读回会让 UIKit 把派生结果当基准，状态回退时旧值残留（《多状态实现》§2 已实测）。
2. **`base.configuration = template` 必须主动落地** —— 否则 handler 照跑但配置不落地（§2.3 第三条）。
3. **状态表键用 `UInt`（`state.rawValue`）** —— `UIControl.State` 不满足 `Hashable`，直接用会编译不过（探针第一版即此错）。
4. **应用顺序固定 `normal → selected → highlighted → disabled`** —— `.normal` 恒命中，只能当兜底；`disabled` 必须最后（压过其余）。
5. **闭包捕获 `[weak base]`** —— handler 由 button 持有，直接捕获 `button` 会成环。写回用的是 `handler` 的入参 `button`，不需要再捕获。
6. **写回不重入，无需防护标志** —— handler 内 `button.configuration = c` 不会再次回调（实测最大嵌套深度 1）。

另：`Updates` 与 `Variants` 共用一份 template，`updates` 先于 `variants` 应用（逃生舱优先于声明式表）。

### 与现有 18 个 `bc_*` 单点 setter 的关系

两种做法，代价差很多：

| 做法 | 改动 | 后果 |
| --- | --- | --- |
| **A. 不动**（推荐先做） | 只加 L1/L2，单点 setter 维持现状（直接改 `base.configuration`） | 使用者要先用 `bc_*` 配好基础、**再**调 `bc_updateConfiguration`——因为模板是在后者被调用时快照的。语义清晰但要写进文档 |
| **B. 同步** | 18 个方法都加「有 box 时改 template + 请求刷新」的分支 | 链式顺序完全自由，但每个方法都要多一层判断，且要处理「handler 是用户自己设的」这类边界 |

做法 A 的风险是「顺序敏感」：`bc_variant` 之后再调 `bc_title` 只改 `base.configuration`，下一轮会被 handler 用旧模板覆盖。

## 五、待拍板

1. **落 L1 还是 L1+L2** —— L1 零侵入（不动现有 18 个方法），L2 需要引入托管 box 与单点 setter 的同步策略。
2. **单点 setter 走做法 A 还是 B** —— A 省事但顺序敏感，B 彻底但要改 18 处。
3. **`bc_configuration(_:)` 传 `nil` 的崩溃风险是否一并修** —— 托管模式下 handler 一定存在，届时传 nil 必崩；建议改为「传 nil 时先摘 handler 再置空」（`H7a` 已验证该路径安全）。
4. **命名** —— `bc_updateConfiguration` / `bc_variant`（与 `bc_` 前缀约定一致）。若要更短可用 `bc_update` / `bc_state`。

## 六、本轮未做

- `Sources/` 一行未动（纯调研）。
- 「每轮写回」在**真实触摸**下的表现未测（触摸注入仍被 `osascript -10004` 拦着，需最小 Xcode 工程跑 XCUITest）。
- `updates` / `variants` 与 `bc_isLoading`（带 `isUserInteractionEnabled` 副作用）的交互未验证。
