import UIKit

// MARK: - Cell 注册与复用
public extension UITableView {
    /// 复用无 `indexPath` 的 `Cell`(适用于非标准场景,如动态高度估算)
    /// - Parameter cellType: 期望的 `Cell` 类型
    /// - Returns: 类型安全的 Cell 实例
    /// - Warning: 未注册或类型不匹配时中止程序(开发期快速暴露问题)
    func fdy_dequeueReusableCell<T: UITableViewCell>(withCellClass cellType: T.Type) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.fdy_identifier) as? T else {
            // 不用 `assertionFailure`:它自 `-O` 起被移除,Release 下会让调用方静默拿到一个空白 `T()`
            preconditionFailure("未能复用 Cell: \(cellType). 请确认已通过 register 注册！")
        }
        return cell
    }

    /// 安全地复用带 `indexPath` 的 `Cell`(推荐用于` tableView(_:cellForRowAt:)`)
    /// - Parameters:
    ///   - cellType: 期望的 `Cell` 类型
    ///   - indexPath: 位置索引
    /// - Returns: 类型安全的 `Cell`
    /// - Warning: 未注册时由 UIKit 自身抛异常中止;类型不匹配时在本方法内中止
    func fdy_dequeueReusableCell<T: UITableViewCell>(
        withCellClass cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.fdy_identifier, for: indexPath) as? T else {
            // 未注册的场景 UIKit 会先抛异常;能走到这里的只有「注册了 A 却按 T 取」
            preconditionFailure("未能复用 Cell: \(cellType). 请确认已注册！")
        }
        return cell
    }

    /// 复用 `Header/Footer View`
    /// - Warning: 未注册或类型不匹配时中止程序
    /// - Returns: 复用的视图实例
    func fdy_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        withHeaderFooterViewClass viewType: T.Type
    ) -> T {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.fdy_identifier) as? T else {
            // 同 `fdy_dequeueReusableCell`:不用 `assertionFailure` 的理由见上
            preconditionFailure("未能复用 Header/Footer: \(viewType). 请确认已注册！")
        }
        return view
    }
}
