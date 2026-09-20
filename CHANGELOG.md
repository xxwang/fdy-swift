# Changelog

本库遵循[语义化版本](https://semver.org/lang/zh-CN/)，格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)。

## [未发布]

### 注释（续 2）—— 按「参数名词典 + 返回类型表」批量铺（第二十五轮）

承接上一条的「1034 个成员须人写」，把其中**机械可推**的全部铺完：

| 项 | 处数 |
|---|---|
| 重建成员 | **965**（分布 156 文件） |
| ├ 补参数项 | 731 |
| └ 补 `- Returns` | 886 |
| 其中由措辞词典产出 | 719（参数名/类型名词 591 · 「要设置的<摘要>」兜底 128） |
| 仍须人写 | **35** |

**不变量**（落盘前后逐文件比对）：文件清单 288 不变 · **代码 token 逐行相同** ·
`swiftc -typecheck` **0 error / 3 warning** · `swiftformat --lint` **0/288**。
工具复跑为**不动点**（第二次 `--report` 报 0 改动）。

**零行为变更**，不进破坏性清单。残余 35 条的逐条处置见下条「注释（续 3）」。

### 注释（续 3）—— 人撰残余 + 长块压缩 + 历史叙述清理（第三十二轮）

| 项 | 量 |
|---|---|
| 人撰补完残余 | **15 条**（10 条补摘要 + 5 条补 tag；**纯新增 15 行 `///`、删除 0 行**、11 文件） |
| `//` 长块（>5 行）压缩 | **3 处**：`UIBezierPath+Chain` 11→3 行 · `FdyFileDestination` 9→4 行 · `UIBackgroundConfiguration+Chain` 5→4 行；**现全库 >5 行块为 0** |
| 历史叙述清除 | **3 处**（`String+SandboxPath` / `UIView++` / `String+Splitting`）—— 都是「讲注释自己曾写错」的段落 |

⚠️ **订正**：§二 原列 11 条中有 **1 条是解析器误报**（`UIToolbarAppearance+Chain.doneButtonAppearance`
本来就有摘要，被 `@available` + `@discardableResult` **两行连续属性**夹断）→ **实落盘 10 条**。
落盘后：① **0 error / 3 warning** · ② **0/288** · ⑤ **118 行 IDENTICAL**。

### ⚠️ `0.2.0` 破坏性变更（定稿）

| # | 项 | 状态 |
|---|---|---|
| 1 | `FdyLocationPermissionType` 别名删除（纯等价、零增益） | **已落地** |
| 2 | `FdyTuple2…5` · `FdyAction3…5` · `FdyFunc3…5` | **已复原、不删** —— 前批「零内部引用 ⇒ 可删」的判据已作废（公开库的成员就是产品） |
| 3 | `UISwitch.title(_:)` | **库内本就不存在**（属批次缺口候选），按决议**不新增**（仅 Catalyst Mac idiom 支持，真 iOS 上抛异常） |
| 4 | `UUID++.swift` 被暂存删除 → `UUID: FdyExtension` 登记消失，conformance 由 33 条变 32 条 | **待维护者处置**（工作区既有改动，非本批引入） |
| 5 | `String+Pasteboard.swift` 平台条件编译被抹平（全库 `os(macOS)` 零命中） | **待维护者处置**（工作区既有改动，非本批引入） |
| 6 | `String` 的 `[fdy_range: NSRange]` 改名 **`[fdy_nsRange: NSRange]`** —— 原与 Character 版共用 `fdy_range` 标签，调用方读代码看不出是 UTF-16 口径。改后 `fdy_range` 单一含义 = `Character` 序号，与 `fdy_toNSRange` / `fdy_nsRanges` / `fdy_fullNSRange` 等 NS 系命名对齐 | **已落地** |

> 4、5 均有逐文件 diff / mtime 证据（均为工作区既有改动，与注释批次无关）。若维持现状，`0.2.0` 必须把 4、5 一并
> 写进破坏性清单；若恢复，则不进清单。
> 6 是**可读性驱动**的破坏性改名（原写法语法上仍靠参数类型区分，并非 bug）—— 回滚办法：
> `git checkout HEAD -- Sources/Fdy/Extensions/Stdlib/String/String+Subscript.swift`，并还原探针
> `subscript_probe.swift` / `String+Range.swift` 的口径注释。

### 注释 —— 全库按 Xcode 标准格式重建（`- Parameter` / `- Returns` / `- Throws`）

第 7 批注释重写曾按**子项**逐条删除「复述型」`- Parameter`，但 `- Parameters:` **块头只在整块
清空时才删** —— 于是留下 **1175 个「块还在、子项缺一半」的成员**：**看起来完整、实则有缺项**。

现按 Apple DocC / Xcode「Add Documentation」的标准格式重建：

| 项 | 处数 |
|---|---|
| 补参数项（逐字取自重写前版本） | 750 |
| 补 `- Returns`（其中 `-> Self` 族 153） | 882 |
| tag 顺序规范化（固定 `参数 → Returns → Throws`） | 140 |

涉及 **173 文件**，改动**仅限 `///` 行** —— 全库代码行 `sha256` 指纹与逐文件代码行数**一字未变**，
另用「新增说明文本是否全部来自重写前版本」交叉校验（777/777 命中，**零编造**）。
**零行为变更**，不进破坏性清单。依据与校验见内部治理方案 §8.20。

仍未撰写 **1034 个成员**的参数/返回值说明（重写前版本里也从无文本，须人写）。

### 注释（续）—— 机械补全收尾：修「外部标签当形参名」+ 统一 `- Returns` 文案

承接上一条，做掉**不需要拍板**的部分，共 **58 个成员 / 14 个文件**：

| 项 | 处数 |
|---|---|
| doc 把**外部标签**当形参名写 → 改回**内部形参名** | **21**（18 个成员） |
| `当前实例(支持链式调用)` / `当前实例` 等旧文案 → `` `Self` `` | **32** |
| 补 `- Returns:`（文本取自重写前版本，或 `-> Self` 的既有同文案） | **8** |

**「外部标签当形参名」是真缺陷**：`func fdy_showStoreProduct(for appId:, from viewController:)`
的注释写成 `- from: …` —— DocC 读到的是「有个叫 `for` 的参数不存在，而 `viewController` 没有文档」。
逐条改名如 `then→completion` · `on→queue` · `execute→work` · `to→value/scale/angle/bounds` ·
`with→padding` · `by→transform`。

⛔ **没有给「参数说明仍缺」的 472 个成员补 `- Returns:`** —— 那会造出「有 Returns、无参数说明」
的成员，即**看起来完整、实则有缺项**，与上一条被修的缺陷同类。工具留了 `--p1-partial` 开关，
口径若定，一条命令可补。

**零行为变更、零 API 变更**，不进破坏性清单。依据与校验见内部治理方案 §8.21。

### 注释（续）—— 修「注释名指向不存在的参数」+ 连带补全

复核上一条遗留的 23 条时，发现**旧审计器的判定不可信**（它自身有两个解析 bug：跨行签名只读
第一行、`->` 里的 `>` 被当泛型闭合）。用新写的只读样本器重核，**23 条 = 19 条真缺陷 + 4 条误报**：

| 项 | 处数 |
|---|---|
| **注释名指向不存在的参数**（外部标签 15 + 简化名 4）→ 改成**真实形参名** | **19** |
| 改名后暴露的可补项（`- Returns: \`Self\`` ×16 + `- color:` 等 ×7，文本全部取自库内既有） | **23** |

**这是真缺陷**：`func font(_ font: UIFont?, for range: NSRange? = nil)` 的注释写成 `- for:` ——
DocC 读到的是「有个叫 `for` 的参数不存在，而 `range` 没有文档」。
逐条改名如 `for→range`（×13）· `toOccurrencesOf→target` · `at→index` ·
`work→task` · `token→deviceToken` · `behavior→contentInsetAdjustmentBehavior` ·
`identifier→largestUndimmedDetentIdentifier`。

> ⚠️ 订正：上一条曾记「余 23 条多为**改名会撞名**」—— **实核后没有一处撞名**，
> 真实情况是「改名后**仍缺其它参数说明**」（缺项，非撞名）。原文保留，此处订正。

共 **42 处 / 6 个文件**（增 42 行 / 删 19 行）。**零行为变更、零 API 变更**，不进破坏性清单。
依据与校验见内部治理方案 §8.22；决策样本见内部决策记录。

### 破坏性变更 —— 断言策略统一（`assertionFailure` 17 处 → 2 处）

判据是**两个正交维度**：`guard` 是否**可达**、降级返回调用方能否**辨认**。

**改 `preconditionFailure`（14 处）**：

| 位置 | 处数 | 改前的降级返回 |
|---|---|---|
| `UITableView` 复用 | 3 | `T()` 裸 cell |
| `UICollectionView` 复用 | 2 | `T()` 裸 cell |
| `Timer.fdy_countdown` | 1 | `Timer()`（`isValid == false`；`RunLoop.main.add` 它会**段错误**） |
| `FdyLoadable.fdy_loadView` / `fdy_loadViewController` | 3 | `Self(frame: .zero)` / `Self()` |
| `UILabel.fdy_blend` | 1 | 空属性串 |
| `Character.fdy_random` | 1 | `"a"` |
| `UIApplication.fdy_call` | 1 | `completion?(false)` |
| `UIView+Effects`（`badgeLabel` / `.spring` 分支） | 2 | `return` / 无 |
| `CAGradientLayer` 空 `colors`（此前已改） | 1 | 未配置图层 |

**保留 `assertionFailure`（2 处）**：`Dictionary.fdy_toJSONData`（返回 `nil`，调用方判空即可）、
`MKMapView.fdy_dequeueReusableAnnotationView`（返回功能完整的新 view，降级可用）。

**行为影响**：调用方编程错误（未注册 / 类型不符 / 参数非法）在 **Release 下也会中止**，
不再静默返回假对象。正常路径经端到端实测（`-O`，iOS 18.0 与 26.5）**逐字节一致**。
分类依据与实测数据见内部治理方案 §8.19。

### 破坏性变更 —— 类型转换方法统一为 `fdy_toXXX`

类型转换方法的命名原先混着 **4 套**（裸大驼峰 `fdy_Decimal()`、裸小写 `fdy_date()`、`to` 前缀、`as` 前缀），
现统一为 **`fdy_to` + 返回类型原名**，**类型前缀一律保留**（`UI` / `NS` / `CG` / `CA`）。

规模：**60 处定义 / 30 个唯一旧名 / 31 个唯一新名**。完整对照表见下，决策依据见内部改造方案。

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

### 破坏性变更 —— 字符串四则运算的返回类型改为 `String?`

| 方法 | 旧行为 | 新行为 |
|---|---|---|
| `fdy_add(_:)` / `fdy_subtract(_:)` / `fdy_multiply(_:)` | 任一操作数非法时**抛 `NSDecimalNumberOverflowException` 终止进程** | 返回 `nil` |
| `fdy_divide(_:)` | 除数为 `0` 时静默返回 `self` | 返回 `nil` |

「非法输入」= `nil`、空串、或不是合法十进制数字的字符串。旧实现把 `nil` 当空串，
`NSDecimalNumber(string: "")` 得到 `NaN`，随后 `decimalNumberByAdding:withBehavior:` 抛 ObjC 异常 ——
**Swift 的 `try` 捕不住，进程直接终止**。实测五条路径（`add(nil)` / `add("")` / `add("abc")` /
`subtract(nil)` / `multiply(nil)`）全部崩溃；只有 `fdy_divide` 因原本就有 guard 而幸存。

### 破坏性变更 —— `fdy_urlEncoded()` 收紧字符集

从 `.urlQueryAllowed` 中额外剔除 `&` `=` `+` `?` `#`。旧实现下 `"a&b=c+d?e"` **一个字符都不被编码**，
若把它拼进 `?q=...` 作为参数值，值里的 `&` 会被对端解析成新参数 —— **参数注入**。

### 修复 —— 静默失效与实测缺陷

- **`fdy_isValidNickname` 此前恒返回 `false`**：正则写成了原始字符串里的 `\u{4e00}`，
  ICU 不认带花括号的 `\u{...}`，编译失败后走「无效正则视为不匹配」的兜底 ——
  连纯 ASCII 的 `"a_b"` 都被拒。现改用 `allSatisfy`，不再依赖正则。
- **`fdy_isValidUsername` 此前放行 emoji**：判据里的「首个标量 ≥ 0x4E00」把 `🎉` / `Привет` / `あ`
  一并放行（汉字本就 `isLetter == true`，该条件多余且有害）。已删除。
- **`fdy_toNSNumber()` 丢精度**：旧实现绕道 `Double`，`"1234567890123456789"` 读回
  `1.234567890123457e+18`。现改为整数走 `Int64`、其余走 `Decimal`。
- **`fdy_removeNewlines()` 漏 `\r`**：只删 `\n`，Windows 换行只删一半。现覆盖 `.newlines` 全集。
- **`fdy_removeSpaces()` 漏全角空格**：只删 ASCII 空格。现覆盖 `.whitespaces` 全集。
- **`fdy_hidingSensitiveContent(in:)` 的默认遮蔽串混进一个反引号**（U+0060），
  输出成了 `138` + 两个星号 + 反引号 + `5678`。现订正为两个星号。
- **`Character.fdy_isEmoji` 把 ASCII 数字与 `#` `*` 判成 emoji**：`properties.isEmoji` 对这几个字符
  返回 `true`（它们可以是 keycap emoji 的基字符），连带让 `String.fdy_containsEmoji` 系列失真。
  现排除 ASCII（码点 ≤ 0x7F）。
- **`fdy_isValidURL` 判定过宽**：`"hello world"` / `"not a url"` / `"://x"` 此前全为 `true`，
  现额外要求「有 scheme」。
- **`fdy_copyToPasteboard()` 的 macOS 分支是死代码**：缺 `import AppKit`，且写的是
  `NSPasteboard.general.setString(base, ...)` —— `base` 是 `FdyWrapper` 的属性名，抄串了。
  本包 `platforms` 只声明 iOS，该分支**从未被编译器看过**，故两道 iOS 关卡都抓不到它。
  （本批为此新增第 ⑥ 道验证关卡：macOS 分支 typecheck。）

### 新增

- `String.fdy_toDouble()` / `fdy_toFloat()` —— 此前只有 `fdy_toInt()`，缺浮点版
- `String.fdy_snakeCase` —— 与 `fdy_camelCase` 互为反向（连续大写缩写整体识别为一个词）
- `String.fdy_firstMatch(pattern:options:)` —— 补齐正则家族（此前只有 `isMatch` / `captures` / `matchRanges`）
- `UIView.fdy_right` / `fdy_bottom` —— frame 代数此前只有 `left` / `top` / `width` / `height`，缺这两个

### 验证

五道关卡 + **新增第 ⑥ 道（macOS 分支 typecheck）** 全部通过；
跨模块正向探针 7 → **8**（新增 `string_probe`）；
双运行时判定集 55 → **61 行** IDENTICAL（新增 `S44`–`S49`，27 个布尔在两运行时全为 `true`）。

### 新增 —— 交互与文本链式（链式补全第 4 批，9 个文件 / 49 个方法）

| 新文件 | 覆盖对象 | 链式方法数 |
|---|---|---|
| `Chain/UIKit/UIToolbar+Chain.swift` | 栏族最后一格（`UINavigationBar` / `UITabBar` 早已有） | 10 + 5 便利方法 |
| `Chain/UIKit/UIMenuElement+Chain.swift` | **基类** —— `UIAction` / `UIMenu` / `UIKeyCommand` 自动继承 | 3（含 2 项 iOS 27） |
| `Chain/UIKit/UIAction+Chain.swift` | `UIButton.menu` / `UIBarButtonItem.menu` 的构件 | 5 |
| `Chain/UIKit/UIKeyCommand+Chain.swift` | 键盘快捷键 | 8 |
| `Chain/UIKit/UIDragInteraction+Chain.swift` | 拖拽 | 4（含 2 项 iOS 27） |
| `Chain/UIKit/UISearchTextField+Chain.swift` | 搜索输入框（父类 `UITextField` 的方法自动继承） | 5 |
| `Chain/UIKit/UIToolbarAppearance+Chain.swift` | 工具栏外观自有属性 | 3（1 项 iOS 26、1 项已废弃） |
| `Chain/UIKit/UIBarButtonItemStateAppearance+Chain.swift` | 按钮项**单状态**外观 | 4 |
| `Chain/UIKit/UITabBarItemStateAppearance+Chain.swift` | 标签栏项**单状态**外观（含标题与角标两套文本属性） | 7 |

- `UIToolbarAppearance.doneButtonAppearance` 是 `iOS 26` 起被 `prominentButtonAppearance` 取代的旧入口，
  **仍保留**（`iOS 18`~`25` 上它是唯一入口），包装器同样标成废弃。
  实测：在**同等废弃**的声明内部使用废弃 API **不会**多出编译告警（① 仍是 3 条主 warning）。
- `UIMenuElement` 的共有属性写在**基类文件**里，三个子类自动继承（与第 3 批
  `UIBarAppearance+Chain.swift` 之于三个子类的做法一致）。
- **判掉 7 个类**（不建文件，附判据）：`UIContextMenuInteraction`（0 项可写）、
  `UIBarButtonItemAppearance` / `UITabBarItemAppearance`（0 项可写，且**不是** `UIBarAppearance` 子类）、
  `UIDropInteraction`（1 项）、`UISearchToken`（1 项）、`UIMenu` / `UIDropProposal`（2 项）。
- `UISearchTextField.searchSuggestions` 的**读回值被系统改写**：该属性默认值不是 `nil`，
  传 `nil` 清空后读回是**空数组**（CLI 取证实测，18.0 / 26.5 一致）—— 别拿它与 `nil` 比较。

### 修正 —— 第 3 批关于外观类继承关系的一处错记

第 3 批把 `UIBarButtonItemAppearance` / `UITabBarItemAppearance` / `UITabBarItemStateAppearance`
记成「父类方法已自动继承，自身属性留后续批次」。**本批实核推翻**：

`UIBarAppearance` 的子类**只有 3 个** —— `UIToolbarAppearance` / `UITabBarAppearance` /
`UINavigationBarAppearance`；上述三个类与 `UIBarButtonItemStateAppearance` **都直接继承 `NSObject`**，
故 `UIBarAppearance+Chain.swift` 的方法对它们**不适用**。三者的「不建文件」理由相应订正为
「本来就没有可写属性 / 只有只读状态访问器」，与「父类继承」无关。

### 验证（第 4 批）

① 0 error / 3 主 warning（274 文件）② 0/274 ③ 正向 **9** 探针 0 诊断（新增 `interaction_probe`）、
反证 2 条预期报错 + `batch4_negative` **5 条**可用性反证按预期报错 ④ 0 error ⑤ **68 行** IDENTICAL
（新增 `S50`–`S56`，7 条断言的全部布尔在两运行时逐条核过为 `true`）⑥ 0 诊断。

### 验证（第 12 批 —— String / UIView 扩展审计）

七道关卡全部通过；跨模块正向探针 7 → **8**（新增 `string_probe`）；
双运行时判定集 55 → **61 行** IDENTICAL（新增 `S44`–`S49`）。

### 破坏性变更 —— `fdy_findTopViewController(from:depth:)` 并入 `fdy_topViewController`

`UIWindow` 原先暴露**两个**入口：属性 `fdy_topViewController`，以及「带 `depth` 的公开递归方法」
`fdy_findTopViewController(from:depth:)`。现合并为**单个属性**，实现改为**无层级上限的迭代**。

- **删除** `UIWindow.fdy_findTopViewController(from:depth:)`（库内唯一调用点是属性自身，已随之改写；
  **宿主若直接引用过该方法需改成 `UIWindow.fdy_topViewController`**）
- `fdy_topViewController` 的**签名与语义不变**，既有调用点（如 `UIAlertController+Chain.swift`）无需改动

顺带修掉一处**静默错误**：原 `depth < 10` 保护在超深层级时不返回 `nil`，而是
**返回中途的某个控制器** —— 把结构异常伪装成一个看起来正常的结果。新实现不设上限：
这四条链（`visibleViewController` / `selectedViewController` / `split` / `presentedViewController`）
在 UIKit 中都是无环的有限链，层级不会深。

验证：`S57`–`S60` 覆盖四条分支（含深度 12 的 tab/nav 交替嵌套）；`S58` 附**反证** ——
同层级下旧实现复刻**取不到**最内层（`legacyReachesInner=false`），证明该断言确实能区分新旧。

### 验证（第 5 轮 —— `fdy_topViewController` 合并）

| 关卡 | 结果 |
|---|---|
| ① 整模块 `swiftc -typecheck`（274 文件） | **0 error / 3 主 warning**（与基线一致） |
| ② `swiftformat --lint Sources/` | **0/274** |
| ③ 跨模块 typecheck | 正向 **9 探针 0 诊断**；反证 3 组各 **1 / 1 / 5 条**预期错 |
| ④ `build.sh` 全量编译 | **0 error**（`build_dylib.log` 与 `build_probe.log` 独立核过，产物时间戳为当轮） |
| ⑤ 双运行时行为探针 iOS 18.0 / 26.5 | **72 行逐行一致**（68 → 72），`S57`–`S60` 逐条核真值全为期望值 |
| ⑥ macOS 分支 typecheck | **0 诊断** |

### 新增 —— 视图配置工厂（`Common/FdyViewFactory.swift`，6 个方法）

在既有三层之上补出**第二层「带默认值的配置工厂」**：

| 层 | 文件 | 职责 |
|---|---|---|
| 裸工厂 | `Common/FdyFactory.swift` | `UIView.view()` / `UILabel.label()` …… 只保证「造得出来」，零配置 |
| **配置工厂** | `Common/FdyViewFactory.swift` | `UIView.fdy_makeView(backgroundColor:cornerRadius:…)` …… **一次给全常用参数** |
| 声明式 | `Common/FdyViewBuilder.swift` | 声明式子视图，管「父子关系」 |

| 方法 | 参数 |
|---|---|
| `UIView.fdy_makeView` | `backgroundColor` / `cornerRadius` / `maskedCorners` / `cornerCurve` |
| `UILabel.fdy_makeLabel` | `text` / `textColor` / `font` / `textAlignment` / `numberOfLines` / `lineBreakMode` / `scalesWithContentSizeCategory` |
| `UIButton.fdy_makeButton` | `title` / `titleColor` / `font` / `image` / `imagePlacement` / `imagePadding` / `backgroundColor` / `cornerRadius` / `contentInsets` |
| `UIImageView.fdy_makeImageView` | `image` / `contentMode` / `tintColor` / `backgroundColor` / `cornerRadius` / `maskedCorners` |
| `UITextView.fdy_makeTextView` | `text` / `textColor` / `font` / `isEditable` / `isSelectable` / `backgroundColor` / `cornerRadius` / `maskedCorners` |
| `UITextField.fdy_makeTextField` | `placeholder` / `placeholderTextColor` / `text` / `textColor` / `font` / `backgroundColor` / `cornerRadius` / `maskedCorners` / `leftPadding` |

四条纪律：

1. **一律转发既有入口**（`UIView.view()` / `UIButton.plain()` / `UITextView.textView()` / `UILabel(fdy_text:)` ……），
   不裸调 `UIView()` —— 裸工厂里已经带了默认配置（如 `UITextView.textView()` 关掉了两条滚动指示器）。
2. **圆角三件套成组**：`cornerRadius` + `maskedCorners` + `masksToBounds(true)` 三者**互不联动**（实测），
   缺任一项圆角都画不出来。调用方只写 `cornerRadius:` 即可。
3. **默认值取系统语义量**（`.label` / `.systemBackground` / `.placeholderText` ……），**不内置任何产品色** ——
   否则深色模式失效。产品预设请在使用方再包一层。
4. **返回基类而非 `Self`**，理由同 `FdyFactory.swift` 文件头。

「传 `nil` / `0` 即不覆盖」的项（`imagePadding` / `contentInsets` / `tintColor` / `text` / `leftPadding`）
在工厂内做了**条件调用**：`leftPadding(0)` 会占掉 `leftView`、`tintColor(nil)` 会退回系统查找，
两者都与「保持继承」语义不同 —— 无条件照调会让「未指定」与「显式指定为默认」不可区分。

写这批链式工厂时避开的三个坑（均已实测）：

- **不擅自改 `UIButton.Configuration.cornerStyle`**：`.dynamic`（`plain()` 默认）**并非**「忽略 `backgroundCornerRadius`」——
  头注释原文是「cornerStyle controls how `background.cornerRadius` is **interpreted**」，
  实测（进真实层级并 layout 后读回）也确认显式半径未被系统改写。隐式改成 `.fixed` 会改掉调用方没要求的语义，
  故 `cornerRadius` 只设半径、`cornerStyle` 留给调用方。
- **背景色要断 `baseBackgroundColor`**：它是配置里的**模板值**；`background.backgroundColor` 在存储态里仍是 `.clear`，
  由系统在 `updateConfiguration` 时才派生 —— 断错字段得到的是假阴性。
- **不要用 `===` 判 `UIImageView.image`**：`UIImage()` 空图在 setter 里会被 UIKit 换成等价实例（`===` 为 `false`，而两边 `size` 相等）。

### 验证（视图配置工厂）

| 关卡 | 结果 |
|---|---|
| ① 整模块 `swiftc -typecheck`（**275 文件**） | **0 error / 3 主 warning**（与基线一致） |
| ② `swiftformat --lint Sources/` | **0/275** |
| ③ 跨模块 typecheck | 正向 **10 探针 0 诊断**（新增 `viewfactory_probe`）；反证 3 组各 **1 / 1 / 5 条**预期错 |
| ④ `build.sh` 全量编译 | **0 error**（两日志独立核过，产物时间戳为当轮） |
| ⑤ 双运行时行为探针 iOS 18.0 / 26.5 | **79 行逐行一致**（72 → 79），`S61`–`S67` 逐条核真值**全为 `true`** |
| ⑥ macOS 分支 typecheck | **0 诊断** |

`S61`–`S67` 逐项读回核对「参数确实写进了实例」（只断言「编得过」等于没验）；`S66` 另含**对照组** ——
「未指定」必须与裸 `UIButton(configuration: .plain())` 完全一致；`S67` 是**对照实验**，
推翻了初稿「必须成对设 `.fixed`」的假设，并据此改了实现。

### 新增 —— 杂项链式（链式补全第 5 批，12 个文件 / 71 个方法）

| 文件 | 项数 | 备注 |
|---|---|---|
| `UICalendarView+Chain.swift` | 9 | `availableDateRange` 在 Swift 侧是 `DateInterval`(非 `NSDateInterval`) |
| `UITab+Chain.swift` | 9 | iOS 18 起，与 `platforms` 齐平 → 按门槛不加可用性标注 |
| `UIAccessibilityElement+Chain.swift` | 7 | `accessibilityContainer` 是 `AnyObject?`(weak id)，不是 `Any?` |
| `NSCollectionLayoutSection+Chain.swift` | 6 | 组合布局分组 |
| `UICollectionViewLayoutAttributes+Chain.swift` | 6 | 与 `where Base: UIView` 的 frame/center/size/alpha 同名，`Base` 不同不冲突 |
| `UITabGroup+Chain.swift` | 6 | 继承 `UITab` → 基类 9 项自动适用 |
| `NSLayoutManager+Chain.swift` | 5 | |
| `UICommand+Chain.swift` | 5 | 与 `UIAction` 同名的 5 项，`Base` 不同不冲突 |
| `UISearchController+Chain.swift` | 4 | |
| `UICollectionViewListCell+Chain.swift` | 4 | |
| `UIColorWell+Chain.swift` | 3 | |
| `UIListSeparatorConfiguration+Chain.swift` | 7 | **struct** → 补登记 `FdyExtension` conformance |

**本批首次以「编译器裁决」定候选范围**（`_ = X.self` 判可否解析、`_ = X.self as AnyObject.Type` 判 class/struct），
把前几批靠人工读头文件的两类风险一次性钉死。完整口径与踩坑清单见内部治理方案 §8.14。

### 新增 —— 已有类属性缺口（链式补全第 6 批，34 个已有文件 / 209 个方法）

前五批是「给没有 Chain 文件的类**建**文件」，本批是「给**已有** Chain 文件的类**补属性缺口**」，
因此先把「缺口」这件事本身算对：修掉旧对账口径的**跨类误报 / 漏算父类自动适用 / 行尾宏污染**三处缺陷，
并新增**继承链合并**、**条件编译感知**、**平台专属排除**。
**可用性 ≤iOS 18（A 档）的方法本批一次性清零**；余 30 项 B 档（>iOS 18）须 `@available` + 反证，另立批次。

| 分组 | 文件（新增项数） |
|---|---|
| 导航 | `UINavigationBar`(10)、`UIBarButtonItem`(9)、`UINavigationItem`(22)、`UINavigationController`(4) |
| 容器 | `UITabBarController`(6)、`UITabBar`(6)、`UITabBarItem`(3)、`UITabGroup`(2) |
| 列表与滚动 | `UICollectionView`(13)、`UITableView`(11)、`UICollectionViewLayoutAttributes`(2)、`UIScrollView`(9) |
| 文本 | `UITextView`(7)、`UILabel`(2)、`NSMutableParagraphStyle`(8)、`NSLayoutManager`(3)、`NSLayoutConstraint`(1) |
| 搜索与呈现 | `UISearchBar`(7)、`UISearchController`(4)、`UIViewController`(8)、`UISheetPresentationController`(2)、`UIAlertController`(2) |
| QuartzCore / MapKit / WebKit | `CALayer`(26)、`CATextLayer`(1)、`MKMapView`(20)、`WKWebView`(8) |
| 其他 | `UIImageView`(2)、`UISwitch`(4)、`UIPageControl`(1)、`UIProgressView`(1)、`UIRefreshControl`(1)、`UISegmentedControl`(1)、`UIAccessibilityElement`(1)、`NSCollectionLayoutSection`(2) |

**运行时实测反推的三条系统事实**（已写成断言或文档注释）：

- `UICollectionViewLayoutAttributes.bounds(_:)` —— `origin` **必须是 `.zero`**，否则 UIKit 断言直接抛
  `NSInternalInconsistencyException`（库内已补 `- Warning:`）。
- `UINavigationBar.preferredBehavioralStyle` —— **不回卷**：写 `.pad` 后读回恒为 `.automatic`，
  具体生效值落在**只读**的 `behavioralStyle`。
- `UISearchBar.isLookToDictateEnabled` —— iOS 上是 **silent no-op**（首发平台 visionOS，写 `true` 读回恒 `false`）。

> ⚠️ **`UISwitch.title` 是待决项**：头文件标 `API_AVAILABLE(ios(14.0))`，但文档注释写明「仅 Catalyst Mac idiom 支持」，
  iOS 上调用 `setTitle:` 会抛 `_UICatalystUnsupportedMacIdiomBehavior`。**当前保留在库内且未加保护**，是否删除待拍板。

### 验证（第 6 批）

七道关卡全部通过；文件数 287 → **288**；跨模块正向探针 11 → **12**（新增 `batch6_probe`，覆盖 34 类 / 208 次调用）；
双运行时判定集 91 → **117 行** IDENTICAL（新增 `S80`–`S95`，26 行 / **193 个布尔**，逐条核真值全 `true`）。

**收尾巡检中另揪出的既有文档漂移（非本批引入，一并订正）**：

- **`FdyExtension` conformance 总量 32 → 33**：第 5 批已新增 `UIListSeparatorConfiguration`（Swift 原生 struct，
  必须显式登记），而 `README.md`（4 处）与内部项目约定、脚手架指引
  仍写 32。**本批未新增任何登记**（34 个类型全是 class，靠 `NSObject` 继承），此处只订正计数。
  第 33 条的可达性判据在 `batch5_probe.swift`，`conformance_probe.swift` 仍覆盖 32 条。
- **验证脚手架 3 处陈旧**：`App.swift` 行数（误为 700 / 1500 → 实为 **2264**）、S 段范围（`S1–S79` → **`S1–S95`**，
  两处）、文件树缺 `batch6_probe.swift`；并**补了 S44–S95 的区间索引表** —— 原先断言明细只到 S43，
  正文却称「照 S1–S95 清单」，重建时无从下手。

### 文档 —— 全库注释重写（链式补全第 7 批，180 个文件 / 净删 2068 行）

把 Chain 与 Extensions 里零信息量的模板注释清掉，让注释只留「签名 / 命名自明不了」的信息。
**不改任何行为、不动任何 API 签名。**

| 处理 | 对象 |
|---|---|
| 删 | `- Returns: Self` 及同义变体（`当前实例(支持链式调用)` 等）**1018 条** |
| 删 | 复述型 `- Parameter`（描述 = 参数名中译）**1029 条**；随之空掉的 `- Parameters:` 块头 **70 个** |
| 改 | 摘要去掉「设置 / 指定」这类空动词 **1053 条**（`设置文字内容` → `文字内容`，**行数不变**） |
| **一字未动** | `- Warning` / `- Note` / `- Important` / `- Example` 等 **402 + 316** 块，及所有**有信息量**的参数 / 返回值描述 |

`///` 注释行 **11445 → 9311**。`Combine`(13 文件) / `Logger`(3) / `Chain/UIGeometry`(1) 本就零噪声，未动。
方案与完整判据见内部治理方案 §8.16。

**三条实测结论**：

- ⛔ **「只删不增」也会误删** —— 实测三类形态：① 描述含**行为约束**词
  （`- then: 任务完成后在**主线程**执行的可选回调`，线程约束差点丢）；② 描述含**句读**的补充说明
  （`扩张距离,负值向内`、`Z 轴位置,越大越靠前`，正负分界有反转风险）；③ **裸标题 + 缩进续行**
  （`- Parameter tensionValues:` 换行后 `- 正值 → 曲线更"紧"`，续行随首行整段删，共 **9 处**，全在 QuartzCore）。
  判据必须按「描述**可能承载什么约束**」，而非「像不像复述」——**宁可漏删，绝不可误删**。
- **`- Parameter x:` 在库内有两种写法**：单行 `- Parameter x: 描述`，与**裸标题 + 缩进续行**
  （仅 QuartzCore 有）。后者的续行才是真信息，只看首行会连信息一起删。
- **链式方法的 `- Returns: Self` 属零信息量**：签名已给出 `-> Self`，「支持链式调用」纯复述。

### 验证（第 7 批）

七关全绿：① **0 error / 3 主 warning**（288 文件，基线未变）· ② `swiftformat --lint` **0/288**
· ③ 跨模块 **12 正向探针全 0 诊断** · ③' 2 反证各报**预期的那一条** · ④ `build.sh` **0 error**
· ⑤ 双运行时 **117 行 IDENTICAL**（末行 `DONE`；注释不动行为，判定集与第 6 批一致）· ⑥ macOS 分支 **0 诊断**。

另加三项**保真核对**（注释类改动不看七关，要看「有没有丢信息」）：

- 改前 / 改后的 `- Warning` / `- Note` / `- Important` / `- Example` 行集合 `diff` —— **完全一致**；
- 结构完整性（孤儿参数子项检查）改前 / 改后均 **0**；
- `comment_rewrite.py` 连跑两次 `--apply` 均 **0 命中**（幂等验收）。

工具：`.build/structprobe/comment_scan.py`（只读形态统计）、`comment_rewrite.py`（改写，自带 `--audit` 逐条人审）、
`check_structure.py`（孤儿子项检查）。

### 修复 —— 消除全库唯一的真强制解包（链式补全第 8 批）

`DateFormatter.init(fdy_format:locale:timeZone:)` 的默认时区原为 `TimeZone(secondsFromGMT: 0)!`。
该值域对 0 偏移**恒非 nil**（GMT 一定存在），属「实测安全但可消除」，现改为 `.gmt`
—— 已实测在库最低支持的 **iOS 18** 上可用（探针 0 诊断）。**全库真强制解包数：1 → 0。**

### 验证（第 8 批 —— 全库实现审查）

覆盖 **288 文件 / 35665 行**（计划表原记「审查全库 68 个 Chain 文件」，实核翻两番）。
只读脚手架 `.build/structprobe/impl_audit.py`（16 类判据，**先剥注释与字符串**再匹配，无 `--apply`）。

**硬危险操作近乎零命中**：`as!` = 0 · `try!` = 0 · 隐式解包 `Type!` = 0 ·
`unsafeBitCast`/`Unmanaged` = 0 · 真强制解包 = 0（已修）· `DispatchQueue.main.sync` = 0。
仅存的 2 条后缀 `!` 命中是 `responds(to aSelector: Selector!)` 这类 **ObjC 系统签名**，override 必须照抄。

**判为非缺陷 10 类**（逐类给判据）：45 处索引/边界风险**全部已有 guard** · 57 处 `static var`
多为只读计算属性 · `FdyQueue: @unchecked Sendable` 由 `NSLock` 正确保护 · 28 处 `DispatchQueue.main`
回调切主线程 · 2 处通知 token 配对完整（`stop()` + `deinit` 双兜底）· 26 处 `try?` 是库的既定契约 …

**反证证伪了一个假设**：3 处 `assert(Thread.isMainThread)` **并非**冗余 —— 反证探针实测，
`@MainActor` 隔离确实存在（3 条 `call to main actor-isolated …` 逐一对应方法名），
但 `swiftLanguageMode(.v5)` 下它是 **warning** 而非 error，且 Release 下 `assert` 不执行
→ 保留（Debug 期对绕过类型系统的调用路径仍有诊断价值）。

**抓到 3 个真缺陷（待拍板修复，本批只出结论）**：

1. `CLGeocoder.fdy_activeGeocoders` —— 多余的全局 `Set`：保活（闭包已强捕获实例）与防复用
   （每次新建实例）两条理由均不成立，反而引入**无锁数据竞争**与**回调不触发时的永久残留**
2. `CAGradientLayer.init(fdy_frame:colors:...)` —— 空色数组时 `assertionFailure` + `return`，
   Release 下返回一个 `frame == .zero`、**无颜色无配置**的图层，**静默失效**
3. `FdyFileDestination.rotateLogFile` —— 轮转后 `FileHandle(forWritingAtPath:)` 失败时无 `else`
   分支，保留**已关闭的** handle → 下次写入抛 `NSFileHandleOperationException` **崩进程**

> **订正（2026-09-20，第十八轮）**：以上 3 处**已全部修复**，明细见下节「修复 —— 第 8 批 3 个真缺陷
> 落地」；标题里的「本批只出结论」已不成立。另两处与初判不同：第 3 条的「补 `else` 分支」修法后来
> 替换为**调整 `closeFile()` 时机**，且实测显示影响面比这里写的更大（`flush()` / `teardown()`
> 两条公开 API 同样会崩）；第 2 条的断言由 `assertionFailure` 改为 **`precondition`**。

关卡：① **0 error / 3 主 warning**（288 文件，基线未变）· ② `swiftformat --lint` **0/288**。
（本批仅改 1 行默认参数值且行为等价，③④⑤⑥ 不受影响。）

工具：`.build/structprobe/impl_audit.py`（16 类只读扫描）、`thread_negative.swift`（并发隔离反证）、
`tz_check.swift`（`TimeZone.gmt` 可用性验证）。

### 修复 —— 第 8 批 3 个真缺陷落地（第十八轮）

三处**签名不变、正常路径行为逐字节一致**（端到端实测）。

1. **`CAGradientLayer.init(fdy_frame:colors:...)` 空色数组** —— `assertionFailure` → `precondition`。
   实测（`-O`，即 Xcode Release 默认）改前**静默**返回 `frame == .zero` / `colors == nil` 的图层，
   调用方无从察觉；改后 `-Onone` 与 `-O` **两档都 trap**。
2. **`CLGeocoder` 的 `private static var fdy_activeGeocoders`** —— 删除。实测「闭包体引用即强捕获」
   成立，该 `Set` 不参与保活；而它引入无锁跨线程读写（`insert` 在调用线程 / `remove` 在系统
   回调线程）与回调不触发时的无限增长。`private` 属性，删除不动 API。
3. **`FdyFileDestination.rotateLogFile`** —— 把 `closeFile()` 从轮转开头移到「成功换上新句柄」之后。
   实测已关闭的 `FileHandle` **写入与 `synchronizeFile()` 均抛 `NSFileHandleOperationException`
   终止进程**（故 `log()` / `flush()` / `teardown()` 三条公开路径都会崩）。端到端对照（旧实现取
   `git HEAD`）：改前「重开失败后继续写日志」**崩**（栈顶正是 `FdyFileDestination.log(context:)`），
   改后全程安全；正常轮转输出**逐字节相同**（`test.1.log size=1070` / `test.log size=0`）。

**新发现（未改，已列待办）**：`assertionFailure` 全库 **17 处**同型模式，按「降级是否可用」
分为 A 坏降级（6，建议改 `precondition`）/ B 好降级（7，保留）/ C 内部不变量（4，保留）。
判据见方案 §8.18 ⑤。

### 验证（第十八轮 —— 缺陷修复）

七关全绿：① **0 error / 3 主 warning**（288 文件）· ② **0/288** · ③ 正向 **×12 全 0 诊断** ·
③' 反证 ×2 各报**预期那条** · ④ `build.sh` **0 error**（dylib 已重编）· ⑤ 双运行时 **117 行
IDENTICAL**（末行 `DONE`）· ⑥ macOS 分支 **0 诊断**。

> **方法论教训（本轮最值钱）**：第一次跑「优化档矩阵」时把库编成 `libFdy.dylib` 再让探针链接，
> 四档结果**完全相同** —— 因为被考察的代码在 dylib 里，优化档由 dylib 决定，探针的 `-O` 根本没
> 作用到它。修正为「探针与 `Sources/Fdy/**` 一起编译」后矩阵才分出层次。
> **凡「行为随构建配置变化」的实验，必须确认优化档作用在了被考察的那段代码上。**

工具：`.build/structprobe/run_fix8.sh`（断言矩阵 / 空色数组 / 已关闭 handle）、
`assert_only.swift`（单文件断言语义对照）、`fix8_flags.swift`（handle 分步 + 闭包保活）、
`run_logger_rotate.sh` + `logger_rotate_probe.swift`（Logger 轮转的端到端前后对照）、
`run_fix8_verify.sh`（修复后七关）。

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
- 验证脚手架（`.build/structprobe/`：8 个跨模块探针 + 1 个行为探针 app）为**本机路径，不入库**

[0.1.0]: https://github.com/xxwang/fdy-swift/releases/tag/0.1.0
