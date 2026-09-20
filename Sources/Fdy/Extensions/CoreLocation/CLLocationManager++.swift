import CoreLocation

// MARK: - 属性
public extension CLLocationManager {
    /// 获取当前位置的经纬度(在定位成功之后使用)
    /// - Returns: 地理坐标,不可用时返回 `nil`
    var fdy_coordinate: CLLocationCoordinate2D? {
        return self.location?.coordinate
    }
}
