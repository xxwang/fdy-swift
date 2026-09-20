import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UIToolbarAppearance {
    /// 普通样式按钮项的外观
    /// - Parameter buttonAppearance: 要设置的普通样式按钮项的外观
    /// - Returns: `Self`
    @discardableResult
    func buttonAppearance(_ buttonAppearance: UIBarButtonItemAppearance) -> Self {
        base.buttonAppearance = buttonAppearance
        return self
    }

    ///  `.prominent` 样式按钮项的外观(工具栏上即 `UIBarButtonItem.Style.prominent`)
    ///
    /// - Parameter prominentButtonAppearance: 突出的按钮外观
    /// - Returns: `Self`
    /// - Note: 标注为 `iOS 26.0` 起可用 —— 高于新增 API 门槛(`iOS 18.0`),必须标注。
    ///   反证实测见 `.build/structprobe/batch4_negative.swift`:去掉标注后编译报
    ///   `'prominentButtonAppearance' is only available in iOS 26.0 or newer`。
    @available(iOS 26.0, *)
    @discardableResult
    func prominentButtonAppearance(_ prominentButtonAppearance: UIBarButtonItemAppearance) -> Self {
        base.prominentButtonAppearance = prominentButtonAppearance
        return self
    }

    /// 「完成」样式按钮项的外观
    ///
    /// - Note: `iOS 26.0` 起被 ``prominentButtonAppearance(_:)`` 取代(系统头文件
    ///   `API_DEPRECATED_WITH_REPLACEMENT`)。**仍保留**,因为 `iOS 18`~`25` 上它是唯一入口;
    ///   本包装器同样标成废弃,调用方会收到替换提示。
    @available(iOS, introduced: 13.0, deprecated: 26.0, renamed: "prominentButtonAppearance(_:)")
    @discardableResult
    func doneButtonAppearance(_ doneButtonAppearance: UIBarButtonItemAppearance) -> Self {
        base.doneButtonAppearance = doneButtonAppearance
        return self
    }
}
