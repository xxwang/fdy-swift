import UIKit

// MARK: - 计算按钮尺寸
public extension UIButton {
    /// 获取指定宽度下按钮标题的 `CGSize`
    ///
    /// - Parameter maxWidth: 最大行宽度，默认 `.greatestFiniteMagnitude`(不折行)，
    ///   与 `UILabel.fdy_viewSize` / `NSAttributedString.fdy_viewSize` 的默认值保持一致。
    ///   需要按屏宽折行时显式传入 `FdyScreen.screenWidth`。
    /// - Returns: 标题的 `size`
    ///
    /// - Note: 测量的是**当前状态**的标题文本，要测其他状态需先切换状态。
    func fdy_viewSize(maxWidth: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        return if let currentAttributedTitle = self.currentAttributedTitle {
            currentAttributedTitle.fdy_viewSize(maxWidth: maxWidth)
        } else {
            self.titleLabel?.fdy_viewSize(maxWidth: maxWidth) ?? .zero
        }
    }
}
