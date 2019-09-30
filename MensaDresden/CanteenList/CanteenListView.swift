import SwiftUI
import MapKit

struct Canteen: Identifiable {
    let id: Int
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}

struct CanteenListView: View {
    @State var canteens: [Canteen] = [
        Canteen(id: 1, name: "Alte Mensa", address: "Mommsenstr. 13, 01069 Dresden",
                coordinate: CLLocationCoordinate2D(latitude: 51.02696733929933, longitude: 13.726491630077364)),
        Canteen(id: 2, name: "Siedepunkt", address: "Zellescher Weg 17, 01069 Dresden",
                coordinate: CLLocationCoordinate2D(latitude: 51.02946063983054, longitude: 13.738727867603302)),
        Canteen(id: 3, name: "Mensa Reichenbergstraße", address: "Reichenbachstr. 1, 01069 Dresden",
                coordinate: CLLocationCoordinate2D(latitude: 51.034283226863565, longitude: 13.734020590782166)),
    ]

    var body: some View {
        NavigationView {
            List(canteens) { canteen in
                NavigationLink(destination: MealListView(canteenName: canteen.name)) {
                    CanteenCell(canteen: canteen)
                }
            }
            .navigationBarTitle("Canteens")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CanteenListView()
    }
}
