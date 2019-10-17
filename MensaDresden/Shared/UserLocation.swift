import Foundation
import CoreLocation
import Combine

class UserLocation: NSObject, ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    var manager: CLLocationManager

    var lastLocation: CLLocation? {
        didSet {
            objectWillChange.send()
        }
    }

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

    static var shared = UserLocation()

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        manager.startUpdatingLocation()
    }

    func stop() {
        manager.stopUpdatingLocation()
    }
}

extension UserLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
