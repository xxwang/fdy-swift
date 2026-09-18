# Changelog

本库遵循[语义化版本](https://semver.org/lang/zh-CN/)，格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)。

## [0.1.0] - 2026-09-18

**Fdy 首次发布。**

上一版 `Dy` 0.0.2 是 4 个 target、iOS 13 起的多模块库；本版是彻底重构 ——
包名、模块结构、命名空间前缀、平台门槛全部变更，**不提供渐进迁移路径**。

### 破坏性变更

> **范围说明**：下面「包与平台」「命名空间重命名」两节严格说是 `Dy` → `Fdy` 的**沿革变更**
> （`0.0.2` 从未以 `Fdy` 之名对外发布过），列在此处只为让升级者一次看全全部差异；
> 「零全局符号」「运算符 → 具名方法」「构造器 / 下标加前缀」「删除与系统重复的转换方法」四节
> 才是**本次 0.1.0 真正引入的破坏面**。

#### 包与平台

- 包名 `Dy` → `Fdy`；`DyCore` / `DyLogger` / `DyComponent` / `DyTemplate` 四个 target **合并为单一 target `Fdy`**
- 最低平台 iOS 13 → **iOS 18**；swift-tools-version 5.10 → 6.0（Swift 语言模式 v5）
- 目录平铺为 `Sources/Fdy/{Chain, Combine, Common, Components, Extensions, Logger, Protocols}`

#### 命名空间重命名

| 原 | 现 |
|---|---|
| `import DyCore` / `DyLogger` / `DyComponent` / `DyTemplate` | `import Fdy` |
| `x.dy` | `x.fdy` |
| `DyWrapper<T>` | `FdyWrapper<T>` |
| `DyExtension` | `FdyExtension` |

#### 零全局符号

全库不再向宿主命名空间铺设任何符号 —— 接入后**不会因撞名导致编译失败**：

- 删除 **55 个运算符重载**、**2 个 `precedencegroup`**、**2 个顶层自由函数**（`CATransform3D` 的 `==` / `!=`）
- **33 个 `init`** 与 **8 个 `subscript`** 一律加 `fdy_` 前缀（前缀写在**首个参数标签**上，内部参数名保持自然名）
- 运算符一律改为 `fdy_` 具名方法（非变异用现在式、变异用祈使式）
- 唯一保留的运算符：`FdyLogLevel.<` —— 作用在本库自有类型上，宿主撞不到名

#### 运算符 → 具名方法

| 原写法 | 现写法 |
|---|---|
| `p1 + p2` / `p1 += p2` | `p1.fdy_adding(p2)` / `p1.fdy_add(p2)` |
| `p1 - p2` / `p1 -= p2` | `p1.fdy_subtracting(p2)` / `p1.fdy_subtract(p2)` |
| `size * 2` / `size *= 2` | `size.fdy_scaled(by: 2)` / `size.fdy_scale(by: 2)` |
| `size1 * size2` | `size1.fdy_multiplied(by: size2)` |
| `size / 2` | `size.fdy_divided(by: 2)` |
| `-vector` | `vector.fdy_negated()` |
| `"ab" * 3` | `"ab".fdy_repeated(3)` |
| `dict1 + dict2` | `dict1.fdy_merging(dict2)` |
| `dict1 - keys` | `dict1.fdy_removing(keys: keys)` |
| `text =~ "\\d+"` | `text.fdy_isMatch(pattern: "\\d+")` |
| `text ~= regex` | `text.fdy_matches(regex)` |
| `pred1 + pred2` / `!pred` | `pred1.fdy_and(pred2)` / `pred.fdy_not()` |
| `property <<< publisher` | `property.bind(from: publisher)` |
| `transformA == transformB` | `transformA.fdy_isEqual(to: transformB)` |
| `optional ?= value` | `optional.fdy_assignIfNotNil(value)` |
| `optional ??= value` | `optional.fdy_assignIfNil(value)` |
| `optional == rawValue` | `optional.fdy_isEqual(to: rawValue)` |

#### 构造器 / 下标加前缀（示例）

| 原写法 | 现写法 |
|---|---|
| `UIColor(hex:)` | `UIColor(fdy_hex:)` |
| `UILabel(text:)` | `UILabel(fdy_text:)` |
| `CGRect(center:size:)` | `CGRect(fdy_center:size:)` |
| `Date(timestamp:)` | `Date(fdy_timestamp:)` |
| `CATransform3D(tx:ty:tz:)` | `CATransform3D(fdy_tx:ty:tz:)` |
| `str[safe: 1]` | `str[fdy_safe: 1]` |
| `arr[offset: 1]` | `arr[fdy_offset: 1]` |
| `str[range: 1..<4]` | `str[fdy_range: 1..<4]` —— 安全子串，越界返回 `nil` |
| `arr[range: 1..<3]` | `arr[fdy_slice: 1..<3]` —— 切片，返回 `SubSequence` |
| `dict[path: ["a"]]` | `dict[fdy_path: ["a"]]` |

> 下标前缀必须写成**双词**形式（`subscript(fdy_safe index: Int)`）——
> 单名下标在 Swift 中**没有外部标签**，`subscript(fdy_x: T)` 与 `subscript(_: T)` 是同一个符号。

#### 删除与系统重复的转换方法

| 原写法 | 现写法 |
|---|---|
| `n.fdy_Int()` | `Int(n)` |
| `n.fdy_Int64()` | `Int64(n)` |
| `n.fdy_UInt()` | `UInt(n)` |
| `n.fdy_UInt64()` | `UInt64(n)` |
| `n.fdy_Float()` | `Float(n)` |
| `n.fdy_Double()` | `Double(n)` |
| `n.fdy_CGFloat()` | `CGFloat(n)` |
| `table.fdy.removeTableHeaderView()` | `table.fdy.tableHeaderView(nil)` |
| `table.fdy.removeTableFooterView()` | `table.fdy.tableFooterView(nil)` |

- `BinaryInteger` / `BinaryFloatingPoint` 上**各 7 个**（共 14 个）转换方法删除：系统构造器**更短**，
  包装零收益；且与 `String.fdy_Int()`（**解析失败静默返回 `0`**，语义完全不同）同名异义，极易误用
- `UITableView` 链式的 `removeTableHeaderView()` / `removeTableFooterView()` 删除：与 `tableHeaderView(nil)` 完全等价
- **刻意保留**：`Date` 的 8 个日历谓词（`fdy_isToday` 等）与 `String.fdy_nsRange(from:)` ——
  系统写法长 3–5 倍（`Calendar.current.isDateInToday(d)` vs `d.fdy_isToday()`），删掉是净损失；理由已写进各自 `doc`

### 有意损失

- **翻转方向消失**：`2 * point` / `2 * size` / `2 * vector` / `3 * "ab"` 不再可用
- **`switch` 中的正则字符串静默降级**：删除 `String ~= String` 后，`switch text { case "\\d+": }`
  由「正则命中」变为「字面量相等」，**且不报编译错**。需要正则请写 `if text.fdy_isMatch(pattern:)`
- `CATransform3D` 的 `a == b` / `a != b` 不可用，改 `a.fdy_isEqual(to: b)`
- 下标不再有「同一表达式因上下文返回不同类型」的隐性行为（`fdy_range` 与 `fdy_slice` 已分离）

### 新增

- **`bind(from:)` 形参放宽为泛型**：`AnyPublisher<Value, Never>` → `P: Publisher where P.Output == Value, P.Failure == Never`。
  `Published.Publisher`、`Subject`、库自有的 `FdyControlEvent`、以及 `map`/`filter` 中间流现在都能**直接传入**，
  不再需要 `.eraseToAnyPublisher()`（旧签名下连 `FdyControlEvent` 自己都传不进去）。旧写法（传 `AnyPublisher`）不受影响。
- **值类型 `.fdy` 命名空间**：`FdyExtension` conformance 新增 **23 条**、总量达 **29 条**，
  `FdyWrapper.with(_:)` / `do(_:)` / `build()` 对值类型**真正可用**（此前文档示例用的是未登记类型，实际编不过）
  新增登记：`CGPoint` `CGSize` `CGRect` `CGVector` `CGAffineTransform` `CGColor` `CGPath` `CGImage`
  `Array` `Dictionary` `Character` `Bool` `Optional` `Range` `ClosedRange`
  `Data` `Decimal` `IndexPath` `Measurement` `NSRange` `URL` `URLRequest` `UUID`
- `UIScrollView.contentOffsetClamped(_:animated:)` —— 裁剪式滚动；`contentOffset(_:animated:)` 改为**直传不裁剪**，对齐 UIKit 语义
- `FdyViewBuilder` 补 `buildExpression`，调用侧 `if` / `if-else` / `for` 现在可编译
- `UIView` 补 `right(_:)` / `bottom(_:)` 链式约束
- `UICollectionView` 的 `scrollEdgeAppearance(_:)` —— 原无参版本改名 `scrollEdgeAppearanceSynced()`

### 修复

- **滚动语义统一**：`contentOffset` 只保留 `UIScrollView` 一处；`scrollTo{Top,Bottom,Left,Right}` 统一在 `UIScrollView` 并计入 `contentInset`，`animated` 默认 `true`；删除子类重复定义
- `contentOffsetClamped` **修正上界公式**（原式漏减 `bounds` 尺寸，能滚出可视区）
- `UITextView.scrollToTop/Bottom` 改名 `scrollToTextStart/End`，并**修 UTF-16 索引 bug**（原用字素簇计数当 `NSRange.location`）
- `UIRefreshControl.stopRefreshing` 回落点改为 `-contentInset.top`
- `NSMutableAttributedString` 段落属性改为**增量修改**（新增 `fdy_updateParagraphStyle` helper），`alignment` 改可选 —— 不再把居中文本静默掰回左对齐
- `FdyAppVersion` 支持 1…3 段补零解析（修 2 段版本号 `fdy_isNewVersion` 恒 `false`）
- `FdyPermissionChecker.finishLocationAuth` 改为锁外回调（**修真实死锁**：原持锁期间跑外部回调，回调内再请求定位即撞非递归锁）
- `FdyScreenCaptureMonitor` 补 `deinit` 注销观察者
- `UIAlertController.show(from:)` 竞态修复（检查移入 async 块）
- `FdyAppearance` 改为直接赋值窗口（实测 `appearance()` 代理对 `overrideUserInterfaceStyle` **不生效**）
- `UIImageView.blur/removeBlur` 打标记，只删自建视图
- **水印 / 粒子发射器不再误删宿主图层**（`Extensions/UIKit/UIView/UIView+Effects.swift`）：原先按 `layer.name` 判定归属 ——
  水印用 `"dy.watermark"`、发射器用 `"emitter" || $0.name == nil`，后者会**连同宿主所有未命名的 `CAEmitterLayer` 一起删掉**。
  现改用私有子类类型标记（`FdyWatermarkLayer` / `FdyEmitterLayer`），归属判定一律 `is` 类型，撞车与误删都不可能发生
- `UITabBar` 状态分支补 `else`
- `Timer.mode(_:)` → `addToCurrentRunLoop(mode:)` 并补 `invalidate()`
- `CALayer.masksToBounds` 去默认值；`UITableView.separatorStyle` 去默认值
- 删除 `fdy_captureScreenshot` 等链式方法的冗余 `@MainActor` 标注
- 删除 **10 类零引用 API** 与 **7 处子类逐字重复父类**的定义（`tintColor` ×4、`UILabel.sizeToFit`、`UIStackView` ×2 等）
- 删除 `UIRefreshControl.add2` 空实现、`CAShapeLayer.fillColor` 的 `CGColor` 重载（消除 `fillColor(nil)` 歧义）
- 修正 `ffdy_loadViewController` 拼写 → `fdy_loadViewController`
- `FdyScreen.widthRatio` → `adaptiveRatio`；`secureTextEntry` → `isSecureTextEntry`；
  `UILabel.shadowColor/shadowOffset` → `textShadowColor/textShadowOffset`（区分图层阴影）；
  `UIStackView` 两处补 `is`；`String+Hash.swift` → `String+Base64.swift`（文件名与内容不符）

### 并发

- `FdyGlobal` 撤掉 `@unchecked Sendable`
- `fdyG` 的 `screen` / `appearance` / `skinManager` / `screenCaptureMonitor` / `haptic` 标 `@MainActor`，**须在主线程调用**
- `FdyScreen` / `FdyAppearance` / `FdyScreenCaptureMonitor` 整类标 `@MainActor`；`FdyHelper` 改成员级标注（整类会误伤非 UI 成员）
- `FdyPath` 的 8 个 `lazy var` 改 `let`（消除并发首访竞争）；`FdyScreen.tabBarHeight` 改 `let`

### 已知限制

- Combine 手势 publisher **已端到端验证**（早先「只验证到挂载」的结论已推翻）：探针 `S26a/b` 从识别器私有 ivar
  `_targets`（`NSMutableArray`，对象类型故 KVC 取值安全）取出库注册的 `(target, action)`，
  正向调用 `ClosureTarget.invoke(_:)` —— 这与 UIKit 自己的派发路径等价。
  **7 个访问器（`tap`/`swipe`/`longPress`/`pan`/`pinch`/`rotation`/`screenEdgePan`）全部触发**，
  iOS 18.0 / 26.5 输出逐行一致，整条 `target-action → invoke → flush → receive → sink` 链路成立。
  （早先的 `S25c` 对照实验只证明了 `_setState:` 这个**手法**不派发 action，推不出「链路无法验证」。）
  **仍未闭环**：`UIStepper` / `UISegmentedControl` 的**真实点击** —— 它们不经 `UIGestureRecognizer`，
  上述路径覆盖不到，需 XCUITest；本库对它们的覆盖是程序化写值。
- `docs/工业级_代码治理方案.md` 中引用的验证脚手架（`.build/structprobe/`：6 个跨模块探针 + 1 个行为探针 app）为**本机路径，不入库**

[0.1.0]: https://github.com/xxwang/fdy-swift/releases/tag/0.1.0
