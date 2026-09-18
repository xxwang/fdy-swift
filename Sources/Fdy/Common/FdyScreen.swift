import UIKit

/// 屏幕尺寸信息。读取 `UIApplication` / `UIScreen`，必须在主线程使用，因此标注为 ``@MainActor``
@MainActor
public final class FdyScreen {
    public static let shared = FdyScreen()
    private init() {}

    /// 设计稿参考尺寸
    public private(set) static var sketchSize: CGSize = .init(width: 375, height: 812)

    /// 配置设计稿尺寸,用于后续的自动适配计算
    /// - Parameter size: 设计稿的逻辑尺寸(单位：`pt`)
    public static func setupSketch(size: CGSize) {
        sketchSize = size
    }
}

// MARK: - 屏幕基础几何信息
public extension FdyScreen {
    /// 当前主屏幕的边界,会随设备旋转动态变化
    static var screenBounds: CGRect {
        let scene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        return scene?.screen.bounds ?? UIScreen.main.bounds
    }

    /// 当前屏幕尺寸
    static var screenSize: CGSize {
        screenBounds.size
    }

    /// 屏幕宽度
    static var screenWidth: CGFloat {
        screenBounds.width
    }

    /// 屏幕高度
    static var screenHeight: CGFloat {
        screenBounds.height
    }

    /// 屏幕缩放
    static var screenScale: CGFloat {
        let scene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        return scene?.screen.scale ?? UIScreen.main.scale
    }
}

// MARK: - 安全区域(Safe Area)信息
public extension FdyScreen {
    /// 当前 `keyWindow` 的安全区域插值
    static var safeAreaInsets: UIEdgeInsets {
        return UIWindow.fdy_keyWindow?.safeAreaInsets ?? .zero
    }

    /// 安全区顶部高度(通常为状态栏 + 导航栏下方留白)
    static var safeAreaTop: CGFloat {
        safeAreaInsets.top
    }

    /// 安全区底部高度(通常为 `Home Indicator `或底部留白)
    static var safeAreaBottom: CGFloat {
        safeAreaInsets.bottom
    }

    /// 安全区左侧宽度
    static var safeAreaLeft: CGFloat {
        safeAreaInsets.left
    }

    /// 安全区右侧宽度
    static var safeAreaRight: CGFloat {
        safeAreaInsets.right
    }
}

// MARK: - 状态栏与导航栏高度
public extension FdyScreen {
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        UIWindow.fdy_keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }

    /// 导航栏高度
    static let navigationBarHeight: CGFloat = 44

    /// 导航栏总高度 = 状态栏 + 导航栏
    static var navBarTotalHeight: CGFloat {
        statusBarHeight + navigationBarHeight
    }
}

// MARK: - 标签栏(TabBar)高度
public extension FdyScreen {
    /// 标签栏高度
    static let tabBarHeight: CGFloat = 49

    /// 标签栏总高度 = 标签栏 + 底部安全区
    static var tabBarTotalHeight: CGFloat {
        tabBarHeight + safeAreaBottom
    }
}

// MARK: - 适配比例计算(基于设计稿)
public extension FdyScreen {
    /// 适配比例：横屏取长边比、竖屏取短边比
    /// - Note: 供 `fitWidth` / `fitLarger` / `fitSmaller` 等扩展使用。如需严格按当前宽度缩放，请用 `screenWidth / sketchSize.width`。
    static var adaptiveRatio: CGFloat {
        // 一次性取屏幕宽高，避免在布局热路径上多次遍历 connectedScenes
        let screenW = self.screenWidth
        let screenH = self.screenHeight
        let isLandscape = screenW > screenH
        let sketch = sketchSize

        if isLandscape {
            let sketchLongSide = max(sketch.width, sketch.height)
            return max(screenW, screenH) / sketchLongSide
        } else {
            let sketchShortSide = min(sketch.width, sketch.height)
            return min(screenW, screenH) / sketchShortSide
        }
    }

    /// 高度方向的缩放比例
    static var heightRatio: CGFloat {
        let screenW = self.screenWidth
        let screenH = self.screenHeight
        let isLandscape = screenW > screenH
        let sketch = sketchSize

        if isLandscape {
            let sketchShortSide = min(sketch.width, sketch.height)
            return min(screenW, screenH) / sketchShortSide
        } else {
            let sketchLongSide = max(sketch.width, sketch.height)
            return max(screenW, screenH) / sketchLongSide
        }
    }
}

// MARK: - 屏幕捕获检测
public extension FdyScreen {
    /// 当前是否正在录屏或投屏
    static var isCaptured: Bool {
        let scene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        return scene?.screen.isCaptured ?? false
    }
}

// MARK: - 实例属性（通过 fdy.screen 访问）
public extension FdyScreen {
    var bounds: CGRect {
        Self.screenBounds
    }

    var size: CGSize {
        Self.screenSize
    }

    var width: CGFloat {
        Self.screenWidth
    }

    var height: CGFloat {
        Self.screenHeight
    }

    var scale: CGFloat {
        Self.screenScale
    }

    var safeArea: UIEdgeInsets {
        Self.safeAreaInsets
    }

    var safeAreaTop: CGFloat {
        Self.safeAreaTop
    }

    var safeAreaBottom: CGFloat {
        Self.safeAreaBottom
    }

    var safeAreaLeft: CGFloat {
        Self.safeAreaLeft
    }

    var safeAreaRight: CGFloat {
        Self.safeAreaRight
    }

    var statusBarHeight: CGFloat {
        Self.statusBarHeight
    }

    var navBarTotalHeight: CGFloat {
        Self.navBarTotalHeight
    }

    var tabBarTotalHeight: CGFloat {
        Self.tabBarTotalHeight
    }

    var isCaptured: Bool {
        Self.isCaptured
    }

    func setupSketch(size: CGSize) {
        Self.setupSketch(size: size)
    }
}

// MARK: - 内部适配计算方法
private extension FdyScreen {
    /// 根据设计图宽度计算适配后的宽度
    static func calcWidth(from value: CGFloat) -> CGFloat {
        return self.adaptiveRatio * value
    }

    /// 根据设计图高度计算适配后的高度
    static func calcHeight(from value: CGFloat) -> CGFloat {
        return self.heightRatio * value
    }

    /// 计算适配后的最大值(根据设计图的宽度和高度,选择较大的值
    static func calcMax(from value: CGFloat) -> CGFloat {
        return max(self.calcWidth(from: value), self.calcHeight(from: value))
    }

    /// 计算适配后的最小值(根据设计图的宽度和高度,选择较小的值)
    static func calcMin(from value: CGFloat) -> CGFloat {
        return min(self.calcWidth(from: value), self.calcHeight(from: value))
    }
}

// MARK: - 整数适配扩展
@MainActor
public extension BinaryInteger {
    /// 适配宽度(将整数值按设计图宽度比例适配)
    var fitWidth: CGFloat {
        FdyScreen.calcWidth(from: CGFloat(self))
    }

    /// 适配高度(将整数值按设计图高度比例适配)
    var fitHeight: CGFloat {
        FdyScreen.calcHeight(from: CGFloat(self))
    }

    /// 适配最大值(根据设计图宽度和高度适配后的最大值)
    var fitLarger: CGFloat {
        FdyScreen.calcMax(from: CGFloat(self))
    }

    /// 适配最小值(根据设计图宽度和高度适配后的最小值)
    var fitSmaller: CGFloat {
        FdyScreen.calcMin(from: CGFloat(self))
    }
}

// MARK: - 浮动数字适配扩展
@MainActor
public extension BinaryFloatingPoint {
    /// 适配宽度(将浮动数字按设计图宽度比例适配)
    var fitWidth: CGFloat {
        FdyScreen.calcWidth(from: CGFloat(self))
    }

    /// 适配高度(将浮动数字按设计图高度比例适配)
    var fitHeight: CGFloat {
        FdyScreen.calcHeight(from: CGFloat(self))
    }

    /// 适配最大值(根据设计图宽度和高度适配后的最大值)
    var fitLarger: CGFloat {
        FdyScreen.calcMax(from: CGFloat(self))
    }

    /// 适配最小值(根据设计图宽度和高度适配后的最小值)
    var fitSmaller: CGFloat {
        FdyScreen.calcMin(from: CGFloat(self))
    }
}
