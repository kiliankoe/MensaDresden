import SwiftUI
import MapKit

struct CanteenListView: View {
    @ObservedObject private var service = CanteenService()

    @EnvironmentObject var settings: Settings
    var canteens: [Canteen] {
        let favorites = service.canteens.filter { settings.favoriteCanteens.contains($0.name) }
        let nonFavorites = service.canteens.filter { !settings.favoriteCanteens.contains($0.name) }

        let sortedFavorites = favorites.sorted { (lhs, rhs) in
            // Force Unwrap should be safe here, since the list was just filtered based on favorites.
            settings.favoriteCanteens.firstIndex(of: lhs.name)! < settings.favoriteCanteens.firstIndex(of: rhs.name)!
        }

        return sortedFavorites + nonFavorites
    }

    var body: some View {
        NavigationView {
            List(canteens) { canteen in
                NavigationLink(destination: MealListView(canteen: canteen)) {
                    CanteenCell(canteen: canteen)
                }
            }
            .navigationBarTitle("Canteens")
            .navigationBarItems(trailing:
                HStack {
                    BarButtonNavigationLink(destination: EmealView(), image: Image(systemName: "creditcard"))
                        .padding(.trailing, 5)
                    BarButtonNavigationLink(destination: SettingsView(), image: Image(systemName: "gear"))
                        .padding(.trailing, 5)
                    BarButtonNavigationLink(destination: InfoView(), image: Image(systemName: "info.circle"))
                }

            )
        }
        .onAppear {
            self.service.fetchCanteens()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CanteenListView()
    }
}
