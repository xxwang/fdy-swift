import MapKit

// MARK: - 注册与复用
public extension FdyWrapper where Base: MKMapView {
    /// 注册自定义注解视图类,使用类名作为重用标识符
    ///
    /// - Parameter annotationViewClass: 继承自 `MKAnnotationView` 的类型
    /// - Returns: `Self`
    @discardableResult
    func register<T: MKAnnotationView>(annotationViewWithClass annotationViewClass: T.Type) -> Self {
        base.register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: T.self))
        return self
    }

    /// 地图代理
    /// - Parameter delegate: 遵循 `MKMapViewDelegate` 的对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: MKMapViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 地图配置(替代已废弃的 `mapType` 等)
    /// - Parameter preferredConfiguration: 首选配置
    /// - Returns: `Self`
    @discardableResult
    func preferredConfiguration(_ preferredConfiguration: MKMapConfiguration) -> Self {
        base.preferredConfiguration = preferredConfiguration
        return self
    }

    /// 可点选的兴趣点类型
    /// - Parameter selectableMapFeatures: 要设置的可点选的兴趣点类型
    /// - Returns: `Self`
    @discardableResult
    func selectableMapFeatures(_ selectableMapFeatures: MKMapFeatureOptions) -> Self {
        base.selectableMapFeatures = selectableMapFeatures
        return self
    }

    /// 可见区域
    /// - Parameter region: 区域
    /// - Returns: `Self`
    @discardableResult
    func region(_ region: MKCoordinateRegion) -> Self {
        base.region = region
        return self
    }

    /// 中心坐标
    /// - Parameter centerCoordinate: 地理坐标
    /// - Returns: `Self`
    @discardableResult
    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> Self {
        base.centerCoordinate = centerCoordinate
        return self
    }

    /// 可见地图矩形
    /// - Parameter visibleMapRect: 要设置的可见地图矩形
    /// - Returns: `Self`
    @discardableResult
    func visibleMapRect(_ visibleMapRect: MKMapRect) -> Self {
        base.visibleMapRect = visibleMapRect
        return self
    }

    /// 相机
    /// - Parameter camera: 要设置的相机
    /// - Returns: `Self`
    @discardableResult
    func camera(_ camera: MKMapCamera) -> Self {
        base.camera = camera
        return self
    }

    /// 相机的缩放范围
    /// - Parameter cameraZoomRange: 缩放范围
    /// - Returns: `Self`
    @discardableResult
    func cameraZoomRange(_ cameraZoomRange: MKMapView.CameraZoomRange) -> Self {
        base.cameraZoomRange = cameraZoomRange
        return self
    }

    /// 相机的活动边界
    /// - Parameter cameraBoundary: 边界,传 `nil` 清空
    /// - Returns: `Self`
    @discardableResult
    func cameraBoundary(_ cameraBoundary: MKMapView.CameraBoundary?) -> Self {
        base.cameraBoundary = cameraBoundary
        return self
    }

    /// 是否允许缩放
    /// - Parameter isZoomEnabled: `true` 表示允许缩放
    /// - Returns: `Self`
    @discardableResult
    func isZoomEnabled(_ isZoomEnabled: Bool) -> Self {
        base.isZoomEnabled = isZoomEnabled
        return self
    }

    /// 是否允许滚动
    /// - Parameter isScrollEnabled: `true` 表示允许滚动
    /// - Returns: `Self`
    @discardableResult
    func isScrollEnabled(_ isScrollEnabled: Bool) -> Self {
        base.isScrollEnabled = isScrollEnabled
        return self
    }

    /// 是否允许旋转
    /// - Parameter isRotateEnabled: `true` 表示允许旋转
    /// - Returns: `Self`
    @discardableResult
    func isRotateEnabled(_ isRotateEnabled: Bool) -> Self {
        base.isRotateEnabled = isRotateEnabled
        return self
    }

    /// 是否允许俯仰
    /// - Parameter isPitchEnabled: 是否允许倾斜
    /// - Returns: `Self`
    @discardableResult
    func isPitchEnabled(_ isPitchEnabled: Bool) -> Self {
        base.isPitchEnabled = isPitchEnabled
        return self
    }

    /// 是否显示定位按钮
    /// - Parameter showsUserTrackingButton: 是否显示用户追踪按钮
    /// - Returns: `Self`
    @discardableResult
    func showsUserTrackingButton(_ showsUserTrackingButton: Bool) -> Self {
        base.showsUserTrackingButton = showsUserTrackingButton
        return self
    }

    /// 俯仰按钮的可见性
    /// - Parameter pitchButtonVisibility: 要设置的俯仰按钮的可见性
    /// - Returns: `Self`
    @discardableResult
    func pitchButtonVisibility(_ pitchButtonVisibility: MKFeatureVisibility) -> Self {
        base.pitchButtonVisibility = pitchButtonVisibility
        return self
    }

    /// 是否显示指南针
    /// - Parameter showsCompass: `true` 表示显示指南针
    /// - Returns: `Self`
    @discardableResult
    func showsCompass(_ showsCompass: Bool) -> Self {
        base.showsCompass = showsCompass
        return self
    }

    /// 是否显示比例尺
    /// - Parameter showsScale: `true` 表示显示比例尺
    /// - Returns: `Self`
    @discardableResult
    func showsScale(_ showsScale: Bool) -> Self {
        base.showsScale = showsScale
        return self
    }

    /// 是否显示用户位置
    /// - Parameter showsUserLocation: `true` 表示显示用户位置
    /// - Returns: `Self`
    @discardableResult
    func showsUserLocation(_ showsUserLocation: Bool) -> Self {
        base.showsUserLocation = showsUserLocation
        return self
    }

    /// 用户追踪模式
    /// - Parameter userTrackingMode: 要设置的用户追踪模式
    /// - Returns: `Self`
    @discardableResult
    func userTrackingMode(_ userTrackingMode: MKUserTrackingMode) -> Self {
        base.userTrackingMode = userTrackingMode
        return self
    }

    /// 选中的标注
    /// - Parameter selectedAnnotations: 要设置的选中的标注
    /// - Returns: `Self`
    @discardableResult
    func selectedAnnotations(_ selectedAnnotations: [any MKAnnotation]) -> Self {
        base.selectedAnnotations = selectedAnnotations
        return self
    }
}
