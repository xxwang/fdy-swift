import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UICollectionViewCell {
    /// 选中状态
    ///
    /// - Parameter isSelected: 是否处于选中态
    /// - Returns: `Self`
    /// - Note: `UICollectionViewCell` **没有** `UITableViewCell` 那样的 `setSelected(_:animated:)`,
    ///   只有属性可写(即无动画版本),所以这里不提供 `animated` 形参。
    @discardableResult
    func isSelected(_ isSelected: Bool) -> Self {
        base.isSelected = isSelected
        return self
    }

    /// 高亮状态
    ///
    /// - Parameter isHighlighted: 是否处于高亮态
    /// - Returns: `Self`
    /// - Note: 同 ``isSelected(_:)``,无动画版本。
    @discardableResult
    func isHighlighted(_ isHighlighted: Bool) -> Self {
        base.isHighlighted = isHighlighted
        return self
    }

    /// 内容配置(`iOS 14` 起取代手搓 `contentView` 内子视图的做法)
    /// - Parameter configuration: 回调闭包
    /// - Returns: `Self`
    @discardableResult
    func contentConfiguration(_ configuration: (any UIContentConfiguration)?) -> Self {
        base.contentConfiguration = configuration
        return self
    }

    /// 是否由系统按 `configurationState` 自动刷新内容配置
    ///
    /// - Parameter automaticallyUpdates: 是否自动更新
    /// - Returns: `Self`
    /// - Note: 关掉后必须自己调 ``updateConfiguration()``,否则选中/高亮态下配置不会重算。
    @discardableResult
    func automaticallyUpdatesContentConfiguration(_ automaticallyUpdates: Bool) -> Self {
        base.automaticallyUpdatesContentConfiguration = automaticallyUpdates
        return self
    }

    /// 配置刷新回调
    ///
    /// - Parameter handler: 回调闭包
    /// - Returns: `Self`
    /// - Note: 在 ``automaticallyUpdatesContentConfiguration(_:)`` 为 `true` 时由系统调用;
    ///   关掉自动刷新后该闭包不会自己触发,需配合 ``updateConfiguration()`` 使用。
    @discardableResult
    func configurationUpdateHandler(
        _ handler: UICollectionViewCell.ConfigurationUpdateHandler?
    ) -> Self {
        base.configurationUpdateHandler = handler
        return self
    }

    /// 背景配置(`iOS 14` 起取代 ``backgroundView(_:)``)
    ///
    /// - Parameter configuration: 配置
    /// - Returns: `Self`
    /// - Note: **与 ``backgroundView(_:)`` 互斥,后设者赢** —— 先设 config 再设 view,
    ///   读回 `backgroundConfiguration` 会变成 `nil`(实测,与 `UITableViewCell` 同机制)。
    @discardableResult
    func backgroundConfiguration(_ configuration: UIBackgroundConfiguration?) -> Self {
        base.backgroundConfiguration = configuration
        return self
    }

    /// 是否由系统按 `configurationState` 自动刷新背景配置
    /// - Parameter automaticallyUpdates: 是否自动更新
    /// - Returns: `Self`
    @discardableResult
    func automaticallyUpdatesBackgroundConfiguration(_ automaticallyUpdates: Bool) -> Self {
        base.automaticallyUpdatesBackgroundConfiguration = automaticallyUpdates
        return self
    }

    /// 普通态背景视图
    ///
    /// - Parameter backgroundView: 视图
    /// - Returns: `Self`
    /// - Note: **与 ``backgroundConfiguration(_:)`` 互斥,后设者赢**(实测,与 `UITableViewCell` 同机制)。
    @discardableResult
    func backgroundView(_ backgroundView: UIView?) -> Self {
        base.backgroundView = backgroundView
        return self
    }

    /// 选中态背景视图
    /// - Parameter selectedBackgroundView: 视图
    /// - Returns: `Self`
    @discardableResult
    func selectedBackgroundView(_ selectedBackgroundView: UIView?) -> Self {
        base.selectedBackgroundView = selectedBackgroundView
        return self
    }
}

// MARK: - 方法
public extension FdyWrapper where Base: UICollectionViewCell {
    /// 主动触发一次配置刷新
    ///
    /// - Returns: `Self`
    /// - Note: 仅在 ``automaticallyUpdatesContentConfiguration(_:)`` /
    ///   ``automaticallyUpdatesBackgroundConfiguration(_:)`` 为 `false` 时才有必要手动调用。
    @discardableResult
    func updateConfiguration() -> Self {
        base.setNeedsUpdateConfiguration()
        return self
    }
}
