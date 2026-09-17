import UIKit

// MARK: - 命名空间入口
//
// `UIButton.Configuration` 在 Swift 侧是 **struct**(ObjC 的 `UIButtonConfiguration` 是 `NSObject` 子类,
// Swift 把它桥接成了值类型),因此**不继承** `extension NSObject: FdyExtension` —— 必须单独补一条 conformance,
// 否则本文件全部链式方法对外不可达(`value of type 'UIButton.Configuration' has no member 'fdy'`)。
extension UIButton.Configuration: FdyExtension {}

// MARK: - 链式设置属性
//
// - Note: 值类型语义 —— `.fdy` 返回的 `FdyWrapper` 持有配置的一份**拷贝**,链式修改不会改动原变量。
//   需要取回结果请以 `build()` 收尾:
//   ```swift
//   let configuration = UIButton.Configuration.plain().fdy.title("确定").cornerStyle(.capsule).build()
//   ```
public extension FdyWrapper where Base == UIButton.Configuration {
    // MARK: 文本

    /// 设置标题
    /// - Parameter title: 标题字符串
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String) -> Self {
        updateConfiguration { $0.title = title }
    }

    /// 设置属性标题
    /// - Parameter attributedTitle: 属性标题
    /// - Returns: `Self`
    @discardableResult
    func attributedTitle(_ attributedTitle: AttributedString?) -> Self {
        updateConfiguration { $0.attributedTitle = attributedTitle }
    }

    /// 设置副标题
    /// - Parameter subtitle: 副标题
    /// - Returns: `Self`
    @discardableResult
    func subtitle(_ subtitle: String) -> Self {
        updateConfiguration { $0.subtitle = subtitle }
    }

    /// 设置属性副标题
    /// - Parameter attributedSubtitle: 属性副标题
    /// - Returns: `Self`
    @discardableResult
    func attributedSubtitle(_ attributedSubtitle: AttributedString?) -> Self {
        updateConfiguration { $0.attributedSubtitle = attributedSubtitle }
    }

    /// 设置标题与副标题的间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func titlePadding(_ padding: CGFloat) -> Self {
        updateConfiguration { $0.titlePadding = padding }
    }

    /// 设置标题换行模式
    ///
    /// - Note: 默认 `.byWordWrapping`。仅 `.byWordWrapping` / `.byCharWrapping` 允许标题多行,其余模式会限制为单行。
    /// - Parameter titleLineBreakMode: 换行模式
    /// - Returns: `Self`
    @discardableResult
    func titleLineBreakMode(_ titleLineBreakMode: NSLineBreakMode) -> Self {
        updateConfiguration { $0.titleLineBreakMode = titleLineBreakMode }
    }

    /// 设置副标题换行模式
    ///
    /// - Note: 默认 `.byWordWrapping`。仅 `.byWordWrapping` / `.byCharWrapping` 允许副标题多行,其余模式会限制为单行。
    /// - Parameter subtitleLineBreakMode: 换行模式
    /// - Returns: `Self`
    @discardableResult
    func subtitleLineBreakMode(_ subtitleLineBreakMode: NSLineBreakMode) -> Self {
        updateConfiguration { $0.subtitleLineBreakMode = subtitleLineBreakMode }
    }

    /// 设置标题与副标题的对齐方式
    /// - Parameter titleAlignment: 对齐方式
    /// - Returns: `Self`
    @discardableResult
    func titleAlignment(_ titleAlignment: UIButton.Configuration.TitleAlignment) -> Self {
        updateConfiguration { $0.titleAlignment = titleAlignment }
    }

    /// 设置标题文本属性变换器(逐次派生标题的富文本属性)
    /// - Parameter titleTextAttributesTransformer: 变换器,传 `nil` 取消变换
    /// - Returns: `Self`
    @discardableResult
    func titleTextAttributesTransformer(
        _ titleTextAttributesTransformer: UIConfigurationTextAttributesTransformer?
    ) -> Self {
        updateConfiguration { $0.titleTextAttributesTransformer = titleTextAttributesTransformer }
    }

    /// 设置副标题文本属性变换器
    /// - Parameter subtitleTextAttributesTransformer: 变换器,传 `nil` 取消变换
    /// - Returns: `Self`
    @discardableResult
    func subtitleTextAttributesTransformer(
        _ subtitleTextAttributesTransformer: UIConfigurationTextAttributesTransformer?
    ) -> Self {
        updateConfiguration { $0.subtitleTextAttributesTransformer = subtitleTextAttributesTransformer }
    }

    // MARK: 图标

    /// 设置图标
    /// - Parameters:
    ///   - image: 图标
    ///   - placement: 位置,默认 `.leading`
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?, placement: NSDirectionalRectEdge = .leading) -> Self {
        updateConfiguration {
            $0.image = image
            $0.imagePlacement = placement
        }
    }

    /// 设置图标位置
    /// - Parameter imagePlacement: 图标位置
    /// - Returns: `Self`
    @discardableResult
    func imagePlacement(_ imagePlacement: NSDirectionalRectEdge) -> Self {
        updateConfiguration { $0.imagePlacement = imagePlacement }
    }

    /// 设置图标与标题的间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func imagePadding(_ padding: CGFloat) -> Self {
        updateConfiguration { $0.imagePadding = padding }
    }

    /// 设置图标的符号配置(仅 SF Symbol 生效)
    /// - Parameter preferredSymbolConfigurationForImage: 符号配置,传 `nil` 用默认
    /// - Returns: `Self`
    @discardableResult
    func preferredSymbolConfigurationForImage(
        _ preferredSymbolConfigurationForImage: UIImage.SymbolConfiguration?
    ) -> Self {
        updateConfiguration { $0.preferredSymbolConfigurationForImage = preferredSymbolConfigurationForImage }
    }

    /// 设置图标颜色变换器(在 `baseForegroundColor` 之后应用)
    ///
    /// - Note: 图标要被 `baseForegroundColor` 染色需为 `.alwaysTemplate`;`.alwaysOriginal` 保持原色。
    /// - Parameter imageColorTransformer: 变换器,传 `nil` 取消变换
    /// - Returns: `Self`
    @discardableResult
    func imageColorTransformer(_ imageColorTransformer: UIConfigurationColorTransformer?) -> Self {
        updateConfiguration { $0.imageColorTransformer = imageColorTransformer }
    }

    /// 设置符号内容过渡动画(跨 SF Symbol 切换时生效)
    /// - Parameter symbolContentTransition: 过渡配置,传 `nil` 表示不做过渡
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func symbolContentTransition(_ symbolContentTransition: UISymbolContentTransition?) -> Self {
        updateConfiguration { $0.symbolContentTransition = symbolContentTransition }
    }

    // MARK: 加载与指示器

    /// 设置加载状态(显示/隐藏活动指示器)
    ///
    /// - Note: 只改 `showsActivityIndicator`,**不**动 `isUserInteractionEnabled` ——
    ///   这里操作的是值类型的配置,改不到按钮的交互开关。「加载中禁止点击」请在按钮侧自行设置。
    /// - Parameter loading: 是否加载
    /// - Returns: `Self`
    @discardableResult
    func isLoading(_ loading: Bool) -> Self {
        updateConfiguration { $0.showsActivityIndicator = loading }
    }

    /// 设置活动指示器颜色变换器
    /// - Parameter activityIndicatorColorTransformer: 变换器,传 `nil` 取消变换
    /// - Returns: `Self`
    @discardableResult
    func activityIndicatorColorTransformer(
        _ activityIndicatorColorTransformer: UIConfigurationColorTransformer?
    ) -> Self {
        updateConfiguration { $0.activityIndicatorColorTransformer = activityIndicatorColorTransformer }
    }

    /// 设置按钮尾部的指示器类型
    /// - Parameter indicator: 指示器类型,默认 `.automatic`
    /// - Returns: `Self`
    @discardableResult
    func indicator(_ indicator: UIButton.Configuration.Indicator) -> Self {
        updateConfiguration { $0.indicator = indicator }
    }

    /// 设置指示器颜色变换器
    /// - Parameter indicatorColorTransformer: 变换器,传 `nil` 取消变换
    /// - Returns: `Self`
    @discardableResult
    func indicatorColorTransformer(_ indicatorColorTransformer: UIConfigurationColorTransformer?) -> Self {
        updateConfiguration { $0.indicatorColorTransformer = indicatorColorTransformer }
    }

    // MARK: 颜色与尺寸

    /// 设置主背景色(仅对 `.filled` / `.tinted` 有效)
    /// - Parameter color: 背景色,传 `nil` 交回系统按风格决定
    /// - Returns: `Self`
    @discardableResult
    func baseBackgroundColor(_ color: UIColor?) -> Self {
        updateConfiguration { $0.baseBackgroundColor = color }
    }

    /// 设置主前景色(文字/图标颜色)
    ///
    /// - Note: 施加于 `baseForegroundColor` 之前会先经过各自的颜色变换器,再落到具体元素。
    /// - Parameter color: 前景色,传 `nil` 交回系统按风格决定
    /// - Returns: `Self`
    @discardableResult
    func baseForegroundColor(_ color: UIColor?) -> Self {
        updateConfiguration { $0.baseForegroundColor = color }
    }

    /// 设置圆角风格
    ///
    /// - Note: 决定 `background.cornerRadius` 如何被解读 —— 除 `.fixed` / `.dynamic` 外,
    ///   其余风格都会忽略该圆角值,改用系统给定值。
    /// - Parameter cornerStyle: 圆角样式
    /// - Returns: `Self`
    @discardableResult
    func cornerStyle(_ cornerStyle: UIButton.Configuration.CornerStyle) -> Self {
        updateConfiguration { $0.cornerStyle = cornerStyle }
    }

    /// 设置按钮尺寸(决定内边距与理想尺寸)
    /// - Parameter buttonSize: 尺寸档位
    /// - Returns: `Self`
    @discardableResult
    func buttonSize(_ buttonSize: UIButton.Configuration.Size) -> Self {
        updateConfiguration { $0.buttonSize = buttonSize }
    }

    /// 设置 Mac 习惯下的按钮风格
    /// - Parameter macIdiomStyle: Mac 风格
    /// - Returns: `Self`
    @discardableResult
    func macIdiomStyle(_ macIdiomStyle: UIButton.Configuration.MacIdiomStyle) -> Self {
        updateConfiguration { $0.macIdiomStyle = macIdiomStyle }
    }

    /// 设置选中态是否自动更新外观
    ///
    /// - Note: 默认值随风格而异。关闭后 `isSelected` 不再自动改变外观,便于自定义选中态。
    /// - Parameter automaticallyUpdateForSelection: 是否自动更新
    /// - Returns: `Self`
    @discardableResult
    func automaticallyUpdateForSelection(_ automaticallyUpdateForSelection: Bool) -> Self {
        updateConfiguration { $0.automaticallyUpdateForSelection = automaticallyUpdateForSelection }
    }

    // MARK: 布局

    /// 设置内容与边缘的间距
    /// - Parameter contentInsets: 间距
    /// - Returns: `Self`
    @discardableResult
    func contentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        updateConfiguration { $0.contentInsets = contentInsets }
    }

    /// 恢复内容间距为当前风格的默认值
    /// - Returns: `Self`
    @discardableResult
    func defaultContentInsets() -> Self {
        updateConfiguration { $0.setDefaultContentInsets() }
    }

    // MARK: 背景

    /// 设置背景图片
    /// - Parameter backgroundImage: 背景图片,传 `nil` 清除
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> Self {
        updateBackground { $0.image = backgroundImage }
    }

    /// 设置背景图片的内容模式
    /// - Parameter backgroundImageContentMode: 内容模式
    /// - Returns: `Self`
    @discardableResult
    func backgroundImageContentMode(_ backgroundImageContentMode: UIView.ContentMode) -> Self {
        updateBackground { $0.imageContentMode = backgroundImageContentMode }
    }

    /// 设置背景色
    ///
    /// - Note: 与 `baseBackgroundColor`(仅 `.filled` / `.tinted` 生效)不同,
    ///   此色直落背景图层,任意风格都可见。
    /// - Parameter backgroundColor: 背景色,传 `nil` 清除
    /// - Returns: `Self`
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        updateBackground { $0.backgroundColor = backgroundColor }
    }

    /// 设置背景色变换器
    /// - Parameter backgroundColorTransformer: 变换器,传 `nil` 取消变换
    /// - Returns: `Self`
    @discardableResult
    func backgroundColorTransformer(_ backgroundColorTransformer: UIConfigurationColorTransformer?) -> Self {
        updateBackground { $0.backgroundColorTransformer = backgroundColorTransformer }
    }

    /// 设置背景圆角半径
    ///
    /// - Note: 实际是否采用取决于 `cornerStyle` —— 仅 `.fixed` / `.dynamic` 会直接使用该值。
    /// - Parameter backgroundCornerRadius: 圆角半径
    /// - Returns: `Self`
    @discardableResult
    func backgroundCornerRadius(_ backgroundCornerRadius: CGFloat) -> Self {
        updateBackground { $0.cornerRadius = backgroundCornerRadius }
    }

    /// 设置背景相对按钮边界的内缩
    /// - Parameter backgroundInsets: 内缩量
    /// - Returns: `Self`
    @discardableResult
    func backgroundInsets(_ backgroundInsets: NSDirectionalEdgeInsets) -> Self {
        updateBackground { $0.backgroundInsets = backgroundInsets }
    }

    /// 设置哪些边在计算背景内缩时额外加上布局边距
    ///
    /// - Note: 对应 `UIBackgroundConfiguration.edgesAddingLayoutMarginsToBackgroundInsets`。
    /// - Parameter backgroundMarginEdges: 需要附加布局边距的边
    /// - Returns: `Self`
    @discardableResult
    func backgroundMarginEdges(_ backgroundMarginEdges: NSDirectionalRectEdge) -> Self {
        updateBackground { $0.edgesAddingLayoutMarginsToBackgroundInsets = backgroundMarginEdges }
    }

    /// 设置背景边框颜色
    /// - Parameter strokeColor: 边框颜色,传 `nil` 清除
    /// - Returns: `Self`
    @discardableResult
    func backgroundStrokeColor(_ strokeColor: UIColor?) -> Self {
        updateBackground { $0.strokeColor = strokeColor }
    }

    /// 设置背景边框颜色变换器
    /// - Parameter backgroundStrokeColorTransformer: 变换器,传 `nil` 取消变换
    /// - Returns: `Self`
    @discardableResult
    func backgroundStrokeColorTransformer(
        _ backgroundStrokeColorTransformer: UIConfigurationColorTransformer?
    ) -> Self {
        updateBackground { $0.strokeColorTransformer = backgroundStrokeColorTransformer }
    }

    /// 设置背景边框宽度
    /// - Parameter strokeWidth: 边框宽度
    /// - Returns: `Self`
    @discardableResult
    func backgroundStrokeWidth(_ strokeWidth: CGFloat) -> Self {
        updateBackground { $0.strokeWidth = strokeWidth }
    }

    /// 设置背景边框向外扩张的距离
    /// - Parameter backgroundStrokeOutset: 扩张距离,负值向内
    /// - Returns: `Self`
    @discardableResult
    func backgroundStrokeOutset(_ backgroundStrokeOutset: CGFloat) -> Self {
        updateBackground { $0.strokeOutset = backgroundStrokeOutset }
    }

    /// 设置背景视觉特效(如模糊)
    ///
    /// - Note: 与 `backgroundColor` 互斥 —— 设置了 `visualEffect` 会忽略背景色。
    /// - Parameter backgroundVisualEffect: 视觉效果,传 `nil` 清除
    /// - Returns: `Self`
    @discardableResult
    func backgroundVisualEffect(_ backgroundVisualEffect: UIVisualEffect?) -> Self {
        updateBackground { $0.visualEffect = backgroundVisualEffect }
    }

    /// 设置自定义背景视图
    /// - Parameter backgroundCustomView: 自定义视图,传 `nil` 清除
    /// - Returns: `Self`
    @discardableResult
    func backgroundCustomView(_ backgroundCustomView: UIView?) -> Self {
        updateBackground { $0.customView = backgroundCustomView }
    }
}

// MARK: - 配置读写模板收敛
private extension FdyWrapper where Base == UIButton.Configuration {
    /// 在现有配置上做一次原地修改并写回
    ///
    /// 收敛各处「读取副本 → 改一个属性 → 写回」的四行模板。
    ///
    /// - Parameter mutate: 接收 `inout` 配置对象的闭包
    /// - Returns: `Self`
    @discardableResult
    @inline(__always)
    func updateConfiguration(_ mutate: (inout UIButton.Configuration) -> Void) -> Self {
        var configuration = base
        mutate(&configuration)
        base = configuration
        return self
    }

    /// 在现有配置的 `background` 上做一次原地修改并写回
    /// - Parameter mutate: 接收 `inout` 背景配置对象的闭包
    /// - Returns: `Self`
    @discardableResult
    @inline(__always)
    func updateBackground(_ mutate: (inout UIBackgroundConfiguration) -> Void) -> Self {
        updateConfiguration { mutate(&$0.background) }
    }
}
