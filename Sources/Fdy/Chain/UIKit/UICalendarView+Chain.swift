import UIKit

// MARK: - 链式设置属性
public extension FdyWrapper where Base: UICalendarView {
    /// 代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UICalendarViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 选择行为
    /// - Parameter selectionBehavior: 选择行为(单选 / 多选 / 范围),`nil` 表示不可选
    /// - Returns: `Self`
    @discardableResult
    func selectionBehavior(_ selectionBehavior: UICalendarSelection?) -> Self {
        base.selectionBehavior = selectionBehavior
        return self
    }

    /// 日历
    /// - Parameter calendar: 决定年月日如何切分(如 `.gregorian` / `.chinese`)
    /// - Returns: `Self`
    @discardableResult
    func calendar(_ calendar: Calendar) -> Self {
        base.calendar = calendar
        return self
    }

    /// 地区
    /// - Parameter locale: 地区(影响首日、月份名等)
    /// - Returns: `Self`
    @discardableResult
    func locale(_ locale: Locale) -> Self {
        base.locale = locale
        return self
    }

    /// 时区
    /// - Parameter timeZone: 时区,`nil` 表示用系统时区
    /// - Returns: `Self`
    @discardableResult
    func timeZone(_ timeZone: TimeZone?) -> Self {
        base.timeZone = timeZone
        return self
    }

    /// 字体设计
    /// - Parameter fontDesign: 系统字体设计(默认 / 圆体 / 衬线 / 等宽)
    /// - Returns: `Self`
    @discardableResult
    func fontDesign(_ fontDesign: UIFontDescriptor.SystemDesign) -> Self {
        base.fontDesign = fontDesign
        return self
    }

    /// 可选日期范围
    /// - Parameter availableDateRange: 可被选中的日期区间(区间外置灰)
    /// - Returns: `Self`
    ///
    /// - Note: 头文件声明为 `NSDateInterval *`,Swift 侧桥接为 **`DateInterval`**(非 `NSDateInterval`)。
    @discardableResult
    func availableDateRange(_ availableDateRange: DateInterval) -> Self {
        base.availableDateRange = availableDateRange
        return self
    }

    /// 当前可见的月份
    /// - Parameter visibleDateComponents: 年月分量(至少含 `year` / `month`)
    /// - Returns: `Self`
    @discardableResult
    func visibleDateComponents(_ visibleDateComponents: DateComponents) -> Self {
        base.visibleDateComponents = visibleDateComponents
        return self
    }

    /// 是否显示日期装饰
    /// - Parameter wantsDateDecorations: `true` 表示显示日期装饰
    /// - Returns: `Self`
    @discardableResult
    func wantsDateDecorations(_ wantsDateDecorations: Bool) -> Self {
        base.wantsDateDecorations = wantsDateDecorations
        return self
    }
}
