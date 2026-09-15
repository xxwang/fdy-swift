import Foundation
import os.log
import CoreText
import CoreGraphics
import CryptoKit

#if canImport(UIKit)
    import UIKit

    public typealias FdyFont = UIFont
#endif

#if canImport(AppKit)
    import AppKit

    public typealias FdyFont = NSFont
#endif

#if canImport(CoreLocation)
    import CoreLocation
#endif
