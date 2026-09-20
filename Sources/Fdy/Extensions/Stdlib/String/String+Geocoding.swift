
import CoreLocation

// MARK: - 地理位置(地址转坐标)
public extension String {
    /// 对当前地址字符串执行地理编码(地址 → 坐标)
    ///
    /// - Important: 此方法应在主线程调用,因为 `CLGeocoder` 的回调总是在主线程执行
    /// - Parameter completion: 完成回调,返回 `[CLPlacemark]?` 和 `Error?`
    func fdy_geocode(completion: @escaping (CLGeocodeCompletionHandler)) {
        CLGeocoder().geocodeAddressString(self) { placemarks, error in
            DispatchQueue.main.async {
                completion(placemarks, error)
            }
        }
    }
}
