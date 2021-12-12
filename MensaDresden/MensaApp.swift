import SwiftUI

@main
struct MensaApp: App {
    private var settings: Settings
    private var deviceOrientation: DeviceOrientation
    private var locationManager: LocationManager
    private var omStore: OMStore

    init() {
        self.settings = Settings()
        if settings.canteenSorting == Settings.CanteenSorting.distance.rawValue {
            LocationManager.shared.start()
        }

        let isLandscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape
        self.deviceOrientation = DeviceOrientation(isLandscape: isLandscape ?? false)

        self.locationManager = LocationManager.shared

        self.omStore = OMStore(settings: settings)
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(settings)
                .environmentObject(deviceOrientation)
                .environmentObject(locationManager)
                .environmentObject(omStore)
        }
    }
}