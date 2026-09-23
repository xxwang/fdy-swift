# fdy-swift · 工程规范（AI 开工必读）

> **本文件只放 fdy-swift 专属判据**。跨项目通用规范（完成判据 / 工具陷阱红线 / 注释·命名通则 / 文档分层）
> 在**本机用户级规则目录**（会话自动加载）与**本仓库 `CONVENTIONS.md`**（同源副本）里，此处**不重复**。
> 体例是**判据清单**，不是教程：只写「做什么 / 怎么验 / 什么算错」，不写推导过程。
> 详细推导、逐轮判据来源、历史批次记录属内部治理材料，**不进版本控制**。
>
> ⚠️ **开工前请完整读一遍本文件 + 通用规范**。会话首轮只注入本文件的前 8000 字符，
> **不要只在首轮看到的部分上动工**。

## 0 · 项目与环境事实

- **包**：SwiftPM，`tools 6.0` · `platforms: [.iOS(.v18)]` · `swiftLanguageMode(.v5)` · 单 target `Fdy`。
- **本机工具链**：Xcode 27.0 / SDK 27.0 / Swift 6.4 / swiftformat 0.63.0。
- **无 `Tests/` target** ⇒ `swift test` 不可用；验证全部靠下面的编译关卡与行为探针。
- **`xcodebuild` 在本机沙箱内不可用**（报依赖解析失败，非代码问题）；CI 上可用。
- 文件数 / 断言数是**时点值**（2026-09-21 基线：**289 文件 / 118 行断言**），随批次增长。
- ⚠️ **换 Xcode / SDK 后，先重跑 ① 关取新基线，再动代码**；基线变了不等于行为变了。

## 1 · 改完必须过七关

判据是**期望值**，不是「看着没问题」。任一项不达标 = 未完成。

| # | 关卡 | 期望 |
|---|---|---|
| ① | 整模块 typecheck | **0 error / 3 warning**（环境级 `_SwiftifyImport` 噪音不计入） |
| ② | `swiftformat --lint --no-cache Sources/` | **0/289** |
| ③ | 跨模块 typecheck **×13 正向** | **0 诊断** |
| ③' | 同上 **×2 反证** | **必须报出预期的那一条**（判据是身份，不是条数） |
| ④ | `zsh .build/structprobe/build.sh` | 0 error（**必须看 `check_errors` 输出**，别只看末尾「构建完成」） |
| ⑤ | 双运行时 iOS 18.0 / 26.5 `diff` | **118 行 IDENTICAL**（末行含 `DONE`） |
| ⑥ | macOS 分支单编 | **0 目标文件**（全库已无 `os(macOS)`；此关是哨兵，命中即说明分支被重新引入） |

⛔ **① / ③ 的命令不能省 `-target` + `-sdk`**。简写 `swiftc -typecheck @files.txt` 会报
`no such module 'UIKit'`：

```bash
SDK=$(xcrun --sdk iphonesimulator --show-sdk-path)
# ① 整模块
xcrun swiftc -typecheck -target arm64-apple-ios18.0-simulator -sdk "$SDK" -swift-version 5 @.build/structprobe/files.txt
# ③ 跨模块（逐个探针；③' 反证同口径，差异只在「期望报错」）
xcrun swiftc -typecheck -target arm64-apple-ios18.0-simulator -sdk "$SDK" -swift-version 5 \
  -I .build/structprobe/lib .build/structprobe/<probe>.swift
```

**③ 的 13 个正向探针**（缺一不可）：
`readme_probe` · `conformance_probe` · `subscript_probe` · `bind_probe` · `color_probe` ·
`cell_probe` · `appearance_probe` · `string_probe` · `interaction_probe` · `viewfactory_probe` ·
`batch5_probe` · `batch6_probe` · `b34_tint_probe`

**③' 的 2 个反证**：`subscript_negative` · `bind_negative`（每轮必跑）。
另有 `batch3_negative` / `batch4_negative` 是**一次性可用性反证**，只在新增或调整 `@available` 时跑。

- **③ 是唯一能抓「漏登记 conformance」与「改名后外界写不出来」的关卡**。探针开头必须 `import Fdy`，
  否则满屏 `cannot find type` 属假阴性。
- 探针脚手架在 `.build/structprobe/`（**不入版本控制**，需按内部规格重建）；
  探针与临时输出一律放这里，**别放 `/tmp`**（会被清空）。
- ⛔ **数诊断别用 `grep -c 'error:'`**（通用红线见规范）。本项目用这条正则：
  ```bash
  grep -cE '^[^ |]+\.swift:[0-9]+:[0-9]+: error:'
  ```
- ⛔ **可用性标注必须做反证才算测过**：「加了 `@available` 编得过」证明不了必要性 →
  再补「去掉标注」版，**期望报 `only available in iOS N or newer`**。已钉：
  `UIBarAppearance.overrideUserInterfaceStyle` = **27**；`UINavigationBarAppearance.subtitleTextAttributes` /
  `largeSubtitleTextAttributes`、`UIToolbarAppearance.prominentButtonAppearance` = **26**。
- **⑤ 的判定集只取 `^S` 前缀行 + `DONE`，且必须含 `DONE`**：探针中途抛 `NSException` 会终止进程，
  两份输出只是「一致地没跑完」，`diff` 照样报一致。判定前**校验行数非零**。
  - `DIAG*` 前缀一律排除（私有 selector 清单 18.0 = 139 / 26.5 = 159，混进去假报差异）；
    **凡「被系统改写的量」都不进判定集**（如 `separatorInset` 读回值）。
  - ⛔ **`IDENTICAL` 只证两端一致、不证断言为真**（全 `false` 也 IDENTICAL）⇒ 新断言**必须逐条核布尔真值**；
    且只打印布尔关系，**不打印系统读回的原值**。
- **④ 行为改动必须探针实测**，不接受纸面推导。
- ⛔ **跑 ⑤ 前必须 `rm -f v_18.txt v_265.txt`**（本项目就这两个输出文件）。
- ⛔ **④⑤ 类脚本不加 `set -e`**：`simctl boot` 对已 Booted 设备返回非 0 ⇒ 2 秒静默退出，像跑完了。
- ⛔ **探针操作 window 必须认 `UIWindow.fdy_keyWindow`**：`UIWindow(frame:)` 建的窗口在 scene 架构下
  **不进 `scene.windows`** ⇒ 对 `self.window` 的赋值全部落空（而 `fdy_keyWindow != nil` 仍为 true，很隐蔽）。
  **nav 里不可放 nav**（`Pushing a navigation controller is not supported` 直接终止进程）⇒ 造深层级用 nav / tab 交替。

## 2 · 不可回退契约

改动前先确认没破这几条；它们是**有意为之的设计**，不是待优化项。

### 2.1 零全局符号

- **无运算符重载、无 `precedencegroup`、无顶层自由函数**。唯一保留运算符 `FdyLogLevel.<`。
- 系统类型 `init` 把 `fdy_` 写在**首个参数标签**（`UIColor(fdy_hex:)`）；
  `subscript` 前缀**必须双词**（单名 subscript 无外部标签，`arr[fdy_x: 0]` 报 `extraneous argument label`）。
- **理由**：碰撞有两种 —— 两模块都声明 → `ambiguous use`；**宿主自己声明 → 不报错、无警告，
  宿主实现静默胜出、库的版本被无声取代**。后者才是要害。
- **有意损失**（别去「修」）：`2 * point` 翻转方向消失；`switch` 里正则字符串**静默降级为字面量比较**。

### 2.2 `FdyWrapper` 两类语义

- **不可变值类型**（`UIImage` / `UIColor` / `UIFont` / `Date`）用 `where Base == X` + `base = 新实例`
  ⇒ 调用方原对象不受影响。
- **可变引用类型**（`UIView` / `UIBezierPath` / `NSLayoutConstraint` / `UIStepper`）用 `where Base: X` **就地改**。
- `init` 是 internal ⇒ **链式只写库内**，宿主不能自己拼。

### 2.3 `FdyExtension` conformance 共 **32 条**

- 清点必须**行首锚定 + 去重**：
  ```bash
  grep -rhE '^extension [A-Za-z0-9_.]+: FdyExtension' Sources/ | sort -u | wc -l   # → 32
  ```
  宽松写法会把注释里的引用也数进去 → 假报 60。
- **判据是「有没有 `.fdy` 链式面」，不是「有没有 `fdy_` 成员」**。`UUID` 有 `fdy_` 方法但**不登记**
  （无链式面，登记出来是个空壳）。
- 登记位置：**有 Chain 文件的登记在 `X+Chain.swift`，无 Chain 文件的登记在 `X++.swift`**。
- ⚠️ **struct / enum 不继承 `NSObject`，漏登记即 `.fdy` 静默不可达**。`String` 更险：漏登记**不报错**，
  静默桥接成 `FdyWrapper<NSString>`。**CF 类型有 Swift 侧继承关系**：给 `CGPath` 登记后
  `CGMutablePath` 自动继承，重复声明只报 **warning**。
- **泛型类型**（`Range` / `Measurement`）conformance 不能写 `where`，登记在无约束类型上
  ⇒ **所有泛型实参同时获得**。

### 2.4 其余硬契约

- **`FdyButton` 是点击热区 / 防重复点击的唯一入口**（旧名 `FdyHitAreaButton`，已更名）
  ⇒ 别再给 `UIButton` 注入全局 `point(inside:with:)` 或覆盖 `sendAction`。
- **有状态管理器一律走全局入口 `fdyG`**，不写 `Xxx.shared`。
- **`FdyFunc*`（有返回值）与 `FdyAction*`（无返回值）语义不同，必须并存 —— 别再提合并。**
- **`FdyScreen` 15 个实例成员、`FdySymbol` 4 个不可删**（Swift 不允许经实例访问静态成员）。
- **`extension UIView` / `UIScrollView` 成员自动继承类级隔离，别显式标 `@MainActor`**；
  `FdyWrapper<Base>` 因泛型拿不到 ⇒ 链式文件里访问 `FdyScreen.*` 必须标。
- **`FdyControlProperty.bind(from:)` 是泛型**（`<P: Publisher> where P.Output == Value, P.Failure == Never`）
  ⇒ `Subject` / `@Published` / `FdyControlEvent` / `map·filter` 可**直传**，不需要 `.eraseToAnyPublisher()`。
  **别再收窄回 `AnyPublisher`**（收窄后库自己的事件流都传不进去）。`Failure` 刻意不放宽。
- **滚动语义**：`contentOffset(_:animated:)` 直传不裁剪，裁剪用 `contentOffsetClamped(_:animated:)`；
  `scrollTo{Top,Bottom,Left,Right}` 统一在 `UIScrollView`、含 `contentInset`、默认 `true`。
- **`assert(Thread.isMainThread)` 不能删**：`@MainActor` 隔离在 `swiftLanguageMode(.v5)` 下**只报 warning**，
  且 Release 下 `assert` 不执行 ⇒ 对**绕过类型系统的调用路径**在 Debug 期仍有诊断价值。
  **升 Swift 6 语言模式时必须重跑反证。**

### 2.5 实现卫生「五零」基线

`as!` / `try!` / 隐式解包 `Type!` / `unsafeBitCast`·`Unmanaged` / `DispatchQueue.main.sync` **各 0**。
（扫描器会先剥注释与字符串再统计。）**新增 API 时守住这五条零。**

## 3 · 新增 API 的落位与命名

- **文件后缀看有无链式面**：有 Chain 写 `X+Chain.swift`，无写 `X++.swift`。
- **建 Chain 文件的判据**：**≥3 项可链式属性 → 建；≤2 项 → 不建**。
  **判掉 ≠ 不可达**（`NSObject` 子类靠继承拿 `.fdy`）；「父类已继承」**必须先实核继承链**。
  没先例的形态（如 `Base == X.Type` 静态工厂）**别发明**。
- ⛔ **「某类的可链式面」= 自身属性 ∪ 父类 Chain 文件里 `where Base: 父类` 的方法**（`Base: UITab` 的 9 项
  对 `UITabGroup` 自动适用）⇒ 只看本类文件**既多报又漏报**；还要**条件编译感知** +
  **平台专属排除**（只声明 `macos(...)` / `visionos(...)` 的）。
- **命名规范**：**新名 = `fdy_to` + 返回类型原名**，**类型前缀一律保留**
  （`fdy_toUIImage()` / `fdy_toCGPoint()` / `fdy_toNSRange()`）。全库不再出现 `as`
  （`NSRange.fdy_toRange(in:)` ↔ `Range.fdy_toNSRange(in:)` 构成对称双向转换）。
  - **不适用**（保持原样）：`static` 工厂 / `static` 取值（`Date.fdy_date(from:)` 是**解析**，改成 `toDate` 自相矛盾）、
    区间构造（`BinaryInteger.fdy_range(from:)`）、语义化名（`fdy_toRomanNumeral()`）、
    **格式化 / 编码 / 截取 / 派生**（`fdy_hexString` / `fdy_jpegBase64String` / `fdy_subData` …）——
    限定词才是信息量所在，加 `to` 反而失真。
  - ⛔ **禁止全库替换**：有同名符号只有**部分定义**要改（`fdy_string` / `fdy_date` / `fdy_range`）
    ⇒ `sed -i 's/fdy_x/fdy_y/g'` 必然误伤。**必须逐条对照映射表**。
- **组件约定**：`init(frame:)` public、`init?(coder:)` 可用、接 `FdySetupable` 并显式实现
  `setupUI()` / `bindEvents()`、类工厂返回 `-> Self`。

## 4 · 注释规范（项目部分）

通用体例见规范；以下是本项目专属判据。

- **分区标记必须写 `// MARK:`**（`//` 后有空格）：`//MARK:` Xcode 跳转栏不认，且触发 `spaceInsideComments`。
- **分区 MARK 判据**：`// MARK: - iOS 26.x 新增属性` 这类**分区线**若段内成员**已各自带 `@available`**，
  等于把同一信息再抄一遍 ⇒ **删**。但 `// MARK: - <一句话类型说明>`（由类型文档压来）**承载信息、留**。
- **`// MARK:` 块内散文按空 `//` 分段整段处置**：段内命中保留标记 → 整段留，否则整段删
  （逐行判会劈开段落、留半句话）。
- **注释改动的不变量（每次必核）**：**文件清单不变 · 代码 token 逐行相同 · ② 0/289 · ① 0 error / 3 warning**。
  - ⛔ **② 复跑一律加 `--no-cache`，且必须在改动落盘之后跑**（曾沿用改动前记录报 0/288，实际 3/289）。
  - ⛔ **`.swiftformat` 会跳过隐藏目录** ⇒ 拿 `.build/` 下的快照直接 lint 会报 `1 file skipped`；
    比对必须把两侧复制到**非隐藏目录**再跑。
- **master 已明确不处理（别再提案）**：① `UIStepper` / `UISegmentedControl` 的「真实点击」（需 XCUITest）；
  ② 注释语义准确性核对；③ 库里残留的 1199 个散文块。

## 5 · UIButton.Configuration 硬约束

- 状态分支只能从**外部只读模板**出发；handler 内读回 `button.configuration` 会污染。
- UIKit 只对颜色派生状态，**图片完全不派生** ⇒ 各状态换图自己写 handler。
- **已设 handler 后置 `nil` 会崩** ⇒ `configuration(_:)` 传非可选。改模板须 `setNeedsUpdateConfiguration()`。
  **按钮不在视图层级时 handler 一次都不跑。**
- 传统 setter 在配置化按钮上：`title` / `titleColor` / `image` / insets **不生效**；**`font` 生效**。
  拍板：其余不补齐。
- **`backgroundView` 与 `backgroundConfiguration` 双向互斥、后设者赢**；想稳定生效只能二选一。
  `UIBackgroundConfiguration.listPlainCell()` 在 iOS 18 已弃用 ⇒ 用 `.listCell()`。
- **链式顺序敏感**：经「读 appearance → 改 → 写回」实现的成员（如
  `UINavigationBar.largeTitleTextAttributes`）**必须排在 `.standardAppearance(_:)` 之后**；
  同链先后设的两个相关属性可能**互相接管**（`modalTransitionStyle` 被 `preferredTransition` 同步改写）
  ⇒ 断言拆实例。
- ⛔ **头文件与 Swift 接口矛盾时一律以编译器为准**：查 Swift 侧形态优先用
  `$SDK/.../UIKit.swiftmodule/arm64-apple-ios-simulator.swiftinterface`。

## 6 · 提交 / CI / 版本

- **提交与推送由维护者执行**；助手只改文件 + 跑验证 + 给出可直接执行的提交指令。写「已落地」前必须
  `git status` 逐项实核。
- **不加 tag 的改动**：CI / 文档 / 注释类基建改动不属于版本内容。
- **版本**：tag 形如 `*.*.*`，annotated tag 有两层 hash（`%(objectname)` = tag 对象、
  `%(*objectname)` = 指向的提交）—— 表述时写明是哪一层。
- **CI**（`.github/workflows/ci.yml`）**只有两步**：**② 格式化检查** + **编译通过**
  （`xcodebuild -scheme Fdy -destination 'generic/platform=iOS Simulator' build`，判据 = 退出码 0
  且出现 `** BUILD SUCCEEDED **`）。
  - `runs-on: xcode-27` 是**硬要求**（库内 9 处 `@available(iOS 27.0, *)`），不能降。
  - `release.yml`：tag `*.*.*` → 建 Release，经 `workflow_call` 复用 `ci.yml`。
  - ⛔ **CI 不覆盖 ① / ③③' / ④ / ⑤ / ⑥**（探针不入库）⇒ 这些**一律本机跑**，且**不假装 CI 覆盖了**。
- **查 CI 状态**：本机无 `gh` ⇒ `curl -s api.github.com/repos/xxwang/fdy-swift/actions/runs`，看 `conclusion`。

## 7 · 文档落位

- **通用规范**（跨项目判据）→ 本机**用户级规则目录**（自动加载）+ 本仓库 **`CONVENTIONS.md`**（同源副本）。
- **项目规范**（本文件）→ 只放 fdy-swift 专属判据；通用内容**不在此重复**。
- **明细** → 内部治理档（不入库）：推导、历史批次、实测数据。
- ⛔ **同一份判据不许两处并存**（必然漂移）。
- **一次性方案 / 审计记录用完即弃**：结论并入规范后原档即可移除。
- `README.md` / `CHANGELOG.md` **不得出现内部治理档路径** —— 用「内部治理材料」这类无路径表述。
