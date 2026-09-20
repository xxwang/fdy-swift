import CoreLocation

// MARK: - 方法
public extension CLLocationCoordinate2D {
    /// 将当前坐标转换为 `CLLocation` 实例
    ///
    /// - Returns: 对应的 `CLLocation` 对象(无海拔、速度等附加信息)
    func fdy_location() -> CLLocation {
        CLLocation(latitude: self.latitude, longitude: self.longitude)
    }

    /// 计算当前坐标与另一个坐标之间的`大圆距离`(地球表面最短距离)
    ///
    /// - Parameter other: 目标坐标
    /// - Returns: 两点间的距离(单位：米)
    /// - 使用 `CLLocation.distance(from:)` 实现,基于 WGS-84 椭球模型
    /// - 单位：`米(meters)`
    /// - 精度适用于大多数地理应用(如导航、附近搜索)
    func fdy_distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        self.fdy_location().distance(from: other.fdy_location())
    }
}
