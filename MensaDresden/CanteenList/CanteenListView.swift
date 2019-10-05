import SwiftUI
import MapKit

struct CanteenListView: View {
    @ObservedObject private var service = CanteenService()

    @EnvironmentObject var settings: Settings
    var canteens: [Canteen] {
        service.canteens.sorted { lhs, rhs in settings.favoriteCanteens.contains(lhs.name) }
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
