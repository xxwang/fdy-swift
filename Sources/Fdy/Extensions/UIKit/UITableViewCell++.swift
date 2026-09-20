import UIKit

// MARK: - 属性
public extension UITableViewCell {
    /// 返回当前 cell 所在的 `UITableView`(通过响应链查找)
    /// - Returns: 表格视图,不可用时返回 `nil`
    var fdy_tableView: UITableView? {
        var responder: UIResponder? = self
        while responder != nil {
            if let tableView = responder as? UITableView {
                return tableView
            }
            responder = responder?.next
        }
        return nil
    }

    /// 返回当前 cell 在 tableView 中的 `IndexPath`(若存在)
    /// - Returns: 索引路径,不可用时返回 `nil`
    var fdy_indexPath: IndexPath? {
        guard let tableView = self.fdy_tableView else { return nil }
        return tableView.indexPath(for: self)
    }
}
