# UIButton 链式方法优化方案

> ⚠️ **路径订正（2026-09-18）**：本文写作时目录为 `Sources/Fdy/Core/{Chain,Extensions,Protocols}`。
> 该中间层已在提交 `7e8b14d`（「平铺 Core 中间层」）改为 `Sources/Fdy/{Chain,Extensions,Common,Components,Logger,Protocols}`。
> 文内所有 `Core/…` 路径与 `文件:行号` 请按**当时**的树读，行号现已偏移。
> 另：本文所议的「Chain 侧 32 处配置模板重复」已按方案 A（抽 helper）落地。

## 涉及的代码文件

| 文件 | 定位 |
| --- | --- |
| `Sources/Fdy/Core/Chain/UIKit/UIButton+Chain.swift` | UIButton 的链式扩展(含传统 API 与 Configuration 新 API) |
| `Sources/Fdy/Core/Chain/UIKit/UIButton.Configuration+Chain.swift` | `UIButton.Configuration` 的链式扩展 |
| `Sources/Fdy/Core/Protocols/FdyExtension.swift` | `FdyWrapper<Base>` 命名空间与基础链式方法(只读参考,不改) |

---

## 一、问题诊断

### 问题 1:配置读写模板代码大量重复(主问题)

`UIButton+Chain.swift` 中 16 个配置类方法(`titleC` / `imageC` / `subtitle` / `cornerStyle` / `backgroundStrokeColor` 等)全部是同一个四行模板:

```swift
var configuration = base.configuration ?? UIButton.Configuration.plain()
configuration.xxx = value
base.configuration = configuration
return self
```

`UIButton.Configuration+Chain.swift` 中另外 16 个方法同样是这个模板(仅操作对象从 `base.configuration` 换成 `base`)。

- 两处合计 **32 份重复代码**,结构与意图完全一致,仅取值来源不同。
- 后续每新增一个配置项,都要复制粘贴两份,极易手抖出错、遗漏一致更新。

### 问题 2:两套 API 命名不一致(可读性)

同一属性在 UIButton 上是 `titleC` / `imageC`,在 Configuration 上是 `title` / `image`。

- `C` 后缀是为了避开同一类型中 `title(_:for:)` 等传统方法的 Swift 重名。
- 该命名对调用方不直观,属于历史包袱。

---

## 二、优化方案(按风险分级)

### 方案 A:抽取内部 helper,消除模板重复(推荐,低风险)

**不改任何对外 API**,仅新增 `private` 方法。

UIButton 侧(收到 `base.configuration` 为空时用 `.plain()` 兜底):

```swift
public extension FdyWrapper where Base: UIButton {
    @inline(__always)
    private func updateConfiguration(
        _ mutate: (inout UIButton.Configuration) -> Void
    ) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        mutate(&configuration)
        base.configuration = configuration
        return self
    }
}
```

Configuration 侧(操作对象就是 `base` 本身):

```swift
public extension FdyWrapper where Base == UIButton.Configuration {
    @inline(__always)
    private func update(
        _ mutate: (inout UIButton.Configuration) -> Void
    ) -> Self {
        var configuration = base
        mutate(&configuration)
        base = configuration
        return self
    }
}
```

16 个配置方法即可收敛为一行,行为完全等价:

```swift
func titleC(_ title: String) -> Self { updateConfiguration { $0.title = title } }
func cornerStyle(_ s: UIButton.Configuration.CornerStyle) -> Self { updateConfiguration { $0.cornerStyle = s } }
func backgroundStrokeColor(_ c: UIColor?) -> Self { updateConfiguration { $0.background.strokeColor = c } }
// ……其余同理
```

| 维度 | 说明 |
| --- | --- |
| 对外 API | 零变化,调用方无感知 |
| 行为 | 与当前完全一致 |
| 影响面 | 纯内部减法,仅两个 Chain 文件 |
| 风险 | 极低,符合稳定性优先原则 |

### 方案 B:统一命名,消除 `C` 后缀(中风险,建议暂缓)

将 `titleC` → `title`、`imageC` → `image` 等改干净,让 UIButton 直接复用 Configuration 链。

- **会破坏现有调用方**,需逐处排查工程内使用点。
- `title(_:for:)` 传统方法与无名 `title(_:)` 的 Swift 重载规则需谨慎处理。
- 鉴于稳定性优先,此项建议暂缓,仅作为后续可选演进。

### 方案 C:UIButton 配置方法委托给 Configuration wrapper(更大重构)

让 16 个 UIButton 方法内部调用已有的 `FdyWrapper<UIButton.Configuration>` 链。

- 收益有限、间接层增加、风险最高,不推荐现在做。

---

## 三、建议路径

**执行方案 A,且 UIButton 与 Configuration 两侧一起抽取** —— 精准解决重复这一核心痛点,行为零变化、零破坏,代价极低。

> `layoutImage(direction:spacing:)`、`isLoading(_:)`(禁用交互副作用)、`backgroundImage(_:for:)` 等带额外逻辑的方法保持原有实现不变,不强行套用 helper。

---

## 四、附:待办开关

| 项目 | 是否执行 | 备注 |
| --- | --- | --- |
| 方案 A:UIButton 侧抽 helper | **已执行** | 16 处模板收敛 → 见 §五 |
| 方案 A:Configuration 侧抽 helper | **已执行** | 16 处模板收敛 → 见 §五 |
| 方案 B:统一命名 | **已执行(改法与原设想不同)** | 未消除后缀,改为统一 `bc_` 前缀 → 见 §六 |
| 方案 C:委托重构 | 不推荐 | 收益有限、风险高 |

---

## 五、落地记录(2026-09-17,分支 `Swift6`)

两个文件各新增一个 `private extension`,16 + 16 处四行模板收敛为一行闭包:

```swift
// UIButton 侧:base.configuration 缺失时以 .plain() 兜底
private extension FdyWrapper where Base: UIButton {
    @discardableResult
    @inline(__always)
    func updateConfiguration(_ mutate: (inout UIButton.Configuration) -> Void) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        mutate(&configuration)
        base.configuration = configuration
        return self
    }

    /// background 是嵌套结构,再包一层免去每处写 `$0.background.xxx`
    @discardableResult
    @inline(__always)
    func updateBackground(_ mutate: (inout UIBackgroundConfiguration) -> Void) -> Self {
        updateConfiguration { mutate(&$0.background) }
    }
}

// Configuration 侧:操作对象就是 base 本身
private extension FdyWrapper where Base == UIButton.Configuration {
    @discardableResult
    @inline(__always)
    func updateConfiguration(_ mutate: (inout UIButton.Configuration) -> Void) -> Self {
        var configuration = base
        mutate(&configuration)
        base = configuration
        return self
    }
}
```

调用点由 4 行变 1 行:

```swift
// 改前
func titleC(_ title: String) -> Self {
    var configuration = base.configuration ?? UIButton.Configuration.plain()
    configuration.title = title
    base.configuration = configuration
    return self
}

// 改后
func titleC(_ title: String) -> Self {
    updateConfiguration { $0.title = title }
}

// 嵌套 background 的例子
func backgroundStrokeWidth(_ strokeWidth: CGFloat) -> Self {
    updateBackground { $0.strokeWidth = strokeWidth }
}
```

**保持原样、未套 helper 的三处**(按 §三 的约定):

| 方法 | 原因 |
| --- | --- |
| `isLoading(_:)`(UIButton 侧) | 带 `isUserInteractionEnabled` 副作用 |
| `layoutImage(direction:spacing:)` | 带 `switch` 分支逻辑 |
| `backgroundImage(_:for:)` / `contentEdgeInsets(_:)` | 有「配置化则改配置、否则走传统 API」的条件分支,语义不同 |

**验证**:

| 项 | 结果 |
| --- | --- |
| 对外 API 面 | **零变化**(仅新增 `private` 方法) |
| 整模块 `swiftc -typecheck`(251 文件) | **0 error / 0 warning** |
| `swiftformat --lint Sources/` | **0 / 251** |
| 行为回归(真实模块 + 探针,`UIButton.filled()` 起手) | 8 个链式属性落地值全部正确:`title/subtitle/imagePadding/titlePadding/cornerStyle/baseForegroundColor/backgroundStrokeColor/backgroundStrokeWidth/contentInsets` |
| 无配置兜底 | 起手 `configuration == nil`,调用 `.titleC("X")` 后 `configuration.title == "X"`(走 `?? .plain()`) |
| Configuration 侧 | `FdyWrapper(UIButton.Configuration.filled())` 链式 8 个属性落地值全部正确 |
| 双运行时 | iOS 18.0 与 26.5 输出**逐字节一致** |

> ⚠️ **一个附带发现**:`UIButton.Configuration` 没有 `FdyExtension` conformance(全库只有 `NSObject` 与 `Date` 两条),
> 且它不是 `NSObject` 子类,所以 `UIButton.Configuration.fdy.title(…)` **当前编译不过** ——
> 该文件的 16 个方法对外**不可达**(`FdyWrapper.init` 是 `internal`,外部无法手动构造)。
> 本轮只做行为等价的模板收敛;补 conformance 属于新增公开 API 面,需单独拍板。详见
> 《UIButton_Extensions_优化方案.md》§9.7。

---

## 六、文件拆分与命名收敛(2026-09-17 · 第二轮)

### 6.1 拆分:传统与配置化分开文件

原 `UIButton+Chain.swift` 一个文件里混着两类语义完全不同的方法,「看名字猜走哪条路径」成本高。按语义拆开:

| 文件 | 内容 | 方法数 |
| --- | --- | --- |
| `UIButton+Chain.swift` | 传统 API(`UIControl.State` 系列 setter + `UIControl.addAction`) | 11 |
| `UIButton+Configuration+Chain.swift`(**新增**) | 配置化 API(全部读写 `base.configuration`) | 18 |
| `UIButton.Configuration+Chain.swift` | **未动** —— `FdyWrapper<UIButton.Configuration>` 是另一个接收者,本身不混 | 16 |

拆分后才看清一个事实:`backgroundImage(_:for:)` / `contentEdgeInsets(_:)` 虽是传统签名,
但内部带「持有配置则改配置、否则走传统 API」的自动降级分支,所以留在传统文件里。

### 6.2 命名:配置化方法统一 `bc_` 前缀

| 改前 | 改后 |
| --- | --- |
| `titleC(_:)` | `bc_title(_:)` |
| `attributedTitleC(_:)` | `bc_attributedTitle(_:)` |
| `imageC(_:placement:)` | `bc_image(_:placement:)` |
| `backgroundImageC(_:)` | `bc_backgroundImage(_:)` |
| `subtitle(_:)` / `attributedSubtitle(_:)` | `bc_subtitle(_:)` / `bc_attributedSubtitle(_:)` |
| `isLoading(_:)` | `bc_isLoading(_:)` |
| `cornerStyle(_:)` / `contentInsets(_:)` / ... | `bc_cornerStyle(_:)` / `bc_contentInsets(_:)` / ... |
| `layoutImage(direction:spacing:)` | `bc_layoutImage(direction:spacing:)` |
| `configuration(_:)` | `bc_configuration(_:)` |

规则:`bc_`(button configuration) + 原方法名。原先只有 4 个方法带 `C` 后缀、其余 12 个是裸名,
同类型里「有的带标识有的不带」反而更难判断;现在 18 个方法一律 `bc_`,调用点一眼可分:

```swift
button.fdy.title("A", for: .normal)   // 传统 setter(见 UIButton+Chain.swift)
button.fdy.bc_title("A")              // 写 base.configuration(见 UIButton+Configuration+Chain.swift)
```

`UIButton.Configuration` 侧 16 个方法**未加前缀**:接收者本身即配置,不存在与传统 API 混淆的问题。

> 备注:`fdy_` 前缀在本库的原语义是「扩展方法」,`bc_` 只用于本组配置化链式方法的区分,两者不重叠。

### 6.3 验证

| 项 | 结果 |
| --- | --- |
| 整模块 `swiftc -typecheck`(252 文件) | **0 error / 0 warning** |
| `swiftformat --lint Sources/` | **0 / 252** |
| 行为回归(真实模块编成模拟器 dylib + 探针,19 项) | 全部符合预期 |
| 双运行时(iOS 18.0 / 26.5) | 输出**逐行一致** |
| 旧名可达性 | `titleC` / `subtitle` / `cornerStyle` / `isLoading` 均**编译报错** ✓ |
| 新名可达性 | `bc_*` 全链可用 ✓ |

探针覆盖:`bc_title` / `bc_subtitle` / `bc_cornerStyle` / `bc_backgroundStrokeWidth` / `bc_backgroundStrokeColor` /
`bc_imagePadding` / `bc_titlePadding` / `bc_contentInsets` / `bc_imagePlacement` / `bc_baseBackgroundColor` /
`bc_baseForegroundColor` 逐项写回;`bc_isLoading` 的交互副作用(`showsActivityIndicator` + `isUserInteractionEnabled`);
`bc_layoutImage` 的 `switch` 分支;`bc_configuration` 整体替换与传 `nil` 清空;无配置按钮的 `.plain()` 兜底;
传统 API 不写入 `configuration`;传统 `backgroundImage(_:for:)` 在配置化按钮上的自动降级。

> **改名影响面**:库内零调用点(`Sources/` 内无既有 `.fdy.titleC` / `.fdy.cornerStyle` 之类),
> README 的 UIButton 示例全部走传统 API,故本次改名**无迁移成本**。

> ⚠️ **文件命名歧义提示**:`UIButton+Configuration+Chain.swift`(加号,接收者是 `UIButton`)与
> `UIButton.Configuration+Chain.swift`(点号,接收者是 `UIButton.Configuration`)只差一个字符,
> 目录列表里容易看错。两者都符合本库既有的「内嵌类型用点号」命名(`UIImage.SymbolConfiguration+Chain.swift`),
> 暂不改名,仅在文件头注释里标明各自接收者。
