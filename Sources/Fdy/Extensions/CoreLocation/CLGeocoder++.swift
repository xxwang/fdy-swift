import CoreLocation

// MARK: - 方法
public extension CLGeocoder {
    /// 反向地理编码：将经纬度转换为地址信息
    ///
    /// - Parameters:
    ///   - location: 位置
    ///   - completionHandler: 回调,返回 placemarks 或 error
    ///
    /// - 注意：
    ///   - 结果语言由系统区域设置决定,无法通过 API 强制指定
    ///   - 每次调用都会新建 `CLGeocoder` 实例并发起请求,实例在回调结束后自动释放
    static func fdy_reverseGeocodeLocation(
        _ location: CLLocation,
        completionHandler: @escaping CLGeocodeCompletionHandler
    ) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            completionHandler(placemarks, error)
        }
    }

    /// 地理编码：将地址字符串转换为经纬度
    ///
    /// - Parameters:
    ///   - addressString: 地址文本(建议包含城市和国家以提高精度)
    ///   - completionHandler: 完成回调
    static func fdy_geocodeAddressString(
        _ addressString: String,
        completionHandler: @escaping CLGeocodeCompletionHandler
    ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            completionHandler(placemarks, error)
        }
    }
}
