import UIKit

// MARK: - 链式字体变换
public extension FdyWrapper where Base == UIFont {
    /// 改字号,返回新字体
    /// - Parameter size: 尺寸
    /// - Returns: `Self`
    @discardableResult
    func size(_ size: CGFloat) -> Self {
        base = base.withSize(size)
        return self
    }

    /// 加粗,返回新字体
    ///
    /// - Returns: `Self`
    /// - Note: 通过 `symbolicTraits` 叠加 `.traitBold`,不改字号与字重轴。
    @discardableResult
    func bold() -> Self {
        var traits = base.fontDescriptor.symbolicTraits
        traits.insert(.traitBold)
        if let descriptor = base.fontDescriptor.withSymbolicTraits(traits) {
            base = UIFont(descriptor: descriptor, size: 0)
        }
        return self
    }

    /// 倾斜,返回新字体
    ///
    /// - Returns: `Self`
    /// - Note: 叠加 `.traitItalic`。系统字体本身没有斜体字面时,`withSymbolicTraits` 可能返回
    ///   `nil`(例如部分中文字体),此时**原样返回**、不会变成 `nil` 字体。
    @discardableResult
    func italic() -> Self {
        var traits = base.fontDescriptor.symbolicTraits
        traits.insert(.traitItalic)
        if let descriptor = base.fontDescriptor.withSymbolicTraits(traits) {
            base = UIFont(descriptor: descriptor, size: 0)
        }
        return self
    }

    /// 设定字重,返回新字体
    ///
    /// - Parameter weight: 字重
    /// - Returns: `Self`
    /// - Note: 只对**可变字重**的字体族有效(`UIFont.systemFont` 系列);`nil` 的描述符不影响结果。
    @discardableResult
    func weight(_ weight: UIFont.Weight) -> Self {
        let attributes: [UIFontDescriptor.AttributeName: Any] = [
            .traits: [UIFontDescriptor.TraitKey.weight: weight],
        ]
        base = UIFont(descriptor: base.fontDescriptor.addingAttributes(attributes), size: 0)
        return self
    }

    /// 换字体设计(默认 / 圆体 / 衬线 / 等宽),返回新字体
    ///
    /// - Parameter design: 字体设计
    /// - Returns: `Self`
    /// - Note: 即 `fontDescriptor.withDesign(_:)`(iOS 13+)。该设计在当前字体族不可用时返回 `nil`,
    ///   此时**原样返回**。
    @discardableResult
    func design(_ design: UIFontDescriptor.SystemDesign) -> Self {
        if let descriptor = base.fontDescriptor.withDesign(design) {
            base = UIFont(descriptor: descriptor, size: 0)
        }
        return self
    }
}
