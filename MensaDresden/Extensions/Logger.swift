import os.log
import Foundation

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let breadcrumb = Logger(subsystem: subsystem, category: "Breadcrumb")
    static let api = Logger(subsystem: subsystem, category: "API")
    static let locationManager = Logger(subsystem: subsystem, category: "LocationManager")
    static let deviceOrientation = Logger(subsystem: subsystem, category: "DeviceOrientation")
}
