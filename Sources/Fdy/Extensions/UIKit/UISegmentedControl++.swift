import UIKit

// MARK: - 属性
public extension UISegmentedControl {
    /// 获取或设置所有分段的图片
    /// - Returns: 图片数组
    var fdy_images: [UIImage] {
        get {
            return (0 ..< self.numberOfSegments).compactMap { self.imageForSegment(at: $0) }
        }
        set {
            self.removeAllSegments()
            for (index, image) in newValue.enumerated() {
                self.insertSegment(with: image.withRenderingMode(.alwaysOriginal), at: index, animated: false)
            }
        }
    }

    /// 获取或设置所有分段的标题
    /// - Returns: 字符串数组
    var fdy_titles: [String] {
        get {
            return (0 ..< self.numberOfSegments).compactMap { self.titleForSegment(at: $0) }
        }
        set {
            self.removeAllSegments()
            for (index, title) in newValue.enumerated() {
                self.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }
}
