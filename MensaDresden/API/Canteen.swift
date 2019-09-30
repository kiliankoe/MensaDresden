import Foundation
import struct CoreLocation.CLLocationCoordinate2D

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
    let url: URL
    let menu: URL
}
