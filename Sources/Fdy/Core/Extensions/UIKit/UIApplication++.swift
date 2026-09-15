import StoreKit
import UIKit

// MARK: - 常用方法
public extension UIApplication {
    /// 清除应用图标角标数字
    func fdy_clearBadgeNumber() {
        if #available(iOS 17.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            self.applicationIconBadgeNumber = 0
        }
    }
}

// MARK: - 应用详情
public extension UIApplication {
    /// 使用内嵌 `StoreKit` 视图显示应用详情
    /// - Parameters:
    ///   - appId:应用的`ID`
    ///   - from: 来源控制器
    func fdy_showStoreProduct(
        for appId: String,
        from viewController: UIViewController? = nil
    ) {
        guard !appId.isEmpty, let vc = viewController else { return }

        // 使用内嵌 StoreKit视图(适合审核规避)
        let storeVC = SKStoreProductViewController()
        storeVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appId]) { success, _ in
            if !success {
                DispatchQueue.main.async {
                    storeVC.dismiss(animated: true)
                }
            }
        }
        vc.present(storeVC, animated: true)
    }

    /// 在应用商店(`App Store`)中打开应用的(`App详情页`)
    /// - Parameters:
    /// - appId: 应用的`ID`
    func fdy_openInAppStore(with appId: String) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)?mt=8") {
            self.open(url)
        }
    }

    /// 如果有`AppStore`应用, 会在`AppStore`应用中打开, 如果没有会在`浏览器`中打开应用的(`App详情页`)
    /// - Parameters:
    /// - appId: 应用的`ID`
    func fdy_openInBrowser(with appId: String) {
        let urlString = "https://itunes.apple.com/cn/app/id\(appId)?mt=8"
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        self.open(url)
    }
}

// MARK: - 应用评价
public extension UIApplication {
    /// 在应用内打开应用的`App Store评价`弹窗(一年最多3次)
    @MainActor func fdy_requestAppReview() {
        if let windowScene = UIWindow.fdy_keyWindow?.windowScene {
            if #available(iOS 16.0, *) {
                AppStore.requestReview(in: windowScene)
            } else {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }

    /// 在网页(`浏览器`)中打开应用的`App Store评价`页面
    /// - Parameter appId: 应用在商店中的ID
    func fdy_openReviewPage(with appId: String) {
        let urlString = "https://itunes.apple.com/cn/app/id\(appId)?action=write-review"
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        self.open(url)
    }
}

// MARK: - URL 与系统跳转
public extension UIApplication {
    /// 打开`URL`
    /// - Parameters:
    ///   - url: 要打开的 URL
    ///   - completion: 打开结果回调
    func fdy_open(_ url: URL, completion: FdyAction1<Bool>? = nil) {
        guard self.canOpenURL(url) else {
            completion?(false)
            return
        }
        self.open(url, options: [:]) { success in
            DispatchQueue.main.async {
                completion?(success)
            }
        }
    }

    /// 拨打指定电话号码
    /// - Parameters:
    ///   - phoneNumber: 电话号码(纯数字,不含空格或符号)
    ///   - completion: 拨号结果回调
    func fdy_call(to phoneNumber: String, completion: FdyAction1<Bool>? = nil) {
        let cleanNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        guard !cleanNumber.isEmpty else {
            completion?(false)
            return
        }

        guard let telURL = URL(string: "tel://\(cleanNumber)") else {
            assertionFailure("无法构造电话 URL: tel://\(cleanNumber)")
            completion?(false)
            return
        }
        self.fdy_open(telURL, completion: completion)
    }

    /// 打开系统设置中的本 `App` 页面
    func fdy_openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        self.open(url)
    }

    /// 打开通知设置页面
    func fdy_openNotificationSettings() {
        if #available(iOS 16.0, *) {
            if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                self.open(url)
                return
            }
        }
        self.fdy_openSettings()
    }
}

// MARK: - 应用版本管理
public extension UIApplication {
    /// 解析版本字符串为结构化数据
    struct FdyAppVersion: Equatable {
        let versionString: String
        let major: Int
        let minor: Int
        let patch: Int

        let isValid: Bool

        init(_ versionString: String) {
            self.versionString = versionString
            let comps = versionString.fdy_split(bySeparator: ".")
            if comps.count >= 3 {
                self.major = comps[0].fdy_int()
                self.minor = comps[1].fdy_int()
                self.patch = comps[2].fdy_int()
                self.isValid = true
            } else {
                self.major = 0
                self.minor = 0
                self.patch = 0
                self.isValid = false
            }
        }

        /// 比较是否比另一个版本更新
        func isGreaterThan(_ other: FdyAppVersion) -> Bool {
            if major != other.major {
                return major > other.major
            }
            if minor != other.minor {
                return minor > other.minor
            }
            return patch > other.patch
        }
    }

    /// 当前 App 的结构化版本信息
    var fdy_currentAppVersion: FdyAppVersion {
        return FdyAppVersion(Bundle.fdy_appVersion)
    }

    /// 是否为首次安装或升级到新版本(只读,不会写回 UserDefaults)
    /// - Note: 本属性只做判断,不产生任何副作用。处理完新版本引导逻辑后,请调用 `recordCurrentVersion()` 记录当前版本。
    var fdy_isNewVersion: Bool {
        let current = Bundle.fdy_appVersion
        let saved = UserDefaults.standard.string(forKey: "Fdy.AppVersion") ?? ""
        return FdyAppVersion(current).isGreaterThan(FdyAppVersion(saved))
    }

    /// 将当前 App 版本记录到 UserDefaults(通常在处理完新版本引导后调用)
    func fdy_recordCurrentVersion() {
        UserDefaults.standard.set(Bundle.fdy_appVersion, forKey: "Fdy.AppVersion")
    }

    /// 比较当前版本是否低于指定版本
    /// - Returns: `true` 表示当前版本 < 参数版本(即有更新)
    func fdy_isVersionBelow(_ targetVersion: String) -> Bool {
        let current = self.fdy_currentAppVersion
        let target = FdyAppVersion(targetVersion)
        return current.isGreaterThan(target) == false && current != target
    }
}
