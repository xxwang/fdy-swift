import AVFAudio

public extension AVAudioSession {
    /// 音频会话为蓝牙耳机支持模式
    /// - Parameter isActive: 是否激活音频会话,默认为 `true`
    /// - Throws: 如果设置失败,抛出错误
    static func fdy_bluetoothSupport(isActive: Bool = true) throws {
        let session = Self.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [.allowBluetoothA2DP, .mixWithOthers])
        try session.setActive(isActive)
    }
}
