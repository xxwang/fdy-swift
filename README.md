# Fdy

轻量级 Swift 扩展工具库。基于 `FdyExtension` 协议 + `FdyWrapper` 泛型命名空间，为 UIKit、Foundation、CoreGraphics、QuartzCore、MapKit、WebKit 等提供 `.fdy` 链式 API 与批量工具扩展，**不污染原生类型**。

```swift
import Fdy   // 一键引入全部模块

// 全局工具入口
fdy.logger.debug("hello")
fdy.helper.isPad            // -> Bool
fdy.perChecker.request(.camera) { result in ... }
fdy.queue.asyncMain { ... }
fdy.screen.width             // -> CGFloat
fdy.symbol.monochrome(for: "star", color: .red)

// 链式配置视图（引用类型，无需 .build()）
let view = UIView()
    .fdy
    .backgroundColor(.white)
    .cornerRadius(8)
    .masksToBounds(true)

// 值类型链式（返回新副本）
let point = CGPoint(x: 10, y: 20)
    .fdy.with { $0.x += 5; $0.y *= 2 }

// 颜色便捷初始化
let color = UIColor(hex: "#FF5722")

// UserDefaults 属性包装器
@FdyDataStore("userName", default: "")
var userName: String
```

## 模块

单一 target，所有功能集中在一个 `Fdy` 模块中：

| 路径 | 内容 |
|------|------|
| `Sources/Fdy/Core` | 核心：`.fdy` 命名空间、Chain 链式 API、Extensions、通用工具类 |
| `Sources/Fdy/Combine` | Combine + UIKit 事件封装（`fdy_*Publisher`） |
| `Sources/Fdy/Logger` | 5 级日志 + 可插拔输出目标 |
| `Sources/Fdy/Fdy.swift` | 模块入口，重导出 `UIKit` / `Combine` |

> `import Fdy` 即引入全部功能（含 `UIKit` / `Combine`）。

## 安装

Swift Package Manager：

```swift
// Package.swift
.package(url: "https://github.com/xxwang/Dy.git", branch: "main")

// Xcode: File → Add Package Dependency → 输入仓库 URL
```

平台要求：**iOS 18.0+ / Swift 6.0**，无任何第三方依赖。

---

## 链式 API 核心

所有扩展通过 `.fdy` 命名空间访问，基于两个入口（定义于 `Sources/Core/Protocols/FdyExtension.swift`）：

- **实例入口** `object.fdy` → `FdyWrapper<Object>`
- **类型入口** `Type.fdy` → `FdyWrapper<Type.Type>`（用于配置静态/类属性）

`FdyWrapper<Base>` 提供四个通用方法：

```swift
let v = UIView()
    .fdy.build()                          // 取出被包装的实例

CGPoint(x: 0, y: 0)
    .fdy.with { $0.x = 10 }               // 值类型：操作副本并返回新值

[1, 2, 3].fdy.do { print($0) }            // 副作用：仅执行闭包

UILabel().fdy.then { $0.text = "hi" }     // 引用类型：配置并返回自身，可继续链式
```

### Chain 链式配置

`Sources/Core/Chain/` 按系统框架组织，为各类型提供**同名 setter 链式方法**，全部返回 `Self`。引用类型可省略 `.build()`：

```swift
let label = UILabel()
    .fdy
    .text("标题")
    .font(.boldSystemFont(ofSize: 18))
    .textColor(.red)
    .textAlignment(.center)
    .numberOfLines(0)

let button = UIButton(type: .system)
    .fdy
    .title("提交", for: .normal)
    .titleColor(.white, for: .normal)
    .backgroundColor(.systemBlue)
    .cornerRadius(8)

let layer = CAGradientLayer()
    .fdy
    .colors([UIColor.red.cgColor, UIColor.blue.cgColor])
    .locations([0, 1])
    .startPoint(CGPoint(x: 0, y: 0))
    .endPoint(CGPoint(x: 1, y: 1))
```

> **UIButton 的链式方法分两套**，定义在两个文件里，调用点一眼可分：
> - **传统 API** —— 按 `UIControl.State` 取值（`.title(_:for:)` / `.titleColor(_:for:)` / `.backgroundImage(_:for:)` …），
>   见 `Core/Chain/UIKit/UIButton+Chain.swift`；
> - **配置化 API** —— 读写 `UIButton.Configuration`，方法名统一 **`bc_`**（button configuration）前缀，
>   见 `Core/Chain/UIKit/UIButton+Configuration+Chain.swift`：
>
> ```swift
> let submit = UIButton.plain()
>     .fdy
>     .bc_title("提交")
>     .bc_cornerStyle(.capsule)
>     .bc_baseBackgroundColor(.systemBlue)
>     .bc_baseForegroundColor(.white)
>     .bc_contentInsets(NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
>     .build()
> ```
>
> 两者可混用，但同一属性请只用一套：传统 setter 会被 `configuration` 覆盖。

支持 Chain 的类型覆盖：`UIView`/`UIButton`/`UILabel`/`UITextField`/`UITextView`/`UIImageView`/`UICollectionView`/`UITableView`/`UIScrollView`/`UIStackView`/`UIViewController`/`CALayer`/`CAAnimation` 系列、`CAGradientLayer`、`MKMapView`、`WKWebView`、`NSAttributedString`、`Date`、`Timer`、`UIEdgeInsets` 等 60+ 类型。

### 可复用控件（`Sources/Core/Components/`）

视觉上要做得小、但要保证 44×44pt 点击热区的按钮，以及需要防止用户连点重复提交的按钮，
都用 `FdyHitAreaButton`：

```swift
let close = FdyHitAreaButton(type: .custom)
    .fdy
    .image(UIImage(systemName: "xmark"), for: .normal)
    .expandClickArea(12)              // 向四周各扩展 12pt
    .build()

let submit = FdyHitAreaButton(type: .custom)
    .fdy
    .title("提交", for: .normal)
    .repeatClickInterval(0.5)         // 0.5s 内的重复触发只放行第一次
    .build()

// 也可以直接赋值（<= 0 表示不生效）
close.fdy_expandSize = 12
submit.fdy_repeatClickInterval = 0.5
```

> - 两项能力都实现在 `FdyHitAreaButton` 自身：热区走 `point(inside:with:)`，防重复走 `sendAction` 的两个重载。
>   **只对该类及其子类生效，不污染其它 `UIButton`。**
> - 防重复点击**按业务动作分别计时**（键为 selector 名 / `UIAction.identifier`），
>   因此「`.touchDown` 做按压反馈 + `.touchUpInside` 做业务」不会互相挤占时间窗；
>   通过 `addAction(UIAction)` 注册的回调同样受保护。
> - 命中时间窗时**不改动 `isEnabled` 或任何视觉状态**，只是不派发该次动作。
> - 历史版本通过 `UIButton` 扩展注入 `point(inside:with:)` 实现全局热区扩展
>   （`fdy.expandClickArea(_:)` / `fdy_expandClickArea(_:)`），**该入口已移除** ——
>   它会作用于所有 `UIButton`（含 UIKit 内部按钮），且一旦某个子类重写了 `point(inside:with:)` 就会静默失效。
>   原调用点会拿到编译错误：`requires that 'UIButton' inherit from 'FdyHitAreaButton'`。
> - **一个必踩的坑**：扩展区域超出父视图 `bounds` 时不生效 —— `hitTest` 先询问父视图，父视图判定点不在自己范围内就直接返回 `nil`，根本不会询问本按钮。

### 手势链式（UIView）

```swift
let view = UIView()
    .fdy
    .onTapGestureRecognizer { tap in
        print("单击")
    }
    .onLongPressGestureRecognizer(minimumDuration: 0.5) { press in
        print("长按")
    }
```

> 闭包被内部手势识别器强引用，闭包内使用 `self` 时请加 `[weak self]` 避免循环引用。

### 类型级配置

```swift
UIViewController.fdy.do { $0.backgroundColor = .systemRed }   // 配置静态属性
```

---

## 扩展方法（`Sources/Core/Extensions/`）

按系统框架与领域组织，均带 `fdy_` 前缀，直接作用于原生类型（无需 `.fdy`）：

### UIKit

```swift
UIColor(hex: "#FF5722")                // 3/4/6/8 位 hex（非可选）
UIColor(argbHex: "#80FF5722")          // ARGB（含透明度，可选）
color.fdy.alpha(0.5)                    // 透明度
color.fdy_random                        // 随机色

let view = UIView()
view.fdy.removeAllSubviews()            // 移除所有子视图
view.fdy.hideKeyboard()                 // 收起键盘
view.fdy_viewController                 // 最近的父控制器
view.fdy_allSubviews                    // 递归所有子视图
view.fdy_findSubview(ofType: MyView.self)
view.fdy_captureScreenshot()            // 截图

label.fdy_actualFontSize                // 实际字号
textField.fdy_textPublisher             // 见 CombineCocoa
button.fdy_viewSize()                   // 标题尺寸，默认不折行（.greatestFiniteMagnitude）
button.fdy_viewSize(maxWidth: FdyScreen.screenWidth)   // 按屏宽折行时显式传入

UIFont.fdy_font(size: 16, weight: .medium)   // 任意字族（默认苹方），不参与 Dynamic Type
UIFont.fdy_font(size: 16, weight: .medium)
    .fdy_scaled(forTextStyle: .body)         // 响应系统 Dynamic Type 缩放
```

### Foundation

```swift
object.fdy_className                    // "MyViewController"（实例）
MyClass.fdy_className                   // "MyClass"（类型）
bundle.fdy_appVersion                   // 版本号
date.fdy_adding(days: 7)                // 日期运算
data.fdy_bytes()                        // Data → [UInt8]
url.fdy_appendParameters([...])         // URL 追加参数
```

### Protocols / Stdlib

```swift
[1, 2, 3].fdy_average                   // 平均值
array.fdy_safe(at: 100)                 // 安全下标，越界返回 nil
array.fdy_removeDuplicates()            // 去重（保持顺序）
"hello".fdy_uppercased()                // 字符串工具

model.fdy_encode()                      // Codable → Data?
model.fdy_string()                      // Codable → JSON 字符串
MyModel.fdy_decode(from: data)          // Data → Codable
```

### 其他框架

- **CoreGraphics**：`CGPoint`/`CGSize`/`CGRect`/`CGColor`/`CGImage`/`CGAffineTransform` 等
- **QuartzCore**：`CALayer`/`CAGradientLayer`/`CATransform3D`/`CACornerMask` 动画与属性
- **MapKit**：`MKMapView`/`MKCoordinateRegion`/`MKPolyline` 等
- **WebKit**：`WKWebView`/`WKWebViewConfiguration`
- **CoreLocation**：`CLLocation`/`CLGeocoder`/`CLLocationManager` 等
- **AVFAudio**：`AVAudioSession`

---

## 全局工具入口 `fdy`

所有工具类通过全局 `fdy` 变量统一访问，无需记住每个类的 `shared`：

```swift
fdy.logger.debug("hello")
fdy.helper.isPad                    // -> Bool
fdy.perChecker.request(.camera) { result in ... }
fdy.queue.asyncMain { ... }
fdy.screen.width                    // -> CGFloat
fdy.symbol.monochrome(for: "star", color: .red)
fdy.haptic.mediumImpact()           // 主线程
```

> `fdy` 是 `FdyGlobal` 类的全局实例，聚合了 7 个工具类。各工具类仍可单独通过 `FdyXxx.shared` 访问。

## 工具类（`Sources/Core/Common/`）

| 类 | `fdy` 入口 | 功能 |
|----|-----------|------|
| `FdyScreen` | `fdy.screen` | 屏幕尺寸、安全区、状态栏/导航栏/标签栏高度、设计稿适配 |
| `FdyHelper` | `fdy.helper` | 设备信息（IDFV/IDFA/机型/系统版本/越狱检测等） |
| `FdyPath` | `fdy.path` | 沙盒路径与文件操作 |
| `FdyQueue` | `fdy.queue` | 异步调度、防抖、定时器、一次性执行、串行/并发队列 |
| `FdyHaptic` | `fdy.haptic` | 触觉反馈 |
| `FdyPermissionChecker` | `fdy.perChecker` | 权限状态查询与请求 |
| `FdySymbol` | `fdy.symbol` | SF Symbol 便捷创建（单色/分层/调色板/多色） |
| `FdyAppearance` | — | 全局 UI 外观配置 |
| `FdySkinManager` | — | 主题切换观察 |
| `FdyViewBuilder` | — | `@resultBuilder` 声明式子视图组装 |
| `FdyScreenCaptureMonitor` | — | 录屏/投屏检测 |
| `FdyPlist` | — | plist 读写 |
| `FdyCreator` | — | 通用创建工具 |

### 屏幕与适配

```swift
fdy.screen.setupSketch(size: CGSize(width: 375, height: 812))  // 设设计稿

16.fitWidth          // 按设计稿宽度等比缩放（Int / CGFloat 均支持）
20.fitHeight         // 按设计稿高度等比缩放
12.fitLarger         // 宽高取较大
8.fitSmaller         // 宽高取较小

fdy.screen.width / height / scale
fdy.screen.safeAreaTop / safeAreaBottom
fdy.screen.statusBarHeight
fdy.screen.navBarTotalHeight          // 状态栏 + 导航栏
fdy.screen.tabBarTotalHeight          // 标签栏 + 底部安全区
fdy.screen.isCaptured                 // 是否录屏/投屏
```

### 设备信息

```swift
fdy.helper.isSimulator
fdy.helper.isDebug
fdy.helper.isPad / isPhone
fdy.helper.isIPhoneXSeries
fdy.helper.isJailbroken
fdy.helper.identifierForVendor   // IDFV
fdy.helper.advertisingIdentifier // IDFA（需授权）
fdy.helper.systemVersion
fdy.helper.className(Self.self)
```

### 队列与定时器

```swift
fdy.queue.debounced(delay: 0.3) { performSearch() }   // 防抖
fdy.queue.executeSerially([task1, task2]) { print("完成") }
fdy.queue.executeConcurrently([...])
fdy.queue.executeOnce(token: "app.init") { setupAnalytics() }
fdy.queue.countdownTimer(every: 1.0, times: 5) { _, remaining in }
fdy.queue.delayed(1.0) { ... }
```

### 沙盒路径

```swift
fdy.path.documentsDirPath
fdy.path.cachesDirPath
fdy.path.path(in: .caches, ...)        // 或 resolvePath
fdy.path.exists(at: path)
fdy.path.createFile(at: path)
fdy.path.remove(at: path)
```

### 触觉反馈

```swift
fdy.haptic.lightImpact()
fdy.haptic.mediumImpact()
fdy.haptic.heavyImpact()
fdy.haptic.rigidImpact()
fdy.haptic.softImpact()
fdy.haptic.selectionChanged()
fdy.haptic.notification(.success)
fdy.haptic.haptic(.medium, style: .rigid)   // 自定义强度
```

### 权限管理

```swift
fdy.perChecker.checkStatus(for: .camera)   // 查询状态
fdy.perChecker.request(.photoLibrary) { result in
    switch result {
    case .authorized:     loadPhotos()
    case .denied:         showSettingsAlert()
    }
}
// 便捷方法：checkCamera / requestCamera / checkMicrophone / requestLocation ...
```

### SF Symbol

```swift
fdy.symbol.monochrome(for: "star.fill", color: .red)
fdy.symbol.hierarchical(for: "star.fill", hierarchicalColor: .yellow)
fdy.symbol.palette(for: "star.fill", paletteColors: [.yellow, .orange])
fdy.symbol.multicolor(for: "star.fill")
```

### 声明式视图构建（`@FdyViewBuilder`）

```swift
let container = UIView()
container.fdy.addSubviews(
    FdyViewBuilder.buildBlock(
        UILabel(),
        UIButton(type: .system),
        showImage ? UIImageView() : nil
    )
)
```

---

## 属性包装器（`@FdyDataStore`）

用 `UserDefaults` 存储属性，自动处理原生类型与 `Codable` 的编解码：

```swift
@FdyDataStore("userName", default: "")
var userName: String

@FdyDataStore("lastVisit", default: nil)
var lastVisit: Date?          // Codable 自动 JSON 编解码

$userName.remove()            // 删除存储值
```

支持原生类型（`Bool`/`Int`/`Float`/`Double`/`String`/`Date`/`Data`/`Array`/`Dictionary`）与任意 `Codable` 类型；不支持的类型会报错并清理。

---

## CombineCocoa

UIKit 事件封装为 Combine `Publisher`/`ControlProperty`，可用 `sink` 订阅、`assign`/`bind` 写回：

```swift
// 属性流（可读可写）
textField.fdy_textPublisher
textField.fdy_attributedTextPublisher
label.fdy_textPublisher
switchView.fdy_isOnPublisher
slider.fdy_valuePublisher
stepper.fdy_valuePublisher
segmented.fdy_selectedSegmentIndexPublisher

// 事件流
button.fdy_tapPublisher               // ControlEvent<Void>
control.fdy_valueChangedPublisher

// 手势
view.fdy_tapGesturePublisher
view.fdy_tapGesturePublisher(numberOfTaps: 2)   // 双击
view.fdy_longPressGesturePublisher
view.fdy_panGesturePublisher
view.fdy_swipeGesturePublisher(.left)
view.fdy_pinchGesturePublisher
view.fdy_rotationGesturePublisher
view.fdy_screenEdgePanGesturePublisher

// 滚动
scrollView.fdy_didScrollPublisher
scrollView.fdy_willBeginDraggingPublisher
scrollView.fdy_didEndDraggingPublisher
scrollView.fdy_didEndDraggingWithDecelerationPublisher   // ControlEvent<Bool>，载荷为 willDecelerate
scrollView.fdy_didEndDeceleratingPublisher
scrollView.fdy_contentOffsetPublisher                    // ControlProperty<CGPoint>
```

双向绑定：

```swift
// 订阅
textField.fdy_textPublisher
    .sink { print("text: \($0 ?? "")") }
    .store(in: &cancellables)

// 写回 / 绑定
label.fdy_textPublisher.bind(from: viewModel.titlePublisher)
```

### 语义与硬边界

| 项 | 行为 |
| --- | --- |
| `ControlProperty` 去重 | **同值不重发**。赋值与用户事件两路合并后走 `removeDuplicates()`，也是双向绑定回声抑制的前提 |
| 文本输入 | `fdy_textPublisher` / `fdy_attributedTextPublisher` 逐键实时。纯 KVO 观察不到打字：`UIKeyInput`/TextKit 直写内部存储，只在**代码赋值**与 `resignFirstResponder()` 时同步 |
| 值类控件 | 原生 `setValue(_:animated:)` / `setOn(_:animated:)` 连 `animated: false` 都**两个通道都不发通知**。需要通知订阅者时改用 `fdy_setValue(_:animated:)` / `fdy_setOn(_:animated:)` |
| 滚动代理 | `fdy_*Publisher` 首次订阅会接管 `UIScrollView.delegate`（原 delegate 被保留并转发）；若被外部顶替，**下次访问 publisher 时自动重新接管** |

```swift
slider.fdy_setValue(0.9, animated: true)   // 原生 setValue 不发通知，这个会
switchView.fdy_setOn(true, animated: true)
```

---

## Logger

5 级日志，可插拔输出目标（控制台 / 文件）：

```swift
FdyLogger.shared.addDestination(FdyConsoleDestination())

if let fileDest = FdyFileDestination(filePath: logPath) {
    FdyLogger.shared.addDestination(fileDest)
}

FdyLogger.shared.debug("调试")
FdyLogger.shared.info("加载完成")
FdyLogger.shared.warn("超时")
FdyLogger.shared.error("解析失败")
FdyLogger.shared.fatal("致命错误")

FdyLogger.shared.minimumLevel = .warn   // 生产环境只输出 warn 及以上

// 全局便捷函数
fdy_logInfo("数据加载完成")
fdy_logError("解析失败")
```

---

## 设计原则

- **不污染原生类型** — 实例方法通过 `.fdy` 命名空间（`FdyWrapper`）隔离，工具类通过全局 `fdy` 入口访问。
- **链式调用** — Chain setter 返回 `FdyWrapper`，支持连续配置；引用类型可省略 `.build()`。
- **双入口** — 实例 `object.fdy` 与类型 `Type.fdy`（配置静态/类属性）；全局 `fdy` 聚合工具类。
- **值类型安全** — `.with` 返回副本，不改原值。
- **健壮回退** — 字体字族、资源加载等不可用时优雅回退，不 crash。
- **iOS 18+** — 最低支持版本，Swift 6.0 工具链 + Swift 5 语言模式。

## 目录结构

```
Sources/
└── Fdy/
    ├── Fdy.swift             # 模块入口（重导出 UIKit / Combine）
    ├── Core/
    │   ├── Chain/           # 链式 API（UIKit/Foundation/QuartzCore/MapKit/WebKit...）
    │   ├── Common/          # 工具类（FdyScreen/FdyHelper/FdyPath/FdyQueue...）
    │   ├── Components/      # 可复用控件（FdyHitAreaButton：点击热区 / 防重复点击）
    │   ├── Extensions/      # fdy_ 前缀扩展（按框架组织）
    │   ├── Protocols/       # FdyExtension/FdyReusable/FdyLoadable/FdySetupable
    │   ├── Wrapper/         # @FdyDataStore
    │   └── Core.swift
    ├── Combine/             # Combine + UIKit 事件
    └── Logger/             # FdyLogger + 输出目标
```

## 协议

- `FdyExtension` — 命名空间协议，所有扩展的基础（`.fdy` 入口）
- `FdyReusable` — 自动生成复用标识符（`fdy_identifier`）
- `FdyLoadable` — 从 XIB/Storyboard 加载
- `FdySetupable` — MVVM 配置生命周期

## License

Apache 2.0
