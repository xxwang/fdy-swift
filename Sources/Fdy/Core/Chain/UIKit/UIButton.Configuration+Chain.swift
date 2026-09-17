import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base == UIButton.Configuration {
    /// 设置按钮在指定状态下的普通文本标题
    /// - Parameters:
    ///   - title: 标题字符串
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String) -> Self {
        updateConfiguration { $0.title = title }
    }

    /// 设置按钮副标题
    /// - Parameter subtitle: 副标题
    /// - Returns: `Self`
    @discardableResult
    func subtitle(_ subtitle: String) -> Self {
        updateConfiguration { $0.subtitle = subtitle }
    }

    /// 设置图标
    /// - Parameters:
    ///   - image: 图标
    ///   - placement: 位置
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?, placement: NSDirectionalRectEdge = .leading) -> Self {
        updateConfiguration {
            $0.image = image
            $0.imagePlacement = placement
        }
    }

    /// 设置背景图片
    /// - Parameter backgroundImage: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> Self {
        updateBackground { $0.image = backgroundImage }
    }

    /// 设置加载状态(自动禁用交互 + 显示指示器)
    /// - Parameter loading: 是否加载
    /// - Returns: `Self`
    @discardableResult
    func isLoading(_ loading: Bool) -> Self {
        updateConfiguration { $0.showsActivityIndicator = loading }
    }

    /// 设置图标间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func imagePadding(_ padding: CGFloat) -> Self {
        updateConfiguration { $0.imagePadding = padding }
    }

    /// 设置标题间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func titlePadding(_ padding: CGFloat) -> Self {
        updateConfiguration { $0.titlePadding = padding }
    }

    /// 设置主背景色(仅对 .filled / .tinted 有效)
    /// - Parameter color: 背景色
    /// - Returns: `Self`
    @discardableResult
    func baseBackgroundColor(_ color: UIColor?) -> Self {
        updateConfiguration { $0.baseBackgroundColor = color }
    }

    /// 设置主前景色(文字/图标颜色(前景色))
    /// - Parameter color: 前景色
    /// - Returns: `Self`
    @discardableResult
    func baseForegroundColor(_ color: UIColor?) -> Self {
        updateConfiguration { $0.baseForegroundColor = color }
    }

    /// 设置属性标题
    /// - Parameter attributedTitle: 属性标题
    /// - Returns: `Self`
    @discardableResult
    func attributedTitle(_ attributedTitle: AttributedString?) -> Self {
        updateConfiguration { $0.attributedTitle = attributedTitle }
    }

    /// 设置属性副标题
    /// - Parameter attributedSubtitle: 属性副标题
    /// - Returns: `Self`
    @discardableResult
    func attributedSubtitle(_ attributedSubtitle: AttributedString?) -> Self {
        updateConfiguration { $0.attributedSubtitle = attributedSubtitle }
    }

    /// 设置图标位置
    /// - Parameter imagePlacement: 图标位置
    /// - Returns: `Self`
    @discardableResult
    func imagePlacement(_ imagePlacement: NSDirectionalRectEdge) -> Self {
        updateConfiguration { $0.imagePlacement = imagePlacement }
    }

    /// 设置内容与边缘间距
    /// - Parameter contentInsets: 间距
    /// - Returns: `Self`
    @discardableResult
    func contentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        updateConfiguration { $0.contentInsets = contentInsets }
    }

    /// 设置圆角风格
    /// - Parameter cornerStyle: 圆角样式
    /// - Returns: `Self`
    @discardableResult
    func cornerStyle(_ cornerStyle: UIButton.Configuration.CornerStyle) -> Self {
        updateConfiguration { $0.cornerStyle = cornerStyle }
    }

    /// 设置边框颜色
    /// - Parameter strokeColor: 边框颜色
    /// - Returns: `Self`
    @discardableResult
    func backgroundStrokeColor(_ strokeColor: UIColor?) -> Self {
        updateBackground { $0.strokeColor = strokeColor }
    }

    /// 设置边框宽度
    /// - Parameter strokeWidth: 边框宽度
    /// - Returns: `Self`
    @discardableResult
    func backgroundStrokeWidth(_ strokeWidth: CGFloat) -> Self {
        updateBackground { $0.strokeWidth = strokeWidth }
    }
}

// MARK: - 配置读写模板收敛
private extension FdyWrapper where Base == UIButton.Configuration {
    /// 在现有配置上做一次原地修改并写回
    ///
    /// 收敛原先 16 处「读取副本 → 改一个属性 → 写回」的四行模板。
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
