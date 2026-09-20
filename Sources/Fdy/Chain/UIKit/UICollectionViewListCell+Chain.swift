import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UICollectionViewListCell {
    /// 缩进层级
    /// - Parameter indentationLevel: 缩进层级数,乘 `indentationWidth` 得实际缩进
    /// - Returns: `Self`
    @discardableResult
    func indentationLevel(_ indentationLevel: Int) -> Self {
        base.indentationLevel = indentationLevel
        return self
    }

    /// 单级缩进宽度
    /// - Parameter indentationWidth: 每一级的缩进宽度,`0` 表示用系统默认
    /// - Returns: `Self`
    @discardableResult
    func indentationWidth(_ indentationWidth: CGFloat) -> Self {
        base.indentationWidth = indentationWidth
        return self
    }

    /// 附件是否随内容缩进
    /// - Parameter indentsAccessories: 附件(展开箭头 / 勾选等)是否一起缩进
    /// - Returns: `Self`
    @discardableResult
    func indentsAccessories(_ indentsAccessories: Bool) -> Self {
        base.indentsAccessories = indentsAccessories
        return self
    }

    /// 附件列表
    /// - Parameter accessories: 尾部附件(箭头 / 勾选 / 详情按钮 等)
    /// - Returns: `Self`
    @discardableResult
    func accessories(_ accessories: [UICellAccessory]) -> Self {
        base.accessories = accessories
        return self
    }
}
