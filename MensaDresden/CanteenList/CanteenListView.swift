import SwiftUI
import MapKit

struct CanteenListView: View {
    @State var canteens: [Canteen] = [
        Canteen(id: 1, name: "Alte Mensa", city: "Dresden", address: "Mommsenstr. 13, 01069 Dresden", coordinates: [51.02696733929933, 13.726491630077364], url: URL(string: "https://studentenwerk-dresden.de")!, menu: URL(string: "https://studentenwerk-dresden.de")!),
        Canteen(id: 2, name: "Siedepunkt", city: "Dresden", address: "Zellescher Weg 17, 01069 Dresden", coordinates: [51.02946063983054, 13.738727867603302], url: URL(string: "https://studentenwerk-dresden.de")!, menu: URL(string: "https://studentenwerk-dresden.de")!),
        Canteen(id: 3, name: "Mensa Reichenbachstraße", city: "Dresden", address: "Reichenbachstr. 1, 01069 Dresden", coordinates: [51.034283226863565, 13.734020590782166], url: URL(string: "https://studentenwerk-dresden.de")!, menu: URL(string: "https://studentenwerk-dresden.de")!)
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
