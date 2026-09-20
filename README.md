# Fdy

轻量级 Swift 扩展工具库。基于 `FdyExtension` 协议 + `FdyWrapper` 泛型命名空间，为 UIKit、Foundation、CoreGraphics、QuartzCore、MapKit、WebKit 等提供 `.fdy` 链式 API 与批量工具扩展，**不污染原生类型**。

```swift
import Fdy   // 一键引入全部模块

// 全局工具入口（聚合 7 个工具类）
fdyG.logger.debug("hello")
fdyG.helper.isPad            // -> Bool
fdyG.perChecker.request(.camera) { result in ... }
fdyG.queue.asyncMain { ... }
fdyG.screen.width             // -> CGFloat（须主线程）
fdyG.symbol.monochrome(for: "star", color: .red)

// 链式配置视图（引用类型，无需 .build()）
let view = UIView()
    .fdy
    .backgroundColor(.white)
    .cornerRadius(8)
    .masksToBounds(true)

// 值类型链式（返回新副本，需要 .build() 收尾）
let configuration = UIButton.Configuration.plain()
    .fdy
    .title("确定")
    .cornerStyle(.capsule)
    .build()

// 颜色便捷初始化
// `fdy_` 前缀是刻意的：系统类型上的构造器若不带前缀，会与宿主项目（或另一个三方库）
// 的同名构造器碰撞。实测两种表现：
//   两个模块都声明 UIColor(hex:)  -> ambiguous use of 'init(hex:)'
//   只有宿主自己声明             -> 不报错，宿主的实现静默胜出、库的版本被无声取代
// 后者更难排查，所以前缀不是洁癖。
let color = UIColor(fdy_hex: "#FF5722")

// UserDefaults 属性包装器
@FdyDataStore("userName", default: "")
var userName: String
```

## 模块

单一 target，所有功能集中在一个 `Fdy` 模块中：

| 路径 | 内容 |
|------|------|
| `Sources/Fdy/Fdy.swift` | 模块入口，重导出 `UIKit` / `Combine` |
| `Sources/Fdy/Chain` | `.fdy` 链式 API（UIKit / Foundation / QuartzCore / MapKit / WebKit…） |
| `Sources/Fdy/Combine` | Combine + UIKit 事件封装（`fdy_*Publisher`） |
| `Sources/Fdy/Common` | 工具类与单例管理器（`FdyScreen` / `FdyHelper` / `fdyG`…） |
| `Sources/Fdy/Components` | 可复用控件（`FdyButton` / `FdyTextView`） |
| `Sources/Fdy/Extensions` | `fdy_` 前缀扩展（按框架分目录） |
| `Sources/Fdy/Logger` | 5 级日志 + 可插拔输出目标 |
| `Sources/Fdy/Protocols` | 本库自有协议（`FdyExtension` / `FdySetupable` / `FdySkinable`…） |

> `import Fdy` 即引入全部功能（含 `UIKit` / `Combine`）。

## 安装

Swift Package Manager：

```swift
// Package.swift
.package(url: "https://github.com/xxwang/fdy-swift.git", branch: "Swift6")
// 打 tag 发版后建议改用版本号：.package(url: "...fdy-swift.git", from: "0.1.0")

// Xcode: File → Add Package Dependency → 输入仓库 URL
```

平台要求：**iOS 18.0+ / Swift 6.0**，无任何第三方依赖。

---

## 链式 API 核心

所有扩展通过 `.fdy` 命名空间访问，基于两个入口（定义于 `Sources/Fdy/Protocols/FdyExtension.swift`）：

- **实例入口** `object.fdy` → `FdyWrapper<Object>`
- **类型入口** `Type.fdy` → `FdyWrapper<Type.Type>`（用于配置静态/类属性）

`FdyWrapper<Base>` 提供四个通用方法：

```swift
let v = UIView()
    .fdy.build()                          // 取出被包装的实例

UIButton.Configuration.plain()
    .fdy.with { $0.title = "确定" }        // 值类型：操作副本并返回新值

UILabel().fdy.do { print($0.text ?? "") }  // 副作用：仅执行闭包

UILabel().fdy.then { $0.text = "hi" }      // 引用类型：配置并返回自身，可继续链式
```

> `.fdy` 需要目标类型 conform `FdyExtension`。库内共 **33 条**（清单见文末「协议」一节）：
> `NSObject` 那条被所有类子类继承，`UIView` / `UIViewController` 等引用类型因此自动可用；
> `CGPath` 那条则被子类 `CGMutablePath` 继承（Core Foundation 类型同样有 Swift 侧继承）。
> 常用值类型（`CGPoint` / `[Int]` / `Data` / `UIBackgroundConfiguration` 等）**已逐条登记**，可直接使用。

### Chain 链式配置

`Sources/Fdy/Chain/` 按系统框架组织，为各类型提供**同名 setter 链式方法**，全部返回 `Self`。引用类型可省略 `.build()`：

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
    .colors([UIColor.red, UIColor.blue])
    .locations([0, 1])
    .startPoint(CGPoint(x: 0, y: 0))
    .endPoint(CGPoint(x: 1, y: 1))
```

> **UIButton 的链式方法分两层**，定义在两个文件里：按钮侧 `UIButton+Chain.swift`（24 个方法）
> 与配置侧 `UIButton.Configuration+Chain.swift`（43 个方法）。

#### 按钮侧 —— `Chain/UIKit/UIButton+Chain.swift`

分三组。

**配置化（4）**

| 方法 | 说明 |
| --- | --- |
| `configuration(_:)` | 整体替换按钮的 `UIButton.Configuration`（参数非可选） |
| `configurationUpdateHandler(_:)` | 设置/清除配置更新处理器（`UIControl.State` 状态分支的官方落点） |
| `automaticallyUpdatesConfiguration(_:)` | 状态变化时是否自动派生配置（默认 `true`） |
| `setNeedsUpdateConfiguration()` | 主动请求刷新配置（下一个布局周期执行） |

**菜单与指针（6）**

| 方法 | 说明 |
| --- | --- |
| `role(_:)` | 按钮角色（`.primary` / `.cancel` / `.destructive`） |
| `menu(_:)` | 挂 `UIMenu`（非 `nil` 时自动启用 context menu 交互） |
| `preferredMenuElementOrder(_:)` | 菜单元素排序策略（iOS 16+） |
| `changesSelectionAsPrimaryAction(_:)` | 主操作是否切换选中态 |
| `isPointerInteractionEnabled(_:)` | 是否启用内置指针交互（iPadOS） |
| `pointerStyleProvider(_:)` | 指针效果自定义提供者 |

「点击直接弹菜单」需 `menu(_:)` 配合 `UIControl` 侧的 `showsMenuAsPrimaryAction(_:)`。

**传统 API（14）**

基于 `UIControl.State` 的 setter：`addAction` / `title` / `attributedTitle` / `titleColor` / `titleShadowColor` /
`font` / `image` / `preferredSymbolConfiguration(_:for:)` / `backgroundImage`（图片）/
`backgroundColor`（纯色，含指定状态重载）/ `contentEdgeInsets` / `titleEdgeInsets` / `imageEdgeInsets`。

其中 `backgroundImage` / `backgroundColor(_:for:)` / `contentEdgeInsets` 在按钮**已持有配置**时自动改走 `configuration` 路径 ——
iOS 15 起这些传统属性会被 `UIButton.Configuration` 忽略。`backgroundColor(_:)` 没做这层分派，
它只写 `view.backgroundColor`，与 `configuration.background` 是两层，仅建议用于非配置按钮。

> **实测补充（iOS 18.0 / 26.5 一致）**：配置模式下 `.normal` 的 `title` / `attributedTitle` / `image`
> 会被 UIKit bridge 进 `configuration`（异步，下一 layout 周期落地）；但**非 `.normal` 状态会被丢弃** ——
> 配置没有状态维度，多状态请走 `configurationUpdateHandler(_:)`。
> `titleColor` / `titleShadowColor` / `preferredSymbolConfiguration(_:for:)` / `titleEdgeInsets` /
> `imageEdgeInsets` / `font` 在配置模式下不生效，保留它们是为了**非配置模式**的按钮（`UIButton.button()`）。
>
> **`UIControl` 层的方法按钮同样可用**（`UIControl+Chain.swift`，15 个）：`isEnabled` / `isSelected` /
> `isHighlighted` / `contentVerticalAlignment` / `contentHorizontalAlignment` / `showsMenuAsPrimaryAction` /
> `isContextMenuInteractionEnabled` / `toolTip` / `isSymbolAnimationEnabled` / `addTarget` / `removeTarget` /
> `removeAction`（对象与 identifier 两个重载）/ `sendActions(for:)` / `performPrimaryAction()`。
> 其中 `toolTip` 实测在模拟器上写入后读回仍是 `nil`（含直接写属性），需真机 / 指针环境才有实际效果。

#### 配置侧 —— `Chain/UIKit/UIButton.Configuration+Chain.swift`

43 个 `UIButton.Configuration` 的链式方法（42 个单项属性 + `layoutImage` 组合方法）。接收者是**配置对象本身**（不是按钮），
因此入口是 `configuration.fdy.xxx(...)`，方法名与属性同名、**无前缀**；值类型语义，需 `build()` 取回：

```swift
let configuration = UIButton.Configuration.filled().fdy
    .title("提交")
    .subtitle("副标题")
    .image(UIImage(systemName: "checkmark"), placement: .leading)
    .imagePadding(6)
    .cornerStyle(.capsule)
    .baseBackgroundColor(.systemBlue)
    .baseForegroundColor(.white)
    .backgroundCornerRadius(8)
    .build()

let submit = UIButton.plain()
    .fdy
    .configuration(configuration)
    .build()
```

按属性分组的方法全集：

| 组 | 方法 |
| --- | --- |
| 文本（10） | `title` `attributedTitle` `subtitle` `attributedSubtitle` `titlePadding` `titleLineBreakMode` `subtitleLineBreakMode` `titleAlignment` `titleTextAttributesTransformer` `subtitleTextAttributesTransformer` |
| 图标（7） | `image(_:placement:)` `imagePlacement` `imagePadding` `imageReservation` `preferredSymbolConfigurationForImage` `imageColorTransformer` `symbolContentTransition`（iOS 26+） |
| 加载与指示器（4） | `isLoading` `activityIndicatorColorTransformer` `indicator` `indicatorColorTransformer` |
| 颜色与尺寸（6） | `baseBackgroundColor` `baseForegroundColor` `cornerStyle` `buttonSize` `macIdiomStyle` `automaticallyUpdateForSelection` |
| 布局（3） | `contentInsets` `defaultContentInsets` `layoutImage(direction:spacing:)` |
| 背景（13） | `backgroundImage` `backgroundImageContentMode` `backgroundColor` `backgroundColorTransformer` `backgroundCornerRadius` `backgroundInsets` `backgroundMarginEdges` `backgroundStrokeColor` `backgroundStrokeColorTransformer` `backgroundStrokeWidth` `backgroundStrokeOutset` `backgroundVisualEffect` `backgroundCustomView` |

> - 背景组对应 `UIBackgroundConfiguration` 的属性，统一用 `background` 前缀；唯一改名的是
>   `edgesAddingLayoutMarginsToBackgroundInsets` → `backgroundMarginEdges`（原名过长）。
> - `background.shadowProperties` 已覆盖（`shadowColor` / `shadowOpacity` / `shadowRadius` / `shadowOffset` /
>   `shadowPath`），见独立的 `Chain/UIKit/UIBackgroundConfiguration+Chain.swift`。
>   **注意**：ObjC 头文件把 `shadowProperties` 标成了 `readonly`，但 Swift 侧是 `{ get set }`，
>   `configuration.shadowProperties.radius = 4` 实测可编译 —— 以编译器为准。
> - **多状态（高亮/选中/禁用）请配合 `configurationUpdateHandler(_:)`**：
>   在 handler 里基于「外部只读模板」重建配置再写回，**不要在 handler 内读回 `button.configuration`** ——
>   `automaticallyUpdatesConfiguration` 默认为 `true`，UIKit 会把派生后的配置写回，导致状态回退时残留旧值。
>   另注意 UIKit 只对**颜色**派生状态样式，背景图/图标在各状态下完全相同，需要自己换。

支持 Chain 的类型覆盖：`UIView`/`UIButton`/`UILabel`/`UITextField`/`UITextView`/`UIImageView`/`UICollectionView`/`UITableView`/`UIScrollView`/`UIStackView`/`UIViewController`/`CALayer`/`CAAnimation` 系列、`CAGradientLayer`、`MKMapView`、`WKWebView`、`NSAttributedString`、`Date`、`Timer`、`UIEdgeInsets`、`DateComponents`、`CGMutablePath`、**外观配置系**（`UIBarAppearance`/`UINavigationBarAppearance`/`UITabBarAppearance`/`UIBackgroundConfiguration`/`UIListContentConfiguration`/`UIContentUnavailableConfiguration`）等 60+ 类型。

#### 外观配置系（6 个文件 / 138 个方法）

导航栏与标签栏外观、列表内容与空态配置的链式方法。**class 与 struct 的语义不同**，这是最容易用错的一点：

| 类型 | 文件 | 语义 | 方法数 |
| --- | --- | --- | --- |
| `UIBarAppearance`（基类） | `UIBarAppearance+Chain.swift` | 引用 —— 就地改，免 `build()` | 10 |
| `UINavigationBarAppearance` | `UINavigationBarAppearance+Chain.swift` | 引用（另**继承**基类 10 个） | 13 |
| `UITabBarAppearance` | `UITabBarAppearance+Chain.swift` | 引用（另**继承**基类 10 个） | 8 |
| `UIBackgroundConfiguration` | `UIBackgroundConfiguration+Chain.swift` | **值** —— 须 `build()` 取回 | 19 |
| `UIListContentConfiguration` | `UIListContentConfiguration+Chain.swift` | **值** | 45 |
| `UIContentUnavailableConfiguration` | `UIContentUnavailableConfiguration+Chain.swift` | **值** | 43 |

> - **继承**：基类那 10 个写在 `where Base: UIBarAppearance` 上，两个子类**自动拿到**，无需重复实现
>   （双运行时探针 `S43` 钉的就是这条）。
> - **嵌套 struct 轴按既有约定拍平加前缀**（先例：`UIButton.Configuration` 的 `backgroundCornerRadius`）：
>   `textProperties.font` → `textFont(_:)`、`imageProperties.tintColor` → `imageTintColor(_:)`、
>   `buttonProperties.role` → `buttonRole(_:)`、`shadowProperties.radius` → `shadowRadius(_:)`。
> - **可用性**：`overrideUserInterfaceStyle` 需 `iOS 27`；`subtitleTextAttributes` /
>   `largeSubtitleTextAttributes` / `UIToolbarAppearance.prominentButtonAppearance` 需 `iOS 26`。
>   对应链式方法已带 `@available` 标注（反证实测：去掉标注即编译报错）。
> - **未覆盖**：`UIToolbarAppearance`（仅 `buttonAppearance` / `prominentButtonAppearance` 两项自身属性）、
>   `UITabBarItemAppearance`、`UIBarButtonItemAppearance` —— 父类方法已自动继承，自身属性留待后续批次。

### 可复用控件（`Sources/Fdy/Components/`）

视觉上要做得小、但要保证 44×44pt 点击热区的按钮，以及需要防止用户连点重复提交的按钮，
都用 `FdyButton`：

```swift
let close = FdyButton(type: .custom)
    .fdy
    .image(UIImage(systemName: "xmark"), for: .normal)
    .expandClickArea(12)              // 向四周各扩展 12pt
    .build()

let submit = FdyButton(type: .custom)
    .fdy
    .title("提交", for: .normal)
    .repeatClickInterval(0.5)         // 0.5s 内的重复触发只放行第一次
    .build()

// 也可以直接赋值（<= 0 表示不生效）
close.fdy_expandSize = 12
submit.fdy_repeatClickInterval = 0.5

// 三个构造入口都可用
let a = FdyButton(frame: .zero)           // 直接指定 frame
let b = FdyButton(type: .custom)          // UIButton 便利构造
let c = FdyButton.button()                // 类工厂方法
```

> `FdyButton` 与 `FdyTextView` 的组件约定一致：`init(frame:)` 公开、`init?(coder:)` 可用（支持 Storyboard）、
> 都接入 `FdySetupable`（成员有空默认实现，子类按需重写 `setupUI()` / `bindEvents()`，两个初始化器都会调用）。

> - 两项能力都实现在 `FdyButton` 自身：热区走 `point(inside:with:)`，防重复走 `sendAction` 的两个重载。
>   **只对该类及其子类生效，不污染其它 `UIButton`。**
> - 防重复点击**按业务动作分别计时**（键为 selector 名 / `UIAction.identifier`），
>   因此「`.touchDown` 做按压反馈 + `.touchUpInside` 做业务」不会互相挤占时间窗；
>   通过 `addAction(UIAction)` 注册的回调同样受保护。
> - 命中时间窗时**不改动 `isEnabled` 或任何视觉状态**，只是不派发该次动作。
> - 历史版本通过 `UIButton` 扩展注入 `point(inside:with:)` 实现全局热区扩展
>   （`fdy.expandClickArea(_:)` / `fdy_expandClickArea(_:)`），**该入口已移除** ——
>   它会作用于所有 `UIButton`（含 UIKit 内部按钮），且一旦某个子类重写了 `point(inside:with:)` 就会静默失效。
>   原调用点会拿到编译错误：`requires that 'UIButton' inherit from 'FdyButton'`。
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
UITableView.fdy.do { _ in /* $0 是 UIViewController.Type 元类型，用于配置静态/类属性 */ }
```

---

## 扩展方法（`Sources/Fdy/Extensions/`）

按系统框架与领域组织，均带 `fdy_` 前缀，直接作用于原生类型（无需 `.fdy`）：

### UIKit

```swift
UIColor(fdy_hex: "#FF5722")             // 3/4/6/8 位 hex（非可选）
UIColor(fdy_argbHex: "#80FF5722")       // ARGB（含透明度，可选）
color.fdy_alpha(0.5)                    // 透明度
UIColor.fdy_random                      // 随机色

let view = UIView()
view.fdy_removeAllSubviews()            // 移除所有子视图
view.fdy_hideKeyboard()                 // 收起键盘
view.fdy_viewController                 // 最近的父控制器
view.fdy_allSubviews                    // 递归所有子视图
view.fdy_findSubview(ofType: MyView.self)
view.fdy_captureScreenshot()            // 截图

label.fdy_viewSize()                    // 标题尺寸，默认不折行（.greatestFiniteMagnitude）
button.fdy_viewSize()                   // 同上
button.fdy_viewSize(maxWidth: FdyScreen.screenWidth)   // 按屏宽折行时显式传入

UIFont.fdy_font(with: "PingFang SC", size: 16)   // 指定字族，字族不可用时回退系统字体
UIFont.fdy_showAllFonts()                        // 控制台打印设备全部可用字体
```

### Foundation

```swift
object.fdy_className                    // "MyViewController"（实例）
MyClass.fdy_className                   // "MyClass"（类型）
Bundle.fdy_appVersion                   // 版本号（类型属性）
date.fdy_adding(days: 7)                // 日期运算（返回 Date?）
data.fdy_bytes()                        // Data → [UInt8]
url.fdy_appendParameters([...])         // URL 追加参数
```

### Protocols / Stdlib

```swift
[1, 2, 3].fdy_average                   // 平均值
array.fdy_safe(at: 100)                 // 安全下标，越界返回 nil
var numbers = [1, 2, 2, 3]
numbers.fdy_removeDuplicates()          // 去重（原地修改，保持顺序）
Character("a").fdy_uppercase()          // 字符转大写

model.fdy_encode()                      // Codable → Data?
model.fdy_toJSONString()                // Codable → JSON 字符串
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

## 全局工具入口 `fdyG`

所有工具类通过全局 `fdyG` 变量（`FdyGlobal` 的全局实例）统一访问，无需记住每个类的 `shared`：

```swift
fdyG.logger.debug("hello")
fdyG.helper.isPad                   // -> Bool
fdyG.perChecker.request(.camera) { result in ... }
fdyG.queue.asyncMain { ... }
fdyG.screen.width                   // -> CGFloat（须主线程）
fdyG.symbol.monochrome(for: "star", color: .red)
fdyG.path.documentsDirPath
fdyG.haptic.mediumImpact()          // 须主线程
fdyG.appearance.initGlobalUI()      // 启动时一次性默认样式（须主线程）
fdyG.skinManager.updateSkin()       // 运行期主题切换广播（须主线程）
fdyG.plist.read(from: url)
fdyG.screenCaptureMonitor.start(onScreenshot: { ... }, onRecordingStart: nil, onRecordingStop: nil)   // 须主线程
```

> `screen` / `appearance` / `skinManager` / `screenCaptureMonitor` / `haptic` 五个入口标了 `@MainActor`，
> 须在主线程调用；其余入口（`logger` / `helper` / `perChecker` / `queue` / `path` / `plist` / `symbol` / `dataStore`）线程无关。

> `fdyG` 聚合了下表所有带入口的成员。入选标准：**有状态的管理器 / 工具类**统一收进来，
> 调用侧不必再记 `FdyXxx.shared`；纯静态工具（`FdyFactory` / `FdyViewBuilder`）与值类型
> （`FdyTuple*` / `@FdyDataStore`）不设入口。
> 注意与 `.fdy` 命名空间区分：`fdyG` 是**工具类聚合入口**，`object.fdy` 是**链式配置入口**。

## 工具类（`Sources/Fdy/Common/`）

| 类 | `fdyG` 入口 | 功能 |
|----|-----------|------|
| `FdyScreen` | `fdyG.screen` | 屏幕尺寸、安全区、状态栏/导航栏/标签栏高度、设计稿适配 |
| `FdyHelper` | `fdyG.helper` | 设备信息（IDFV/IDFA/机型/系统版本/越狱检测等） |
| `FdyPath` | `fdyG.path` | 沙盒路径与文件操作 |
| `FdyQueue` | `fdyG.queue` | 异步调度、防抖、定时器、一次性执行、串行/并发队列 |
| `FdyHaptic` | `fdyG.haptic` | 触觉反馈 |
| `FdyPermissionChecker` | `fdyG.perChecker` | 权限状态查询与请求 |
| `FdySymbol` | `fdyG.symbol` | SF Symbol 便捷创建（单色/分层/调色板/多色） |
| `FdyAppearance` | `fdyG.appearance` | **启动时一次性**全局 UI 默认样式（走 `UIAppearance` 代理） |
| `FdySkinManager` | `fdyG.skinManager` | **运行期**主题切换广播（配合 `FdySkinable`） |
| `FdyScreenCaptureMonitor` | `fdyG.screenCaptureMonitor` | 录屏/投屏检测 |
| `FdyPlist` | `fdyG.plist` | plist 读写 |
| `FdyViewBuilder` | — | `@resultBuilder` 声明式子视图组装（`UIView { ... }`） |
| `FdyFactory.swift` | — | UIKit 类型的**类工厂方法**（见下） |
| `FdyTuples.swift` | — | 元组容器 `FdyTuple2` ～ `FdyTuple5` |
| `FdyDataStore.swift` | — | `@FdyDataStore` 属性包装（`UserDefaults` 存储） |

### 类工厂方法（`FdyFactory.swift`）

以 `@objc extension` 形式挂在各 UIKit 类型上，直接当类方法调用：

```swift
UIView.view()
UIStackView.hStackView() / .vStackView()
UITableView.tableView(.grouped)
UICollectionView.collectionView(scrollDirection: .vertical)
UIButton.button() / .plain() / .tinted() / .gray() / .filled()
       / .borderless() / .bordered() / .borderedTinted() / .borderedProminent()
UIButton.glass() / .prominentGlass() / .clearGlass() / .prominentClearGlass()   // iOS 26+
UISwitch.switch() / UIBarButtonItem.barButtonItem() / UIDatePicker.datePicker()
```

> `UIButton.plain()` / `.filled()` 等返回的按钮**自带 `UIButton.Configuration`**，
> 后续用 `.fdy.configuration(_:)` 换配置，或先构造配置再赋值。
> 4 个 `glass` 变体标了 `@available(iOS 26.0, *)`，低版本调用需自行做可用性判断。

### 屏幕与适配

```swift
FdyScreen.setupSketch(size: CGSize(width: 375, height: 812))  // 设设计稿

16.fitWidth          // 按设计稿宽度等比缩放（Int / CGFloat 均支持）
20.fitHeight         // 按设计稿高度等比缩放
12.fitLarger         // 宽高取较大
8.fitSmaller         // 宽高取较小

fdyG.screen.width / height / scale
fdyG.screen.safeAreaTop / safeAreaBottom
fdyG.screen.statusBarHeight
fdyG.screen.navBarTotalHeight        // 状态栏 + 导航栏
fdyG.screen.tabBarTotalHeight        // 标签栏 + 底部安全区
fdyG.screen.isCaptured               // 是否录屏/投屏
```

### 设备信息

```swift
fdyG.helper.isSimulator
fdyG.helper.isDebug
fdyG.helper.isPad / isPhone
fdyG.helper.isIPhoneXSeries
fdyG.helper.isJailbroken
fdyG.helper.identifierForVendor   // IDFV
fdyG.helper.advertisingIdentifier // IDFA（需授权）
fdyG.helper.systemVersion
fdyG.helper.className(Self.self)
```

### 队列与定时器

```swift
let debouncedSearch = fdyG.queue.debounced(delay: 0.3) { performSearch() }
// 返回的是普通闭包，需自行在事件回调里调用（此处以文本框的 publisher 为例）：
// textField.fdy_textPublisher.sink { _ in debouncedSearch() }.store(in: &cancellables)

fdyG.queue.executeSerially([task1, task2]) { print("完成") }
fdyG.queue.executeConcurrently([...]) { print("完成") }
fdyG.queue.executeOnce(token: "app.init") { setupAnalytics() }
fdyG.queue.countdownTimer(every: 1.0, times: 5) { _, remaining in }
fdyG.queue.delayed(1.0) { ... }
```

### 沙盒路径

```swift
fdyG.path.documentsDirPath
fdyG.path.cachesDirPath
fdyG.path.path(inCaches: "a.txt")      // 或 inDocuments / inLibrary / inApplicationSupport / inTemp
fdyG.path.exists(at: path)
fdyG.path.createFile(at: path)
fdyG.path.remove(at: path)
```

### 触觉反馈

`FdyHaptic` 标注为 `@MainActor`，需要在主线程调用。

```swift
fdyG.haptic.lightImpact()
fdyG.haptic.mediumImpact()
fdyG.haptic.heavyImpact()
fdyG.haptic.rigidImpact()
fdyG.haptic.softImpact()
fdyG.haptic.selectionChanged()
fdyG.haptic.notification(.success)
fdyG.haptic.haptic(.impact(.medium))   // 自定义：.impact(_:) / .selectionChanged / .notification(_:)
```

### 权限管理

```swift
fdyG.perChecker.checkStatus(for: .camera)   // 查询状态
fdyG.perChecker.request(.photoLibrary) { result in
    switch result {
    case .authorized:     loadPhotos()
    case .denied:         showSettingsAlert()
    }
}
// 便捷方法：checkCamera / requestCamera / checkMicrophone / requestLocation ...
```

### SF Symbol

```swift
fdyG.symbol.monochrome(for: "star.fill", color: .red)
fdyG.symbol.hierarchical(for: "star.fill", hierarchicalColor: .yellow)
fdyG.symbol.palette(for: "star.fill", paletteColors: [.yellow, .orange])
fdyG.symbol.multicolor(for: "star.fill")
```

### 声明式视图构建（`@FdyViewBuilder`）

```swift
let container = UIView {
    UILabel()
    UIButton(type: .system)
} configure: {
    $0.backgroundColor = .systemBackground
}
```

> `UIView { ... }` 会把子视图加入容器并默认关闭 `translatesAutoresizingMaskIntoConstraints`。
> - **只能平铺子视图**：`buildBlock` 是可变参数版本（`UIView...`），因此 `if` / `for` / `if-else` 分支
>   以及 `cond ? view : nil` 都**不支持** —— 需要条件插入时请自行拼数组后循环 `addSubview`。

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

UIKit 事件封装为 Combine `Publisher`/`FdyControlProperty`，可用 `sink` 订阅、`assign`/`bind` 写回：

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
button.fdy_tapPublisher               // FdyControlEvent<Void>
control.fdy_valueChangedPublisher

// 手势
view.fdy_tapGesturePublisher()                   // 单击
view.fdy_tapGesturePublisher(numberOfTaps: 2)    // 双击
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
scrollView.fdy_didEndDraggingWithDecelerationPublisher   // FdyControlEvent<Bool>，载荷为 willDecelerate
scrollView.fdy_didEndDeceleratingPublisher
scrollView.fdy_contentOffsetPublisher                    // FdyControlProperty<CGPoint>
```

双向绑定：

```swift
// 订阅
textField.fdy_textPublisher
    .sink { print("text: \($0 ?? "")") }
    .store(in: &cancellables)

// 写回 / 绑定
// bind(from:) 形参是泛型 `P: Publisher where P.Output == Value, P.Failure == Never`，
// Published / Subject / FdyControlEvent / map·filter 中间流都可**直传**，无需 .eraseToAnyPublisher()
label.fdy_textPublisher.bind(from: viewModel.$title)

// 库自有事件流直接喂给属性流（Output 都是 Bool），连 map 都不用
toggleSwitch.fdy_isOnPublisher.bind(from: scrollView.fdy_didEndDraggingWithDecelerationPublisher)
```

### 语义与硬边界

| 项 | 行为 |
| --- | --- |
| `FdyControlProperty` 去重 | **同值不重发**。赋值与用户事件两路合并后走 `removeDuplicates()`，也是双向绑定回声抑制的前提 |
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

// 全局便捷入口
fdyG.logger.info("数据加载完成")
fdyG.logger.error("解析失败")
```

---

## 设计原则

- **不污染原生类型** — 实例方法通过 `.fdy` 命名空间（`FdyWrapper`）隔离，工具类通过全局 `fdyG` 入口访问。
- **链式调用** — Chain setter 返回 `FdyWrapper`，支持连续配置；引用类型可省略 `.build()`。
- **双入口** — 实例 `object.fdy` 与类型 `Type.fdy`（配置静态/类属性）；全局 `fdyG` 聚合工具类。
- **值类型安全** — `.with` 返回副本，不改原值。
- **健壮回退** — 字体字族、资源加载等不可用时优雅回退，不 crash。
- **iOS 18+** — 最低支持版本，Swift 6.0 工具链 + Swift 5 语言模式。

## 目录结构

```
Sources/
└── Fdy/
    ├── Fdy.swift                 # 模块入口（重导出 UIKit / Combine）
    ├── Chain/                    # 链式 API（UIKit/Foundation/QuartzCore/MapKit/WebKit/Stdlib...）
    ├── Combine/                  # UIKit 事件的 Combine 封装（FdyControlEvent / FdyControlProperty）
    ├── Common/                   # 工具类（FdyScreen/FdyHelper/FdyQueue/FdyTuples/@FdyDataStore...）
    ├── Components/               # 可复用控件（FdyButton / FdyTextView）
    ├── Extensions/               # fdy_ 前缀扩展
    │   ├── Stdlib/               # 标准库类型（String/Array/Dictionary/Optional...）
    │   ├── StdlibProtocols/      # 标准库协议（Collection/Sequence/Comparable...）
    │   └── UIKit/ Foundation/ QuartzCore/ CoreGraphics/ ...
    ├── Logger/                   # FdyLogger + 输出目标（OutputDestination/）
    └── Protocols/                # 本库自有协议（FdyExtension/FdyLoadable/FdyReusable/FdySetupable/FdySkinable）
```

> 顶层按**能力**平铺，不再有中间层。`Extensions/StdlibProtocols/` 装的是**标准库协议**的扩展
> （`Collection`/`Sequence`…），与本库自有的 `Protocols/` 不是一回事。

## 协议

- `FdyExtension` — 命名空间协议，所有扩展的基础（`.fdy` 入口）
- `FdyReusable` — 自动生成复用标识符（`fdy_identifier`）
- `FdyLoadable` — 从 XIB/Storyboard 加载
- `FdySetupable` — MVVM 配置生命周期（成员均有空默认实现，按需重写）
- `FdySkinable` — 主题皮肤响应（配合 `FdySkinManager` 做运行期切换）

`FdyExtension` 的 conformance 全库 **33 条**，登记在各类型对应的扩展文件里：

| 类型 | 登记处 | 是否被继承 |
|------|--------|-----------|
| `NSObject` | `Chain/Foundation/NSObject+Chain.swift` | **是** —— 类子类继承，`UIButton`/`UILabel`/`UIView` 等据此拿到 `.fdy` |
| `CGPath` | `Extensions/CoreGraphics/CGPath++.swift` | **是** —— `CGMutablePath` 作为**子类**继承（Core Foundation 类型同样有 Swift 侧继承） |
| `String` | `Extensions/Stdlib/String/String++.swift` | 否（见下方陷阱说明） |
| `UIButton.Configuration` | `Chain/UIKit/UIButton.Configuration+Chain.swift` | 否（Swift 侧是 **struct**） |
| `Date` | `Extensions/Foundation/Date++.swift` | 否 |

其余 28 条均逐一登记、不继承：

| 目录 | 类型 |
|------|------|
| `Extensions/CoreGraphics/` | `CGPoint` `CGSize` `CGRect` `CGVector` `CGAffineTransform` `CGColor` `CGImage` |
| `Extensions/Stdlib/` | `Array` `Dictionary` `Character` `Bool` `Optional` `Range` `ClosedRange` |
| `Extensions/Foundation/` | `Data` `Decimal` `DateComponents` `IndexPath` `Measurement` `NSRange` `URL` `URLRequest` `UUID` |
| `Chain/UIGeometry/` | `UIEdgeInsets` |
| `Chain/UIKit/` | `UIBackgroundConfiguration` `UIListContentConfiguration` `UIContentUnavailableConfiguration` `UIListSeparatorConfiguration`（四者 Swift 侧均为 **struct**，与 `UIButton.Configuration` 同规则，漏登记即 `.fdy` 不可达） |

> ⚠️ **`String` 漏登记不会编译失败，而是类型错误**：`"abc".fdy` 会经 `NSString` 桥接解析成
> `FdyWrapper<NSString>` —— 能编译，但 `.build()` 返回 `NSString`。故必须显式登记。
>
> 结构体漏登记则直接不可达（`has no member 'fdy'`）。
> 本库 `UIEdgeInsets` / `DateComponents` 曾因漏登记，导致 34 个已写好的链式方法对外零可用。
>
> **Core Foundation 类型不必逐条登记** —— 它与类一样有 Swift 侧继承关系：给父类 `CGPath`
> 登记后，子类 `CGMutablePath` 自动继承；重复声明会报
> `conformance of 'CGMutablePath' to protocol 'FdyExtension' was already stated`。
>
> 值类型（`CGPoint` / `CGSize` / `CGRect` / `Array` / `Dictionary` / `Data` 等 23 个）**均已登记**，
> `point.fdy.with { $0.x += 5 }` 可直接用。

## 文档

变更历史见 [`CHANGELOG.md`](CHANGELOG.md)。设计取舍与实测记录为维护者本地文档，不随仓库分发。

## License

Apache 2.0
