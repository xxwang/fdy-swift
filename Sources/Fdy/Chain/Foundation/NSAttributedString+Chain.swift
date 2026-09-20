import Foundation

// MARK: - 方法
public extension FdyWrapper where Base: NSAttributedString {
    /// 将当前不可变属性字符串转换为可变属性字符串
    /// - Returns: 包装对象
    func toMutable() -> FdyWrapper<NSMutableAttributedString> {
        let matt = NSMutableAttributedString(attributedString: base)
        return FdyWrapper<NSMutableAttributedString>(matt)
    }
}
