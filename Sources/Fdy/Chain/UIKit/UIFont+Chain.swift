import UIKit

// MARK: - 链式字体变换
//
// `UIFont` 是不可变类,链式一律**替换 `base`**(与 `Date+Chain.swift` 同例),原始字体不受影响。
//
// 变换统一走 `UIFontDescriptor`:
// - 改字号用 `withSize(_:)`;
// - 加粗/倾斜改 `symbolicTraits`;
// - 字重/设计走 `addingAttributes` / `withDesign(_:)`。
//
// `UIFont(descriptor:size:)` 的 `size` 传 `0` 表示**沿用 descriptor 自带的字号**(Apple 文档明确
// 支持),这样变换字号之外的特征时不会意外把字号重置成默认值。
//
// 所有变换在 descriptor 不可用时**原样返回**,不抛错也不产生 `nil` —— 链式调用不该因为字体特征
// 缺失而中断。
public extension FdyWrapper where Base == UIFont {
    /// 改字号,返回新字体
    @discardableResult
    func size(_ size: CGFloat) -> Self {
        base = base.withSize(size)
        return self
    }

    /// 加粗,返回新字体
    ///
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
