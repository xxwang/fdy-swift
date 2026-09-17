# UIButton 扩展方法优化方案（Extensions 侧）

> **范围**：以 `Core/Extensions/UIKit/UIButton++.swift` 为核心，连带梳理 Chain 侧与 `FdyCreator` 工厂的一致性。
> **关联**：Chain 侧 32 处配置模板重复的问题已有专文《UIButton_Chain_优化方案.md》，本文只做状态同步，不重复展开。
> **前置状态**：当前分支 `Swift6`，`Package.swift` 仍为 `swiftLanguageMode(.v5)`；命名空间正处于 `fdy_` 前缀 → `.fdy` 命名空间的迁移途中。
> **本文只出方案，不含代码改动。**

---

## 一、现状盘点

### 1.1 UIButton 的能力散落在 4 个文件

| 文件 | 行数 | 承载内容 |
| --- | --- | --- |
| `Core/Extensions/UIKit/UIButton++.swift` | 69 | 扩展点击区域、`fdy_viewSize`、`fdy_allStates` |
| `Core/Chain/UIKit/UIButton+Chain.swift` | 406 | 链式 API（16 处配置模板 + 传统 API + 自定义方法） |
| `Core/Chain/UIKit/UIButton.Configuration+Chain.swift` | 184 | `UIButton.Configuration` 链式（16 处模板） |
| `Core/Common/FdyCreator.swift` | 473（UIButton 部分 L120–177） | 9 个工厂类方法 |

同一个控件的能力分散在「Extensions / Chain / Common」三个目录，是本次优化的核心动因。

### 1.2 库内引用统计（决定改动破坏面）

| 成员 | 定义位置 | 库内引用 |
| --- | --- | --- |
| `fdy_expandClickArea(_:)` | `UIButton++.swift:50` | 1 处（`UIButton+Chain.swift:375` 委托） |
| `fdy_expandedRect()` | `UIButton++.swift:34` | 1 处（同文件 `point(inside:)` 内） |
| `point(inside:with:)` override | `UIButton++.swift:23` | 语法入口，全量 UIButton 生效 |
| `fdy_allStates` | `UIButton++.swift:12` | **0 处** |
| `fdy_viewSize(maxWidth:)` | `UIButton++.swift:61` | **0 处** |
| `expandClickArea(_:)`（链式） | `UIButton+Chain.swift:374` | 对外 API |

`fdy_allStates` 与 `UIButton.fdy_viewSize` 在库内零引用，属于「只对外暴露、内部未消费」的裸方法；而 Chain 侧也没有为它们提供链式入口 —— 两套 API 的覆盖面并不对齐。

---

## 二、问题清单（按严重度分级）

### P0-1　`point(inside:with:)` 的 extension override 是一个全局猴子补丁

`UIButton++.swift:23` 在 `extension UIButton` 里写了 `override open func point(inside:with:)`。

它能编译，是因为 `UIButton` 自身**没有**声明该方法，而是纯继承自 `UIView`（ObjC 导入的方法为 dynamic 派发，允许在 extension 中覆盖继承实现）。**但代价是实现了对 `UIButton` 类的全局注入。**

实测结论（macOS 复刻 UIKit 的继承结构，`xcrun swift`）：

```
A. 普通按钮未设扩展:   [Fdy 扩展实现] expandSize 判定中
                      [UIView 原始实现]
B. 普通按钮设扩展后 x=42: true
C. 子类自己 override 后 x=42: false   <-- 扩展点击区域在子类上失效
```

由此得到 3 个事实：

1. **未设置扩展区域的按钮也要付出代价**。任何 UIButton 实例的每次 `point(inside:)` 都会先进入扩展实现 —— 读一次关联对象、算一次 `CGRect`、做一次 `equalTo` 比较，然后才回落 `super`。`hitTest` 是随触摸与视图层级逐层触发的热路径，滚动列表里调用量不小。
2. **影响面无法收敛**。UIKit 内部创建的按钮同样命中该实现 —— `UIAlertController` 的按钮、导航栏/工具栏按钮、`UISearchBar` 的 clearButton 等。接入方没有任何开关可以关掉它。
3. **子类重写即静默失效**（最严重）。工程中任何 `class XXXButton: UIButton` 只要自己重写了 `point(inside:)`，扩展实现就被完全 shadow，`expandClickArea` 变成摆设，**编译期与运行期都不会给任何提示**。

补充证据：全项目 `Extensions/` 目录下，**这是唯一一处 extension override UIKit 方法**（对 `override func` 的检索只命中此一行）。也就是说它是孤例，重构它不会牵连其他文件。

### P0-2　`fdy_viewSize` 三处同名、三种默认语义

| 类型 | 签名默认值 | 定义位置 |
| --- | --- | --- |
| `UIButton` | `maxWidth: CGFloat? = nil` → 取 `FdyScreen.screenWidth` | `UIButton++.swift:61` |
| `UILabel` | `maxWidth: CGFloat = .greatestFiniteMagnitude` | `UILabel++.swift:193` |
| `NSAttributedString` | `maxWidth: CGFloat = .greatestFiniteMagnitude` | `NSAttributedString++.swift:89` |

三个问题：

- **同一方法名，默认行为不同**。`UIButton.fdy_viewSize()` 内部把「屏宽」传给 `titleLabel?.fdy_viewSize(maxWidth:)`，而 UILabel 的默认值是无限大 —— 于是 `button.fdy_viewSize()` 与 `button.titleLabel!.fdy_viewSize()` 会得出不同结果（多行标题被按屏宽折行 vs 单行宽度）。
- **隐式依赖全局 UI 状态**。`FdyScreen.screenWidth` 取自「当前 `foregroundActive` 场景」的屏，App 启动早期无活跃场景时回落 `UIScreen.main.bounds`。一个纯计算函数依赖全局场景状态，结果不可复现，多窗口 / Stage Manager 下语义也不明确。
- ~~**只覆盖 `.normal` 状态**。优先取 `currentAttributedTitle`，非 normal 状态的标题尺寸无从测量。~~
  **此条已被实测推翻**（见第八节 8.4）：`currentAttributedTitle` 为 `nil` 时会落到 `titleLabel`，
  而 `titleLabel.text` 跟随状态 —— 测的是**当前状态**的标题。要测其他状态需先切换状态，这点应写进文档。

### P0-3　命名双轨制与重复入口

| 能力 | Extensions 侧（旧） | Chain 侧（新） |
| --- | --- | --- |
| 扩大点击区域 | `button.fdy_expandClickArea(10)` | `button.fdy.expandClickArea(10)` |
| 内容尺寸 | `button.fdy_viewSize()` | 无 |

- `FdyExtension.swift` 已提供 `.fdy` 命名空间入口，Chain 侧全面使用；Extensions 侧仍是 `fdy_` 前缀。最近提交 `6d3b054 修改全局命名空间` 证实迁移正在进行，UIButton 属于未收尾的部分。
- `expandClickArea` 有两个公开入口，Chain 侧只是转发（`UIButton+Chain.swift:375`）。API 表面翻倍，维护时需同步改两处。
- 注意：`fdy_` 前缀在项目其余部分仍大量存在（`fdy_SetAO` / `fdy_badgeLabel` / `fdy_className` 等），所以**本次不做全库改名**，只在 UIButton 范围内决定收敛方向。

### P1-4　Swift 6 迁移阻塞：`FdyKeys` 的可变 `static var`

`UIButton++.swift:8` 的 `static var expandSizeKey: UInt8 = 0` 用「变量地址」充当关联对象 key。实测在 Swift 6 语言模式下直接编译失败：

```
$ xcrun swift -swift-version 6
error: static property 'expandSizeKey' is not concurrency-safe because it is
       nonisolated global shared mutable state [#MutableGlobalVariable]
note: convert 'expandSizeKey' to a 'let' constant ...
note: add '@MainActor' ...
```

- 全库同类写法共 **9 处**，分布在 7 个文件（`UIButton++.swift`、`UIView++.swift`、`UIView+Effects++.swift`、`UICollectionView++.swift`、`UIGestureRecognizer++.swift`、`Combine/UIView+Combine++.swift`、`Combine/UIScrollView+Combine++.swift`）。当前 `.v5` 模式掩盖了它，一旦切 `.v6` 全部变红。
- 实测可用的最小修法（编译通过、往返值正确、语义不变）：

```swift
private enum FdyKeys {
    nonisolated(unsafe) static var expandSizeKey: UInt8 = 0
}
```

- 顺带确认：关联对象的数值往返本身**没有问题**。实测 `CGFloat` 存进关联对象后 `as? CGFloat` 可取回 `Optional(10.0)`，存 `0` 取回 `Optional(0.0)`、与「未设置」返回 `nil` 可区分 —— 所以 `fdy_expandedRect()` 的 nil 判定逻辑是成立的，**此处无需改动**。

### P1-5　Chain 侧 32 处配置模板重复（已在专文中规划，尚未执行）

`UIButton+Chain.swift` 与 `UIButton.Configuration+Chain.swift` 各有 16 个方法共享同一四行模板。修法见《UIButton_Chain_优化方案.md》方案 A，此处仅登记状态：**方案已就绪，代码未落地**。

### P2-6　`FdyCreator.swift` 中的 UIButton 工厂

`L121–177` 把 9 个类方法挂在 `UIButton` 上：`button / plain / tinted / gray / filled / borderless / bordered / borderedTinted / borderedProminent`。

- **命名过泛**。`UIButton.plain()` 与系统 `UIButton.Configuration.plain()` 语义相近、返回类型不同，阅读时极易混淆；把通用名词（`plain` / `gray` / `filled`）直接铺在 UIKit 类型上，与系统或第三方 ObjC 分类重名即编译冲突。
- ~~**`@objc extension` + `open class func` 的 `open` 是误导性修饰符**。extension 新增的成员对下游模块无法被 override，标注 `open` 制造了错误的可扩展性预期。~~
  **此条已被实测推翻**（见第八节 8.4）：`@objc` 让这些工厂方法进入 ObjC 运行时，`open` 是**真实存在的可覆盖点**
  —— 外部模块子类 `override class func plain()` 实测编译通过；去掉 `open` 后同一段代码报
  `overriding non-open class method outside of its defining module`。**不应改动。**
- **存在无效语句**。`button()` 内的 `.fdy.isHighlighted(false)` 对新建按钮是空操作（默认即非高亮），属噪音代码。
- **文件职责与文件名脱节**。`FdyCreator.swift` 内并无 `FdyCreator` 类型，它是「所有 UIKit 类型的工厂集合」，UIButton 只是其中一段。而 UIButton 的其他能力又在另外两个文件 —— 同一控件的 API 分散在 3 处。

### P2-7　`fdy_allStates` 语义不符且为死 API

- 命名暗示「全部状态」，实际只返回 `normal / selected / highlighted / disabled` 四个，遗漏 `.focused`（iOS 15+）、`.application`、`.reserved`。
- 计算属性每次调用新建数组。
- 库内零引用（见 1.2 统计），Chain 侧也没有对应入口。
- 它作为 `public` 成员与 `fileprivate enum FdyKeys` 挤在同一个 `public extension UIButton` 里，组织层级混乱。

### P2-8　缺少测试

项目无 `Tests/` 目录，没有 XCTest target。而本次要动的 `point(inside:)` 恰恰是行为最敏感、最易回归的地方 —— 上述「子类重写即静默失效」如果早有测试覆盖，就不会潜伏至今。

### 附带：一个必须写进文档的使用陷阱（非代码问题）

`point(inside:)` 的扩展区域**超出父视图 bounds 时无效**。`hitTest` 先问父视图自己的 `point(inside:)`，父视图判定点不在自己范围内就直接返回 `nil`，根本不会询问子按钮。因此「把按钮放在父视图边缘、指望向外扩 10pt」是无效诉求。这条目前无任何文档说明，是接入方最容易踩的坑。

---

## 三、优化方案

### 3.1 P0-1 的三种改法（核心决策点）

#### 方案 A：改用子类承载 —— 根治，有破坏

```swift
open class FdyHitAreaButton: UIButton {
    public var fdy_expandSize: CGFloat = 0

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard fdy_expandSize > 0 else { return super.point(inside: point, with: event) }
        return bounds.insetBy(dx: -fdy_expandSize, dy: -fdy_expandSize).contains(point)
    }
}
```

| 维度 | 评估 |
| --- | --- |
| 全局副作用 | 消除（只作用于显式使用该子类的实例） |
| 子类 shadow 问题 | 消除（子类可继续 override，语义正常） |
| 性能 | 最优（无关联对象读取，普通按钮直接走系统实现） |
| 破坏面 | `button.fdy.expandClickArea(10)` 对任意 UIButton 不再可用，需改用子类 |
| 适配成本 | 取决于使用方数量 —— **若仅服务自有项目（fdy 目前 v0.1.0，使用方为自有工程），成本可控** |

#### 方案 B：保留 extension override + 短路优化 —— 零破坏，治标

```swift
override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    guard let size: CGFloat = fdy_GetAO(forKey: &FdyKeys.expandSizeKey), size != 0 else {
        return super.point(inside: point, with: event)
    }
    return bounds.insetBy(dx: -size, dy: -size).contains(point)
}
```

改动点：`guard` 提前短路，未设置扩展的按钮不再计算 `CGRect`、不再做 `equalTo` 比较；`bounds.insetBy(dx: -size, dy: -size)` 与原 `CGRect(x: bounds.origin.x - size, ...)` 数学等价但更简洁。

| 维度 | 评估 |
| --- | --- |
| 对外 API | 零变化 |
| 全局副作用 | 仍在（每次 hitTest 仍有一次 `objc_getAssociatedObject`），但开销下降 |
| 子类 shadow 问题 | **无解**（语言层面决定，extension 无法绕过） |
| 破坏面 | 零 |

#### 方案 C：方案 A + 兼容过渡层

新建 `FdyHitAreaButton`，同时在 extension 保留 `fdy_expandClickArea` 并标记 `@available(*, deprecated, message: "请改用 FdyHitAreaButton")`，分两个版本周期完成迁移。

> 权衡：引入一个「已废弃但仍在生效」的全局补丁，等于同时承担两套实现的维护成本，且废弃窗口内影子问题依然存在。**除非必须保证外部使用方的兼容，否则不如直接做 A。**

#### 方案对比

| | 方案 A 子类 | 方案 B 短路 | 方案 C 过渡 |
| --- | --- | --- | --- |
| 消除全局副作用 | ✅ | ❌ | 部分 |
| 解决子类 shadow | ✅ | ❌ | 部分 |
| 零破坏 | ❌ | ✅ | ✅ |
| 后续维护成本 | 低 | 低（隐患留存） | 高（双实现） |
| 适用前提 | 使用方可控 | 必须兼容未知使用方 | 对外发布且已有外部接入 |

### 3.2 其余问题的最小改法

| 问题 | 改法 | 破坏性 |
| --- | --- | --- |
| P0-2 默认值分裂 | `UIButton.fdy_viewSize` 默认值统一为 `.greatestFiniteMagnitude`，去掉对 `FdyScreen.screenWidth` 的隐式依赖；文档注明只测 `.normal` 状态 | 低（默认值语义变更，需在 CHANGELOG 标注） |
| P0-3 命名双轨 | 公开面收敛到 `.fdy` 链式；`fdy_expandClickArea` / `fdy_viewSize` 降为 `internal` 或直接由 Chain 侧内联实现 | 中（裸方法调用方需改） |
| P1-4 Swift 6 | 9 处关联键统一加 `nonisolated(unsafe)`，或改为「集中式 key 注册」单点管理 | 零 |
| P1-5 模板重复 | 按《UIButton_Chain_优化方案.md》方案 A 执行，两侧各抽一个 `private func update` | 零 |
| P2-6 工厂命名 | `open class func` → `class func`（去掉误导的 `open`）；删除 `.fdy.isHighlighted(false)`；通用名词方法与 `UIButton` 的命名空间关系需单独评审 | 低 |
| P2-7 `fdy_allStates` | 补齐遗漏状态并改名（如 `fdy_commonStates`），或直接删除 | 中（若已有外部调用） |
| P2-8 无测试 | 新增 XCTest target，优先覆盖 `point(inside:)` 的三种情形：未设置 / 已设置 / 子类重写 | 零 |

---

## 四、推荐路径（按批次推进）

**批次 1 —— 零破坏、立即见效**
1. P1-4：9 处关联键加 `nonisolated(unsafe)`，为 Swift 6 切换扫清障碍。
2. P1-5：执行 Chain 侧两侧 helper 抽取（方案已就绪）。
3. P0-1 方案 B：`point(inside:)` 改为 `guard` 短路 + `insetBy` 写法。
4. P0-2：统一 `fdy_viewSize` 默认值。
5. P2-6：删掉 `open` 与无效语句。

**批次 2 —— 需要一次 API 决策**
6. P0-3：确认收敛方向（推荐保留 `.fdy` 链式，裸 `fdy_` 方法降级）。
7. P2-7：`fdy_allStates` 补齐或删除。
8. P2-8：建立测试 target，为批次 3 的内容改动兜底。

**批次 3 —— 需确认使用方范围后再定**
9. P0-1 方案 A（或 C）：彻底移除全局猴子补丁。

**关于 P0-1 的决策依据**：是否需要保留对任意 `UIButton` 实例的 `expandClickArea` 能力？若 fdy 只服务自有工程，建议直接在批次 3 走方案 A；若已有外部使用方，则批次 1 的方案 B 作为长期方案，并接受「子类重写即失效」这一限制（用文档 + 注释明确告警）。

---

## 五、附：待办开关

| 批次 | 项目 | 是否执行 | 备注 |
| --- | --- | --- | --- |
| 1 | 关联键 `nonisolated(unsafe)`（9 处） | 待确认 | Swift 6 切换的硬阻塞，实测修法已验证 |
| 1 | Chain 侧两侧抽 helper | 待确认 | 方案见《UIButton_Chain_优化方案.md》 |
| 1 | `point(inside:)` 短路优化 | 待确认 | 零破坏，但仅治标 |
| 1 | `fdy_viewSize` 默认值统一 | 待确认 | 语义变更需记 CHANGELOG |
| 1 | `FdyCreator` 去 `open` / 删噪音语句 | 待确认 | 零破坏 |
| 2 | 命名空间收敛方向 | **需决策** | 保留 `.fdy` 链式 or 保留 `fdy_` 裸方法 |
| 2 | `fdy_allStates` 补齐 or 删除 | 待确认 | 库内零引用 |
| 2 | 新增测试 target | 待确认 | 优先覆盖 `point(inside:)` |
| 3 | P0-1 方案 A 子类化 | **需决策** | 取决于是否存在外部使用方 |
| — | 文档补充「扩展区域超出父视图 bounds 无效」 | 待确认 | 接入方最易踩的坑 |

> **本表已过时，以第八节为准**：第二批次的 `open` 项已实测推翻（不应改动），
> 批次 1 已落成可应用补丁并经双向验证，批次 2 的代码形态与决策项见 8.8。

---

## 六、未采纳 / 已排除

| 项 | 结论 | 理由 |
| --- | --- | --- |
| 关联对象数值往返有问题 | **不成立** | 实测 `CGFloat` 存取往返正确，`0` 与「未设置」可区分 |
| 全库 `fdy_` → `.fdy` 统一改名 | 本次不做 | 影响面远超 UIButton，应单独立项；本文只在 UIButton 范围内决策 |
| 用 method swizzling 替代子类 | 不推荐 | 引入不可控的运行时行为覆盖，比 extension override 更差 |

---

## 七、补充：Configuration 能否完全替代传统 API（批次 2 的决策依据）

> 追加于 2026-09-16。回答「iOS 18 及以上是否可以用 `UIButton.Configuration` 满足全部需求」，
> 该结论直接决定批次 2「命名空间收敛方向」该往哪走。

### 7.1 结论

**能覆盖绝大多数需求，含高亮 / 选中 / 禁用 / 加载 / 自定义背景**，但有三条边界必须知道：

1. **`UIButton.Configuration` 没有任何按状态（per-state）的属性** —— 头文件里 30 余个属性全是单值。
   一切状态差异都必须经 `configurationUpdateHandler`、`titleTextAttributesTransformer`、
   `imageColorTransformer` 这类「转换器」表达，而不是像传统 API 那样对每个状态各存一份值。
2. **仅 3 项无替代或会冲突**（见 7.4），其余「被 configuration 忽略」的废弃属性，Apple 都在头文件注释里指明了替代方案。
3. **不能与传统状态化 setter 混用**。Apple 原文：configuration 为 `nil` 时由 `setTitle(_:for:)` 等控制外观 ——
   言下之意是有 configuration 时由 configuration 主导，两边同时写会产生优先级不明的结果。

### 7.2 验证方式（可复核）

一手来源是 iOS SDK 头文件，它们的注释比文档站更清楚，且带完整 availability：

```bash
SDK=$(xcrun --sdk iphoneos --show-sdk-path)
ls "$SDK/System/Library/Frameworks/UIKit.framework/Headers/" | grep -i -e uibutton -e shadow
# UIButton.h / UIButtonConfiguration.h / UIBackgroundConfiguration.h / UIShadowProperties.h
```

另做了一份能力探针做类型检查，覆盖 Configuration 的 12 种样式、全部属性、状态化路径与 iOS 18 新增项：

```bash
# 探针文件：.build/probe/ButtonConfigurationProbe.swift
bash -c 'SDK=$(xcrun --sdk iphoneos --show-sdk-path); \
  xcrun --sdk iphoneos swiftc -typecheck -target arm64-apple-ios18.0 -sdk "$SDK" \
  -module-name Probe .build/probe/ButtonConfigurationProbe.swift'
```

结果：**零错误、零警告**（exit 0）。即下列 API 在 iOS 18 目标下全部可用。

### 7.3 需求 → Configuration 映射

| 传统做法 | Configuration 路径 | 版本 |
| --- | --- | --- |
| `setTitle(_:for:)` | `configuration.title`；状态差异走 updateHandler | 15.0 |
| `setAttributedTitle(_:for:)` | `configuration.attributedTitle` + `titleTextAttributesTransformer` | 15.0 |
| `setTitleColor(_:for:)` | `configuration.baseForegroundColor` + `baseForegroundColor` 转换器 | 15.0 |
| `setImage(_:for:)` | `configuration.image` + `imageColorTransformer` | 15.0 |
| `setBackgroundImage(_:for:)` | `configuration.background.image` / `background.backgroundColor` | 15.0 |
| `titleLabel?.font` | `titleTextAttributesTransformer`（改 `AttributeContainer.font`） | 15.0 |
| `contentEdgeInsets` | `configuration.contentInsets` | 15.0 |
| `titleEdgeInsets` / `imageEdgeInsets` | `configuration.imagePadding` / `imageReservation` | 15.0 |
| `adjustsImageWhenHighlighted` / `WhenDisabled` | updateHandler 内自行实现 | 15.0 |
| 自定义背景视图 | `background.customView` | 14.0 |
| 毛玻璃背景 | `background.visualEffect` | 14.0 |
| 自定义圆角 | `background.cornerRadius` + `cornerStyle = .fixed` | 14.0 / 15.0 |
| 背景阴影 | `background.shadowProperties`（color / opacity / radius / offset / path） | **18.0** |
| 加载态 | `showsActivityIndicator` 内建 | 15.0 |
| 下拉指示器 | `configuration.indicator` | 16.0 |
| 切换（选中）语义 | `changesSelectionAsPrimaryAction` + `automaticallyUpdateForSelection` | 15.0 |
| — | 4 种 Liquid Glass 样式 `glass()` / `prominentGlass()` / `clearGlass()` / `prominentClearGlass()` | **26.0** |

### 7.4 官方标注的硬边界

引自 SDK 头文件原文注释，这几条没有绕法：

| 项 | 头文件原文 | 影响 |
| --- | --- | --- |
| `showsTouchWhenHighlighted` | "These properties are ignored when a configuration is set **and have no replacement**." | 唯一明确「无替代」的项 |
| `backgroundRectForBounds:` / `contentRectForBounds:` / `titleRectForContentRect:` / `imageRectForContentRect:` | "These methods **will not be called** when using a configuration." | 4 个布局回调彻底失效，替代是 override `layoutSubviews` |
| `contentEdgeInsets` / `titleEdgeInsets` / `imageEdgeInsets` | "This property is ignored when using UIButtonConfiguration" | 有替代，见 7.3 |
| `reversesTitleShadowWhenHighlighted` / `adjustsImageWhenHighlighted` / `adjustsImageWhenDisabled` | "…you may customize to replicate this behavior via a **configurationUpdateHandler**" | 官方指定用 handler 复刻 |

### 7.5 对现有代码的影响

- `UIButton+Chain.swift` 的 `font(_:)`（`base.titleLabel?.font = font`）**对配置化按钮不可靠** ——
  configuration 会驱动 titleLabel 的内容与属性，官方把「自定义字体」的路径定义为 attributed title
  （`UIButton.font` 的废弃理由就是 "Specify an attributed title with a custom font"）。
  ⚠️ **此条为静态分析推断，未做运行时实测**，若要改动建议先在模拟器验证。
- `backgroundImage(_:for:)` 与 `backgroundImage(_ color:for:)` 里「判断 configuration 是否存在、走两条路径」的分支，
  正是混用两套 API 付出的代价 —— 收敛到单一体系后这两个分支可以直接删除。
- `contentEdgeInsets` / `titleEdgeInsets` / `imageEdgeInsets` 三个已标 `@available(iOS, deprecated: 15.0)` 的方法，
  若走全 Configuration 路线可直接移除。

### 7.6 待验证项

| 项 | 状态 |
| --- | --- |
| `titleLabel?.font` 在配置化按钮上被 configuration 覆盖的具体表现 | 静态推断，未实测 |
| `setTitle(_:for:)` 与 `configuration.title` 同时设置时的实际优先级 | 官方表述已表明 configuration 主导，未实测 |
| 配置化按钮上 `point(inside:)`（P0-1 扩大点击区域）是否受布局路径变化影响 | **已验证，见第八节 8.6 —— 不受影响** |

---

## 八、实测验证与可落地改法（追加于 2026-09-16）

> 前七节的结论大部分来自静态阅读与 macOS 复刻探针。本节把它们搬到**真实 UIKit + 真实 Fdy 模块**
> （`import Fdy`，链接由 `Sources/Fdy` 编出的 iOS 模拟器 dylib）上复验，并给出可直接落地的改法。
> **`Sources/` 仍未改动** —— 改动只发生在 `.build/` 下的副本上，产物是补丁文件。

### 8.1 验证装置

| 装置 | 说明 |
| --- | --- |
| `buttonopt` 探针 | `import Fdy`，只调公开 API，A–I 共 9 组断言 |
| `stockbtn` 探针 | **不链接 Fdy** 的同构代码，提供「stock UIKit 基线」 |
| 双运行时 | iOS 26.5（iPhone 17 Pro）与 iOS 18.0，同一份二进制各跑一遍 |
| 补丁验证 | 改在 `Sources/Fdy` 副本上 → 整模块 `swiftc -typecheck` → `diff -u` 出补丁 → `patch` 正反双向干跑 |

探针源码：`.build/probe/buttonopt/App.swift`、`.build/probe/stockbtn/App.swift`（`.build/` 已被 gitignore）。

### 8.2 P0-1 证据升级：注入确实是**类级**的

`class_copyMethodList` 只返回**类自身声明**的方法（不含继承）：

| | `UIView` 自身声明 `pointInside:withEvent:` | `UIButton` 自身声明 |
| --- | --- | --- |
| 不链接 Fdy（stock） | ✅ `true` | **❌ `false`** |
| 链接 Fdy | ✅ `true` | **✅ `true`** |

iOS 18.0 与 26.5 结果相同。这同时坐实两件事：

1. `UIButton` **原本确实不声明**该方法（纯继承自 `UIView`）—— 这正是 extension 里能写 `override` 的语言前提；
2. 链接 Fdy 后方法进入了 **`UIButton` 类自身的方法列表** —— 是货真价实的类级注入，不是「挂在实例上的标记」。

「子类重写即静默失效」也在**真实 UIKit** 上复现（此前只有 macOS 复刻）：

| 场景 | `expandClickArea(20)` 后判定 `x=-10` |
| --- | --- |
| 普通 `UIButton` | `true`（扩展生效） |
| 子类自己重写且不调 `super` | **`false`（静默失效）** |
| 子类重写但调 `super` | `true` |

### 8.3 修正：「被注入命中的系统控件」比原文说的少，且随版本变化

原文称「`UIAlertController` 的按钮、导航栏/工具栏按钮、`UISearchBar` 的 clearButton 等全部命中」。
实测（遍历子视图并回溯类继承链是否为 `UIButton` 后代）后需收窄：

| 系统控件 | iOS 18.0 | iOS 26.5 |
| --- | --- | --- |
| `UIStepper` 内部按钮 | **`_UIStepperButton` ×2，是 UIButton**（自身未声明 ⇒ 命中） | 已改写为 SwiftUI 宿主视图 `UICoreHostingView`，**不再是 UIButton** |
| 导航栏按钮 | `_UIModernBarButton` ×2，命中 | 私有 `…ButtonBarButtonVisualProvider.Button`，命中 |
| `UIAlertController` 的 action | `_UIAlertControllerActionView`，**不是 UIButton** | 同左，**不是** |
| `UISearchBar` 的 clearButton | 由 TextKit 绘制（`_UITextLayoutCanvasView`），**不是 UIButton** | 同左，**不是** |

准确说法是：**注入会命中 UIKit 内部的 `UIButton` 子类，而哪些控件含有这种子类随系统版本变化**。
这本身就是「影响面无法收敛」的实证 —— 连今天命中了谁都得靠运行时探测才知道。

### 8.4 被实测推翻的两条原文结论

| 原文结论 | 实测 | 处置 |
| --- | --- | --- |
| P2-6「`open class func` 的 `open` 是误导性修饰符」 | **错**。`@objc` 使工厂方法进入 ObjC 运行时，外部模块子类 `override class func plain()` **编译通过**；去掉 `open` 后同一段代码报 `overriding non-open class method outside of its defining module` | **不改**。去掉 `open` 是真破坏 |
| P0-2「只覆盖 `.normal` 状态」 | **不成立**。`currentAttributedTitle` 为 `nil` 时落到 `titleLabel`，而 `titleLabel.text` 跟随状态：normal 态测得 `(17, 21)`、selected 态测得 `(371, 21)` | 语义改为「测的是**当前状态**」 |

### 8.5 新发现的缺陷（原文未收录）

| 项 | 实测 | 说明 |
| --- | --- | --- |
| **`expandClickArea(.nan)` 让按钮完全点不动** | 按钮 `100×44`、扩展值 `NaN`：连**正中 (50,22)** 都返回 `false` | 现状产出 NaN 矩形，`contains` 恒 `false` 且**不回落到 `super`** |
| `expandClickArea(负值)` 会**缩小**热区 | 扩展 `-5`：点在按钮内 (2,2) 返回 `false` | 名为 expand、行为相反；`-inf` 同理 |

### 8.6 量化的其余结论

| 项 | 实测数值 |
| --- | --- |
| 「扩展区域超出父视图 bounds 时不生效」 | ①父视图 200×200、按钮底部露出 24pt，点落在按钮 frame 内 → **未被询问 0 次**；②父视图放大到 200×400 后同一点 → 命中 1 次；③点在父视图内、按钮 bounds 外 15pt（扩展 20pt 内）→ 命中 1 次 |
| 未设置扩展时的单次代价 | 500k 次 `point(inside:)`：`UIView` 基线 vs `UIButton`（走 Fdy 扩展路径）≈ **+46%**（0.0573s → 0.0823s；换一次运行 0.0577s → 0.0799s，**比例稳定、绝对值波动大，只看比例**） |
| `fdy_viewSize` 默认值分裂的实际差异 | 多行标题（200pt 宽、屏宽 402）：`button.fdy_viewSize()` = `(388, 21)`，`titleLabel!.fdy_viewSize()` = `(691, 21)` → **宽差 303pt** |
| 7.6 的未验证项：配置化按钮上 `point(inside:)` 是否受影响 | **不受影响**。`UIButton(configuration: .filled())` + `expandClickArea(20)`，直接调用与 `hitTest` 均命中了按钮外 10pt |
| `fdy_allStates` 实际内容 | 4 项 `[0, 4, 1, 2]` = normal / highlighted / selected / disabled；遗漏 `focused(8)`、`application(16711680)`、`reserved(4278190080)` |

### 8.7 批次 1 的改法（零破坏，已过编译与行为对照）

补丁：`docs/UIButton_Extensions_修复优化方案_批次1.patch`（2 文件，+34 / −29，`patch` 正反双向已验证）。

1. **关联键加 `nonisolated(unsafe)`**（`UIButton++.swift:8`）—— 全库同类写法剩余 **7 → 6** 处。
2. **`point(inside:)` 改 `guard` 短路**：

```swift
override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    guard let expandSize: CGFloat = fdy_GetAO(forKey: &FdyKeys.expandSizeKey), expandSize > 0 else {
        return super.point(inside: point, with: event)
    }
    return bounds.insetBy(dx: -expandSize, dy: -expandSize).contains(point)
}
```

   连带：`fdy_expandedRect()` 变成死代码，已删除（`internal`，库内唯一调用点就在本方法内）。
3. **`fdy_viewSize` 默认值统一**为 `.greatestFiniteMagnitude`，去掉对 `FdyScreen.screenWidth` 的隐式依赖。
   需要按屏宽折行的调用方显式传 `FdyScreen.screenWidth`。
4. **`fdy_allStates` 与注释层**：补上实际范围说明、`point(inside:)` 的两条限制说明（子类重写 / 父视图 bounds），语义不动。
5. **`FdyCreator.button()` 删掉 `.fdy.isHighlighted(false)`** —— 已核实 `isHighlighted(_:)` 是纯 setter、`build()` 只返回 `base`，
   新建按钮默认即非高亮，该语句既无作用也无副作用。

**等价性实测**（纯函数穷举 44660 组 `(bounds, size, point, superResult)` 组合）：

| 候选写法 | 与现状不一致 | 差异位置 |
| --- | --- | --- |
| `guard size != 0` | 28 / 44660 | 全部集中在「bounds 尺寸为 0 或 1pt」×「size = -5」的退化组合（`insetBy` 在零尺寸矩形上内缩产出 `inf`，手写算式产出负尺寸矩形） |
| **`guard size > 0`（采用）** | 6090 / 44660 | 正数扩展与未设置**完全一致**；差异全部是 `size = -5 / -inf / NaN` —— 现状「缩小热区 / 全 false」，新写法「回落 `super`」 |

即 **正数扩展域零差异**，差异只发生在无意义输入上，且新行为顺手修掉了 8.5 的两个缺陷。

**改前 / 改后对照**（同一探针二进制、同一模拟器，112 行有效输出 diff，仅 5 行不同）：

| 段 | 差异 |
| --- | --- |
| A–E、H | 逐字节一致 |
| F `fdy_viewSize()` | `(388, 21)` → `(691, 21)`；与 `titleLabel` 的宽差 303pt → **0** |
| I `expandSize=-5`，点 (2,2) | `false` → **`true`**（不再错误缩小热区） |
| I `expandSize=NaN`，点 (50,22) | `false` → **`true`**（按钮恢复可点） |
| G 性能 | 仅噪声（50.1ns ↔ 44.3ns） |

**其余验证**：250 文件整模块 `swiftc -typecheck`（与基线同参数）**0 error / 0 warning**；
`swiftformat --lint` 改动的 2 个文件 **0/2**；**公开 API 面 A/B** —— 同一段调用代码
（9 个工厂方法 + `fdy.expandClickArea` / `title` / `titleColor` / `font` / `backgroundImage` + `fdy_viewSize` / `fdy_allStates` / `FdyScreen.screenWidth`）
对着改前、改后两个模块**都能编译**。

### 8.8 批次 2：P0-1 的根治形态（待决策，未出补丁）

```swift
/// 需要扩大点击区域的按钮请使用本类型 —— 判定只在本类内生效，不污染全局 UIButton
open class FdyHitAreaButton: UIButton {
    /// 向四周扩展的尺寸；<= 0 表示不扩展
    public var fdy_expandSize: CGFloat = 0

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard fdy_expandSize > 0 else { return super.point(inside: point, with: event) }
        return bounds.insetBy(dx: -fdy_expandSize, dy: -fdy_expandSize).contains(point)
    }
}
```

配套：`UIButton+Chain.swift` 的 `expandClickArea(_:)` 从 `where Base: UIButton` 下移到 `where Base: FdyHitAreaButton`。

该形态已在探针中实测（D 段）：

| 场景 | 结果 |
| --- | --- |
| 未设置尺寸 | 走 `super`，与普通按钮一致 |
| 扩展 20 后判定 `x=-10` | `true` |
| **二级子类再 override 且调 `super`** | **`true`** —— 与 8.2 中扩展方案的 `false` 形成对照，这才是根治 |

**两个待决策项**：

1. **类放哪**：`Core/Common/` 的自我描述是「工具类（FdyScreen/FdyHelper/FdyPath…）」、`Core/Extensions/` 是「`fdy_` 前缀扩展」，
   两者都不合身；原方案用了一个不存在的 `Core/Components/`。建议新增 `Core/Components/`（需同步更新 README 的目录结构图），
   或先就近放进 `Core/Common/`。
2. **API 收敛方式**：把 `expandClickArea` 约束到 `FdyHitAreaButton` 后，`anyUIButton.fdy.expandClickArea(10)` 会**变成编译错误**
   —— 这正是目的（把「静默失效」提前到编译期），但要先确认使用方数量。库内引用只有 1 处（Chain 转发）；
   **`fdy-swift` 之外的使用方（自有 App 工程）本轮无法统计，需要大人确认**。
   若必须兼容既有调用点，过渡方案是保留 extension 实现并标 `@available(*, deprecated, message:)`，两个版本周期后再删。

### 8.9 本轮仍未做的

| 项 | 原因 |
| --- | --- |
| 使用方的 `expandClickArea` 调用点统计 | 需访问消费本库的 App 工程，不在当前工作区 |
| 全库其余 6 处关联键、46 个 `open class func` | 超出 UIButton 范围，应单独立项 |
| 真机复核 | 全部数据来自模拟器 |

---

## 九、落地记录（2026-09-17，分支 `Swift6`）

### 9.1 批次 1 落盘

**补丁文件已作废**：上一轮之后工作区出现一处改动 —— `public extension UIButton` → `private extension UIButton`、
`fileprivate enum FdyKeys` → `enum FdyKeys`、删除 `public var fdy_allStates`。
它使 `git apply --check docs/UIButton_Extensions_修复优化方案_批次1.patch` **失败**
（`error: while searching for: fileprivate enum FdyKeys`，hunk 1 上下文失配）。

大人拍板「保留」该改动，于是按最终态直接改文件，等价落地批次 1 的其余 4 项：

| # | 项 | 落地形态 |
| --- | --- | --- |
| 1 | 关联键加 `nonisolated(unsafe)` | `UIButton++.swift` 的 `expandSizeKey` |
| 2 | `point(inside:)` 改 `guard` 短路 | 同时删除因之成为死代码的 `fdy_expandedRect()` |
| 3 | `fdy_viewSize` 默认值统一 | `CGFloat? = nil`（`?? FdyScreen.screenWidth`）→ `CGFloat = .greatestFiniteMagnitude` |
| 4 | `FdyCreator.button()` 删无效语句 | 去掉 `.fdy.isHighlighted(false).build()` |

### 9.2 批次 2 落地：新增 `Sources/Fdy/Core/Components/FdyHitAreaButton.swift`

新建 `Core/Components/` 目录（README 目录结构图已同步）。类型形态即 8.8 所列，另外补了 `fdy_expandSize` 的链式入口。

### 9.3 API 收敛改用「更特化的重载」，而非直接下移

不采用 8.8 的「直接下移」，改为三条并存：

- `FdyWrapper where Base: FdyHitAreaButton` **新增** `expandClickArea(_:)`（写 `fdy_expandSize`）
- `FdyWrapper where Base: UIButton` 的同名方法标 `@available(*, deprecated, ...)`
- `UIButton.fdy_expandClickArea(_:)` 同样标 `@available(*, deprecated, ...)`

好处：迁移意图在**编译期可见**，但不产生硬编译错误，可平滑过渡；确认库外无调用方后删掉 deprecated 版本即完成 P0-1 根治。

### 9.4 实测（探针 `.build/regress2`，真实模块 `import Fdy`，iOS 18.0 与 26.5 **逐字节一致**）

| 用例 | 结果 |
| --- | --- |
| `FdyHitAreaButton` 未设 `fdy_expandSize` | 走 `super`：正中 `true`、外部 `-5` 为 `false` |
| 设 20 后判 `x=-10` / `x=-30` | `true` / `false` |
| 设 0（非正值） | 回落 `super`，**不缩小热区** |
| **二级子类 override 后调 `super`，判 `x=-10`** | **`true`** —— 与 8.2 中注入方案的 `false` 形成对照，这才是根治 |
| 链式 `fdy.expandClickArea(12)` | `fdy_expandSize == 12`，`x=-6` 为 `true`、`x=-20` 为 `false` |
| 旧注入入口 `fdy_expandClickArea(10)` / `(-5)` / `(.nan)` | 外部 `-5` 为 `true` / 外部 `false`+正中 `true` / 正中 **`true`**（批次 1 修掉了「NaN 让按钮彻底点不动」） |
| `FdyWrapper<FdyHitAreaButton>.fdy.expandClickArea(10)`（编译期） | **无警告**（命中特化重载） |
| `FdyWrapper<UIButton>.fdy.expandClickArea(10)`（编译期） | `warning: 'expandClickArea' is deprecated` |

`fdy_viewSize` 默认值变更的独立证据（长文本 30 字，自然宽 557pt > 屏宽 393pt）：

| 调用 | 结果 |
| --- | --- |
| `fdy_viewSize()` | `557 × 21`（**单行、不被屏宽截断**） |
| `titleLabel.fdy_viewSize()` | `557 × 21`，宽差 **0** |
| `fdy_viewSize(maxWidth: 100)` | `85 × 141`（折行 7 行，参数仍生效） |
| `fdy_viewSize(maxWidth: FdyScreen.screenWidth)` | `388 × 41`（折行 2 行，需要折行的调用方显式传入即可） |

### 9.5 本轮实测推翻 / 新增的一条判断

`fdy_expandClickArea(_:)` 定义在 `extension UIButton { ... }`（**没有** `public`）内，因此它是 **`internal`，库外无法调用**
（探针非 `@testable` 时实测报 `'fdy_expandClickArea' is inaccessible due to 'internal' protection level`）。
对外唯一入口只有 `.fdy.expandClickArea(_:)`。这同时回答了 8.8 的待决策项 2：
**库外不存在「裸方法」调用方**，需要盘点的只有 `.fdy` 链式入口。

### 9.6 仍未做

| 项 | 原因 |
| --- | --- |
| `fdy_allStates` 的替代入口 | 工作区已删除该 API，本轮未补 |
| 测试 target（P2-8） | 本轮仍以探针替代，未建 XCTest target |
| 真机复核 | 全部数据来自模拟器 |

> 「删除旧入口（P0-1 彻底根治）」已于 2026-09-17 完成，见 9.8。

### 9.8 P0-1 彻底根治（2026-09-17 落地）

按「两项能力都放进 `FdyHitAreaButton`、外面不留入口」的指令，本轮把 `UIButton` 扩展侧的
全局猴子补丁**整段删除**，并顺带把「防指定时间内重复点击」一并收进该类：

| 改动 | 结果 |
| --- | --- |
| `UIButton++.swift` 删 `FdyKeys` / `override point(inside:with:)` / `fdy_expandClickArea(_:)` | 文件由 73 行缩至 20 行，仅剩 `fdy_viewSize` |
| `UIButton+Chain.swift` 删 `FdyWrapper<UIButton>.expandClickArea` 与末尾 `FdyWrapper<FdyHitAreaButton>` 扩展 | 热区相关入口全部集中到 `Core/Components/FdyHitAreaButton.swift` |
| `FdyHitAreaButton` 新增 `fdy_repeatClickInterval` + 两个 `sendAction` 重载 | 防重复点击按业务动作分别计时，不挤占按压反馈的时间窗 |

实测证据（详见 `docs/FdyHitAreaButton_功能收敛方案.md`）：

- `class_copyMethodList` 证明 `UIButton` 自身已无 `pointInside:withEvent:`（H4a = `false`）——
  P0-1 描述的「类级注入、全局生效、无开关可关」不复存在。
- 裸 `UIButton` 点 `x = -10` 返回 `false`（H4g），而 `FdyHitAreaButton` 同点返回 `true`。
- 19 项行为断言在 iOS 18.0 与 26.5 上**逐行一致**。

### 9.7 新增发现：`UIButton.Configuration` 的链式扩展**当前不可达**

`FdyExtension` 全库只有两条 conformance：`extension NSObject: FdyExtension {}` 与 `extension Date: FdyExtension {}`。
`UIButton.Configuration` 是 **struct**，不继承 `NSObject`，也没有单独的 conformance，因此
`UIButton.Configuration.fdy.title("…")` **编译不过**（探针实测 `value of type 'UIButton.Configuration' has no member 'fdy'`），
而 `FdyWrapper.init` 是 `internal`，外部也无法手动构造。即
`Sources/Fdy/Core/Chain/UIKit/UIButton.Configuration+Chain.swift` 的 16 个方法**对外不可达**。
本轮只做了模板收敛（行为等价，`-typecheck` 与探针的 `FdyWrapper(配置)` 路径均已验证），
**是否补一条 `extension UIButton.Configuration: FdyExtension {}` 属于新增公开 API 面，需大人单独拍板**。
