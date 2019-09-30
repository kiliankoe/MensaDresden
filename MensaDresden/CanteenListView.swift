import SwiftUI

struct Canteen: Identifiable {
    let id: Int
    let name: String
}

struct CanteenListView: View {
    @State var canteens: [Canteen] = [
        Canteen(id: 1, name: "Alte Mensa"),
        Canteen(id: 2, name: "Siedepunkt"),
        Canteen(id: 3, name: "Mensa Reichenbergstraße"),
    ]

    var body: some View {
        NavigationView {
            List(canteens) { canteen in
                NavigationLink(destination: MealListView(canteenName: canteen.name)) {
                    Text(canteen.name)
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
