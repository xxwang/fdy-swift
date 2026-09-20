import UIKit

public protocol FdyReusable: AnyObject {}
public extension FdyReusable {
    /// 复用标识
    /// - Returns: 处理后的字符串
    static var fdy_identifier: String {
        let clsName = FdyHelper.shared.className(Self.self)
        return "\(clsName)_identifier"
    }
}

extension UICollectionReusableView: FdyReusable {}
extension UITableViewCell: FdyReusable {}
extension UITableViewHeaderFooterView: FdyReusable {}
