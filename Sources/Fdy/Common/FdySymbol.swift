import UIKit

public final class FdySymbol {
    public static let shared = FdySymbol()
    private init() {}

    /// 创建单色图标
    /// - Returns: `UIImage?`
    public static func monochrome(
        for name: String,
        color: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        let configuration = if let configuration {
            configuration
        } else {
            UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .regular,
                scale: .default
            )
        }

        return UIImage(systemName: name, withConfiguration: configuration)?
            .withTintColor(color).withRenderingMode(.alwaysOriginal)
    }

    /// 创建分层图标
    /// - Returns: `UIImage?`
    public static func hierarchical(
        for name: String,
        hierarchicalColor: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        var configuration = if let configuration {
            configuration
        } else {
            UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .regular,
                scale: .default
            )
        }

        configuration = configuration.applying(
            UIImage.SymbolConfiguration(hierarchicalColor: hierarchicalColor)
        )
        return UIImage(systemName: name, withConfiguration: configuration)
    }

    /// 创建调色板图标
    /// - Returns: `UIImage?`
    public static func palette(
        for name: String,
        paletteColors: [UIColor],
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        var configuration = if let configuration {
            configuration
        } else {
            UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .regular,
                scale: .default
            )
        }

        configuration = configuration.applying(
            UIImage.SymbolConfiguration(paletteColors: paletteColors)
        )
        return UIImage(systemName: name, withConfiguration: configuration)
    }

    /// 创建多色图标(使用 SF Symbol 自带的层级颜色)
    /// - Parameters:
    ///   - name: 图标名称,需为多色符号(如 `"folder"`, `"alarm"`)
    /// - Returns: `UIImage?`
    public static func multicolor(
        for name: String,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        var configuration = if let configuration {
            configuration
        } else {
            UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .regular,
                scale: .default
            )
        }

        configuration = configuration.applying(
            UIImage.SymbolConfiguration.preferringMulticolor()
        )
        return UIImage(systemName: name, withConfiguration: configuration)
    }
}

// MARK: - 实例方法（通过 fdy.symbol 访问）
public extension FdySymbol {
    /// 以单色渲染模式构建符号图片
    func monochrome(for name: String, color: UIColor, configuration: UIImage.SymbolConfiguration? = nil) -> UIImage? {
        Self.monochrome(for: name, color: color, configuration: configuration)
    }

    /// 以层级渲染模式构建符号图片
    func hierarchical(for name: String, hierarchicalColor: UIColor, configuration: UIImage.SymbolConfiguration? = nil) -> UIImage? {
        Self.hierarchical(for: name, hierarchicalColor: hierarchicalColor, configuration: configuration)
    }

    /// 以调色板渲染模式构建符号图片
    func palette(for name: String, paletteColors: [UIColor], configuration: UIImage.SymbolConfiguration? = nil) -> UIImage? {
        Self.palette(for: name, paletteColors: paletteColors, configuration: configuration)
    }

    /// 以多色渲染模式构建符号图片
    func multicolor(for name: String, configuration: UIImage.SymbolConfiguration? = nil) -> UIImage? {
        Self.multicolor(for: name, configuration: configuration)
    }
}
