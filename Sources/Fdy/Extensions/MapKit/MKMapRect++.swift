import MapKit

// MARK: - 方法
public extension MKMapRect {
    /// 将 `MKCoordinateRegion`(经纬度区域)转换为 `MKMapRect`(地图投影矩形)
    ///
    /// 此方法通过计算区域的左上角和右下角地理坐标,再将其转换为地图投影点(`MKMapPoint`),
    /// 最终构建对应的矩形范围适用于将可视区域转换为可用于叠加层或边界计算的 `MKMapRect`
    ///
    /// - Parameter region: 要转换的地理区域
    /// - Returns: 对应的地图矩形(`MKMapRect`)
    ///
    /// - Important:
    ///   - 该转换假设区域不跨越国际日期变更线或极点(常规城市级区域安全)
    ///   - 若 `span` 过大(如全球视图),结果可能不准确,但 MapKit 本身对此也有局限
    static func fdy_regionToMapRect(_ region: MKCoordinateRegion) -> MKMapRect {
        // 计算左上角和右下角的地理坐标
        let topLeft = MKMapPoint(region.fdy_topLeftCoordinate)
        let bottomRight = MKMapPoint(region.fdy_bottomRightCoordinate)

        // 构造 MKMapRect
        let origin = MKMapPoint(x: min(topLeft.x, bottomRight.x), y: min(topLeft.y, bottomRight.y))
        let size = MKMapSize(
            width: (bottomRight.x - topLeft.x).fdy_abs(),
            height: (bottomRight.y - topLeft.y).fdy_abs()
        )

        return MKMapRect(origin: origin, size: size)
    }
}
