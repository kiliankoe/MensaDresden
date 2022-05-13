import Foundation
import CoreLocation
import Combine
import os.log

class LocationManager: NSObject, ObservableObject {
    private var manager: CLLocationManager

    @Published
    var authorizationStatus: CLAuthorizationStatus?

    @Published
    var lastLocation: CLLocation?

    @Published
    var currentHeading: CLHeading?

    func distance(from other: CLLocationCoordinate2D) -> CLLocationDistance? {
        let otherLocation = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return lastLocation?.distance(from: otherLocation)
    }

    override init() {
        manager = CLLocationManager()
        super.init()
        manager.delegate = self
        manager.distanceFilter = 250
    }

    static var shared = LocationManager()

    func start() {
        Logger.locationManager.info("Starting location tracking")
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    func stop() {
        Logger.locationManager.info("Stopping location tracking")
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Logger.locationManager.info("Did update locations: \(locations.map(\.coordinate).map { "@\($0.latitude),\($0.longitude)" }.first ?? "", privacy: .sensitive)")
        lastLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.locationManager.error("Did fail with error: \(String(describing: error))")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        currentHeading = newHeading
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Logger.locationManager.info("Did change autorization status: \(String(describing: status))")
        authorizationStatus = status
    }
}
