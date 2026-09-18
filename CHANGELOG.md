# Changelog

本库遵循[语义化版本](https://semver.org/lang/zh-CN/)，格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)。

## [未发布]

### 破坏性变更 —— 类型转换方法统一为 `fdy_toXXX`

类型转换方法的命名原先混着 **4 套**（裸大驼峰 `fdy_Decimal()`、裸小写 `fdy_date()`、`to` 前缀、`as` 前缀），
现统一为 **`fdy_to` + 返回类型原名**，**类型前缀一律保留**（`UI` / `NS` / `CG` / `CA`）。

规模：**60 处定义 / 30 个唯一旧名 / 31 个唯一新名**。完整对照表与决策依据见
`docs/类型转换命名规范_改造方案.md`。

| 旧名 | 新名 |
|---|---|
| `fdy_bool` / `fdy_Int` / `fdy_Float` / `fdy_Double` | `fdy_toBool` / `fdy_toInt` / `fdy_toFloat` / `fdy_toDouble` |
| `fdy_String` | `fdy_toString` |
| `fdy_Character` / `fdy_Characters` | `fdy_toCharacter` / `fdy_toCharacters` |
| `fdy_NSNumber` / `fdy_NSDecimalNumber` / `fdy_Decimal` | `fdy_toNSNumber` / `fdy_toNSDecimalNumber` / `fdy_toDecimal` |
| `fdy_CGPoint` / `fdy_CGSize` | `fdy_toCGPoint` / `fdy_toCGSize` |
| `fdy_date` | `fdy_toDate` |
| `fdy_URL` / `fdy_URLRequest` / `fdy_NotificationName` / `fdy_NSString` | `fdy_toURL` / `fdy_toURLRequest` / `fdy_toNotificationName` / `fdy_toNSString` |
| `fdy_NSAttributedString` / `fdy_NSMutableAttributedString` | `fdy_toNSAttributedString` / `fdy_toNSMutableAttributedString` |
| `fdy_nsRange` / `fdy_range` | `fdy_toNSRange` / `fdy_toRange` |
| `fdy_UIImage` / `fdy_UIColor` | `fdy_toUIImage` / `fdy_toUIColor` |
| `fdy_CGPath` / `fdy_CGMutablePath` | `fdy_toCGPath` / `fdy_toCGMutablePath` |
| `fdy_cACornerMask` / `fdy_UIRectCorner` | `fdy_toCACornerMask` / `fdy_toUIRectCorner` |
| `fdy_asCurrency` | `fdy_toCurrencyString` |

**两个旧名同时映射到两个新名**（按接收者区分，不能全库替换）：

| 旧名 | 接收者 | 新名 |
|---|---|---|
| `fdy_Data` | `String` | `fdy_toData`（UTF-8 编码） |
| `fdy_Data` | `Array` / `Dictionary` | `fdy_toJSONData`（`JSONSerialization` 产物） |
| `fdy_string` | `Data` / `Date` | `fdy_toString` |
| `fdy_string` | `Encodable` | `fdy_toJSONString`（`JSONEncoder` 产物） |

**下列同名成员刻意不改**（与改名族同名异义，行为未变）：

- `Date.fdy_date(from:)` / `Date.fdy_string(from:format:)` —— static 时间戳**解析**工厂；
- `String.fdy_Character(at:)` —— **截取**，返回 `String`（不是 `Character`）；
- `NSNumber.fdy_Decimal(groupingSeparator:…)` —— **格式化**，返回 `String?`；
- `BinaryInteger.fdy_range(from:)` / `(to:)` —— 区间**构造**；
- 下标标签 `fdy_range` / `fdy_slice` 不受影响（不是方法名）。

本版**不提供** `@available(*, deprecated, renamed:)` 别名 —— 与 0.1.0 已声明的
「不提供渐进迁移路径」策略一致。下文 0.1.0 段中出现的类型转换旧名，以本段对照表为准。

### 新增 —— 外观配置系链式（链式补全第 3 批）

新增 6 个 Chain 文件、**138 个链式方法**，覆盖导航栏/标签栏外观与列表内容、空态配置。
本批**只新增文件**，未改动任何既有实现。

| 类型 | 文件 | 语义 | 方法数 |
| --- | --- | --- | --- |
| `UIBarAppearance`（基类） | `Chain/UIKit/UIBarAppearance+Chain.swift` | 引用 —— 就地改，免 `build()` | 10 |
| `UINavigationBarAppearance` | `Chain/UIKit/UINavigationBarAppearance+Chain.swift` | 引用（另继承基类 10 个） | 13 |
| `UITabBarAppearance` | `Chain/UIKit/UITabBarAppearance+Chain.swift` | 引用（另继承基类 10 个） | 8 |
| `UIBackgroundConfiguration` | `Chain/UIKit/UIBackgroundConfiguration+Chain.swift` | **值** —— 须 `build()` 取回 | 19 |
| `UIListContentConfiguration` | `Chain/UIKit/UIListContentConfiguration+Chain.swift` | **值** | 45 |
| `UIContentUnavailableConfiguration` | `Chain/UIKit/UIContentUnavailableConfiguration+Chain.swift` | **值** | 43 |

嵌套 struct 轴按既有约定**拍平加前缀**（先例：`UIButton.Configuration` 的 `backgroundCornerRadius`）：
`textProperties.font` → `textFont(_:)`、`imageProperties.tintColor` → `imageTintColor(_:)`、
`buttonProperties.role` → `buttonRole(_:)`、`shadowProperties.radius` → `shadowRadius(_:)`。

**新增 3 条 `FdyExtension` conformance（29 → 32 条）**：`UIBackgroundConfiguration` /
`UIListContentConfiguration` / `UIContentUnavailableConfiguration` —— 三者 Swift 侧均为 **struct**，
不继承 `NSObject` 那条；**漏登记时不会编译失败**，只表现为 `.fdy` 不可达。

**实测纠正（推翻本库文档既有结论）**：`UIBackgroundConfiguration.shadowProperties` 的 ObjC 头文件标注为
`readonly`，**但同一 SDK 的 Swift 接口是 `{ get set }`**，`configuration.shadowProperties.radius = 4`
实测可编译 —— **以编译器为准**。本批按可写实现并覆盖全部 5 个阴影属性；README 原先
「未覆盖的只剩 `background.shadowProperties`（只读属性）」的表述已随之订正。

**可用性标注（逐条反证实测，不是照抄头文件）**：

| 成员 | 要求版本 | 反证结果（去掉 `@available` 后的报错） |
|---|---|---|
| `UIBarAppearance.overrideUserInterfaceStyle` | iOS 27.0 | `'overrideUserInterfaceStyle' is only available in iOS 27.0 or newer` |
| `UINavigationBarAppearance.subtitleTextAttributes` | iOS 26.0 | `… is only available in iOS 26.0 or newer` |
| `UINavigationBarAppearance.largeSubtitleTextAttributes` | iOS 26.0 | 同上 |
| `UIToolbarAppearance.prominentButtonAppearance` | iOS 26.0 | 同上 |

行为探针新增 `S40`–`S43`（值语义 vs 引用语义对照、嵌套轴写回、主副轴不串扰、子类继承父类扩展），
双运行时判定集 51 → **55 行**。

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
- **常用类链式补全（第 1–2 批，共 8 个类 / 8 个文件 / 101 个新增方法）**：
  - 第 1 批（P0 控件与几何，68 个）：`UIColor`(5) `UIFont`(5) `UIImage`(30) `UIBezierPath`(17) `UIStepper`(7) `NSLayoutConstraint`(4)
  - 第 2 批（P0 集合视图，33 个）：`UICollectionViewCell`(10，新建) `UITableViewCell`（1 → 24，整体重写）
  - `UIImage` 链式在底层 `fdy_*` 返回 `nil` 时（如越界裁剪）**保留原图并继续**，不会静默换成空图
  - `UIStepper` 的三个数值 setter 对非法值**先 `guard` 再静默忽略** —— 裸写 `base.stepValue = 0` 会抛
    `NSInvalidArgumentException` **直接终止进程**（Swift catch 不住），链式版比裸属性更安全是主动设计
  - `UICollectionViewCell` **没有** `setSelected(_:animated:)` / `setHighlighted(_:animated:)`（`UITableViewCell` 独有），
    其链式只暴露属性形态，**不带 `animated` 形参**

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
  **`UIStepper` / `UISegmentedControl` 已闭环到边界**（探针 `S27`–`S29`，iOS 18.0 / 26.5 逐行一致）：
  `.valueChanged` 通道本身经 `_emitValueChanged` 实测可用（`S27`）；改值 / 改索引 → publisher 可收到
  （`S28` 走 KVO 通道，`S29` 亦同）。**仍未被覆盖的只有「手指触摸 → UIKit 发 `.valueChanged`」这一环**
  —— 控件不在真实窗口层级、没有真实触摸序列时复现不出（`S29` 把这条边界固定成断言），需 XCUITest；
  本机无 `idb`/`fbsimctl`，`simctl` 无触摸子命令，`osascript` 被 TCC 拒，故未落地。
- iOS 26.5 将 `UIStepper` 换成 DesignLibrary 实现（`UIStepperDesignLibraryVisualElement` +
  `UICoreHostingView<DesignLibraryStepper>`，无 `_UIStepperButton`）。本库对它的支持只依赖 KVO 与
  `.valueChanged`、不碰私有视图结构，因此不受影响。
- **表格 cell 上两个读回值不受控的属性**（链式只是直传，UIKit 会自行改写，**别拿读回值当断言**）：
  - `UITableViewCell.separatorInset`：`left` 传 `16` 读回 `24`；`right` 传 `8` 在 iOS 18.0 读回 `8.0`、
    在 26.5 读回 `16.0` —— **改写规则随系统版本变**。
  - `indentationLevel` / `indentationWidth`：**不做钳位**，`-3` 读回 `-3`、`5` 读回 `5.0`。
- **`backgroundView` 与 `backgroundConfiguration` 双向互斥、后设者赢**：设 `backgroundView(_:)` 会把
  `backgroundConfiguration` 清成 `nil`，反向同理（`UITableViewCell` / `UICollectionViewCell` 实测一致）。
  想稳定生效只能二选一。
- `docs/工业级_代码治理方案.md` 中引用的验证脚手架（`.build/structprobe/`：8 个跨模块探针 + 1 个行为探针 app）为**本机路径，不入库**

[0.1.0]: https://github.com/xxwang/fdy-swift/releases/tag/0.1.0
