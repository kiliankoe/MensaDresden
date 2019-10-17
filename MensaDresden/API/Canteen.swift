import Foundation
import CoreLocation

struct Canteen: Identifiable, Decodable {
    let id: Int
    let name: String
    let city: String
    let address: String
    let coordinates: [Double]
    var coordinate: CLLocationCoordinate2D? {
        guard self.coordinates.count == 2 else { return nil }
        return CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
    }
    var location: CLLocation? {
        guard let coordinate = self.coordinate else { return nil }
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    let url: URL
    let menu: URL
}

extension Canteen {
    static var example: Canteen {
        Canteen(id: 1, name: "Alte Mensa", city: "Dresden", address: "Mommsenstr. 13, 01069 Dresden", coordinates: [51.02696733929933, 13.726491630077364], url: URL(string: "https://www.studentenwerk-dresden.de/mensen/details-alte-mensa.html")!, menu: URL(string: "https://www.studentenwerk-dresden.de/mensen/speiseplan/alte-mensa.html")!)
    }
}
