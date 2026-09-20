import UIKit

public extension UICollectionView {
    /// 关联属性键
    enum FdyKeys {
        static var moveItemGestureKey: UInt8 = 0
    }
}

// MARK: - 常用方法
public extension UICollectionView {
    /// 启用长按拖拽移动 `Item` 功能(自动添加长按手势并处理交互式移动)
    func fdy_allowMoveItem() {
        let longPress = UILongPressGestureRecognizer()
        longPress
            .fdy
            .onStateChanged { [weak self, weak longPress] state in
                guard let self, let recognizer = longPress else { return }

                let location = recognizer.location(in: self)
                switch state {
                case .began:
                    if let indexPath = self.indexPathForItem(at: location) {
                        self.beginInteractiveMovementForItem(at: indexPath)
                    }
                case .changed:
                    self.updateInteractiveMovementTargetPosition(location)
                case .ended:
                    self.endInteractiveMovement()
                default:
                    self.cancelInteractiveMovement()
                }
            }
        self.addGestureRecognizer(longPress)
        self.fdy_SetAO(longPress, forKey: &FdyKeys.moveItemGestureKey)
    }

    /// 禁用拖拽移动功能(仅移除 `allowMoveItem` 添加的长按手势,不影响其它长按手势)
    func fdy_disableMoveItem() {
        if let gesture = self.fdy_GetAO(forKey: &FdyKeys.moveItemGestureKey) as? UILongPressGestureRecognizer {
            self.removeGestureRecognizer(gesture)
            self.fdy_SetAO(nil, forKey: &FdyKeys.moveItemGestureKey)
        }
    }
}

// MARK: - 复用
public extension UICollectionView {
    /// 安全地复用 `Cell`(自动类型转换 + 断言)
    /// - Parameters:
    ///   - cellType: 期望的 Cell 类型
    ///   - indexPath: 位置
    /// - Returns: 类型安全的 `Cell` 实例
    /// - Warning: 未注册时由 UIKit 自身抛异常中止;类型不匹配时在本方法内中止
    func fdy_dequeueReusableCell<T: UICollectionViewCell>(
        withClass cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: cellType.fdy_identifier,
            for: indexPath
        ) as? T else {
            // 不用 `assertionFailure`:它自 `-O` 起被移除,Release 下会让调用方静默拿到一个空白 `T()`
            preconditionFailure("未能正确复用 Cell: \(cellType). 请确认已通过register 注册！")
        }
        return cell
    }

    /// 安全地复用补充视图
    /// - Parameters:
    ///   - kind: 视图种类
    ///   - viewType: 期望类型
    ///   - indexPath: 位置
    /// - Returns: 类型安全的补充视图
    /// - Warning: 未注册时由 UIKit 自身抛异常中止;类型不匹配时在本方法内中止
    func fdy_dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        withClass viewType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let view = self.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: viewType.fdy_identifier,
            for: indexPath
        ) as? T else {
            // 同 `fdy_dequeueReusableCell`:不用 `assertionFailure` 的理由见上
            preconditionFailure("未能正确复用 Supplementary View: \(viewType). 请确认已注册！")
        }
        return view
    }
}
