import UIKit

// MARK: - 链式方法(配置化)
//
// 本文件收拢所有读写 `base.configuration` 的链式方法,方法名统一 `bc_`(button configuration) 前缀,
// 与传统 `UIControl.State` 系列 API(见 `UIButton+Chain.swift`)在调用点一眼可分:
// `button.fdy.title("A", for: .normal)` 走传统 setter,`button.fdy.bc_title("A")` 走配置。
//
// - Note: 按钮未持有配置时以 `.plain()` 兜底;`FdyFactory.plain()` / `.tinted()` 创建的按钮自带配置。
public extension FdyWrapper where Base: UIButton {
    /// 整体替换按钮的 `UIButton.Configuration`
    /// - Parameter configuration: 新的配置对象,传 `nil` 清除配置
    /// - Returns: `Self`
    @discardableResult
    func bc_configuration(_ configuration: UIButton.Configuration?) -> Self {
        base.configuration = configuration
        return self
    }

    /// 设置按钮标题
    /// - Parameter title: 标题字符串
    /// - Returns: `Self`
    @discardableResult
    func bc_title(_ title: String) -> Self {
        updateConfiguration { $0.title = title }
    }

    /// 设置属性标题
    /// - Parameter attributedTitle: 属性标题
    /// - Returns: `Self`
    @discardableResult
    func bc_attributedTitle(_ attributedTitle: AttributedString?) -> Self {
        updateConfiguration { $0.attributedTitle = attributedTitle }
    }

    /// 设置按钮副标题
    /// - Parameter subtitle: 副标题
    /// - Returns: `Self`
    @discardableResult
    func bc_subtitle(_ subtitle: String) -> Self {
        updateConfiguration { $0.subtitle = subtitle }
    }

    /// 设置属性副标题
    /// - Parameter attributedSubtitle: 属性副标题
    /// - Returns: `Self`
    @discardableResult
    func bc_attributedSubtitle(_ attributedSubtitle: AttributedString?) -> Self {
        updateConfiguration { $0.attributedSubtitle = attributedSubtitle }
    }

    /// 设置图标
    /// - Parameters:
    ///   - image: 图标
    ///   - placement: 位置
    /// - Returns: `Self`
    @discardableResult
    func bc_image(_ image: UIImage?, placement: NSDirectionalRectEdge = .leading) -> Self {
        updateConfiguration {
            $0.image = image
            $0.imagePlacement = placement
        }
    }

    /// 设置背景图片
    /// - Parameter backgroundImage: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func bc_backgroundImage(_ backgroundImage: UIImage?) -> Self {
        updateBackground { $0.image = backgroundImage }
    }

    /// 设置加载状态(自动禁用交互 + 显示指示器)
    ///
    /// - Note: 带 `isUserInteractionEnabled` 交互副作用,未套用 `updateConfiguration`。
    /// - Parameter loading: 是否加载
    /// - Returns: `Self`
    @discardableResult
    func bc_isLoading(_ loading: Bool) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.showsActivityIndicator = loading
        base.configuration = configuration
        base.isUserInteractionEnabled = !loading
        return self
    }

    /// 设置图标间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func bc_imagePadding(_ padding: CGFloat) -> Self {
        updateConfiguration { $0.imagePadding = padding }
    }

    /// 设置标题间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func bc_titlePadding(_ padding: CGFloat) -> Self {
        updateConfiguration { $0.titlePadding = padding }
    }

    /// 设置主背景色(仅对 `.filled` / `.tinted` 有效)
    /// - Parameter color: 背景色
    /// - Returns: `Self`
    @discardableResult
    func bc_baseBackgroundColor(_ color: UIColor?) -> Self {
        updateConfiguration { $0.baseBackgroundColor = color }
    }

    /// 设置主前景色(文字/图标颜色)
    /// - Parameter color: 前景色
    /// - Returns: `Self`
    @discardableResult
    func bc_baseForegroundColor(_ color: UIColor?) -> Self {
        updateConfiguration { $0.baseForegroundColor = color }
    }

    /// 设置图标位置
    /// - Parameter imagePlacement: 图标位置
    /// - Returns: `Self`
    @discardableResult
    func bc_imagePlacement(_ imagePlacement: NSDirectionalRectEdge) -> Self {
        updateConfiguration { $0.imagePlacement = imagePlacement }
    }

    /// 设置内容与边缘间距
    /// - Parameter contentInsets: 间距
    /// - Returns: `Self`
    @discardableResult
    func bc_contentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        updateConfiguration { $0.contentInsets = contentInsets }
    }

    /// 设置圆角风格
    /// - Parameter cornerStyle: 圆角样式
    /// - Returns: `Self`
    @discardableResult
    func bc_cornerStyle(_ cornerStyle: UIButton.Configuration.CornerStyle) -> Self {
        updateConfiguration { $0.cornerStyle = cornerStyle }
    }

    /// 设置边框颜色
    /// - Parameter strokeColor: 边框颜色
    /// - Returns: `Self`
    @discardableResult
    func bc_backgroundStrokeColor(_ strokeColor: UIColor?) -> Self {
        updateBackground { $0.strokeColor = strokeColor }
    }

    /// 设置边框宽度
    /// - Parameter strokeWidth: 边框宽度
    /// - Returns: `Self`
    @discardableResult
    func bc_backgroundStrokeWidth(_ strokeWidth: CGFloat) -> Self {
        updateBackground { $0.strokeWidth = strokeWidth }
    }

    /// 设置图片方向与图文间距
    ///
    /// - Note: 带 `switch` 分支,未套用 `updateConfiguration`。
    /// - Parameters:
    ///   - direction: 图片方向
    ///   - spacing: 间距
    /// - Returns: `Self`
    @discardableResult
    func bc_layoutImage(direction: NSDirectionalRectEdge, spacing: CGFloat) -> Self {
        var config = base.configuration ?? UIButton.Configuration.plain()
        switch direction {
        case .top:
            config.imagePlacement = .top
            config.imagePadding = spacing
        case .bottom:
            config.imagePlacement = .bottom
            config.imagePadding = spacing
        case .leading:
            config.imagePlacement = .leading
            config.imagePadding = spacing
        case .trailing:
            config.imagePlacement = .trailing
            config.imagePadding = spacing
        default:
            break
        }
        base.configuration = config
        return self
    }
}

// MARK: - 配置读写模板收敛
private extension FdyWrapper where Base: UIButton {
    /// 在按钮现有 `UIButton.Configuration` 上做一次原地修改并写回
    ///
    /// 收敛原先 16 处「读取配置 → 改一个属性 → 写回」的四行模板。
    ///
    /// - Note: 按钮尚无配置(非 `FdyFactory.plain()` / `.tinted()` 创建的按钮)时以 `.plain()` 兜底,
    ///   与收敛前各方法的 `?? UIButton.Configuration.plain()` 语义一致。
    /// - Parameter mutate: 接收 `inout` 配置对象的闭包
    /// - Returns: `Self`
    @discardableResult
    @inline(__always)
    func updateConfiguration(_ mutate: (inout UIButton.Configuration) -> Void) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        mutate(&configuration)
        base.configuration = configuration
        return self
    }

    /// 在按钮现有配置的 `background` 上做一次原地修改并写回
    /// - Parameter mutate: 接收 `inout` 背景配置对象的闭包
    /// - Returns: `Self`
    @discardableResult
    @inline(__always)
    func updateBackground(_ mutate: (inout UIBackgroundConfiguration) -> Void) -> Self {
        updateConfiguration { mutate(&$0.background) }
    }
}
