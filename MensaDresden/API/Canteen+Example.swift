import Foundation
import EmealKit

extension Canteen {
    static var example: Canteen {
        Canteen(id: 1, name: "Alte Mensa", city: "Dresden", address: "Mommsenstr. 13, 01069 Dresden", coordinates: [51.02696733929933, 13.726491630077364], url: URL(string: "https://www.studentenwerk-dresden.de/mensen/details-alte-mensa.html")!, menu: URL(string: "https://www.studentenwerk-dresden.de/mensen/speiseplan/alte-mensa.html")!)
    }
}
