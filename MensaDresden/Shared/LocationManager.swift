import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    var manager: CLLocationManager

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
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    func stop() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        currentHeading = newHeading
    }
}
