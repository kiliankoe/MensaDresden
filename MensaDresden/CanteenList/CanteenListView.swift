import SwiftUI
import EmealKit

struct CanteenListView: View {
    @EnvironmentObject var api: API
    @EnvironmentObject var deviceOrientation: DeviceOrientation
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var locationManager: LocationManager

    func sort(canteens: [Canteen]) -> [Canteen] {
        let favorites = canteens.filter { settings.favoriteCanteens.contains($0.name) }
        var nonFavorites = canteens.filter { !settings.favoriteCanteens.contains($0.name) }

        let sortedFavorites = favorites.sorted { (lhs, rhs) in
            // Force Unwrap should be safe here, since the list was just filtered based on favorites.
            settings.favoriteCanteens.firstIndex(of: lhs.name)! < settings.favoriteCanteens.firstIndex(of: rhs.name)!
        }

        // FIXME: The entire location handling here is utterly... ugh >.<
        switch settings.canteenSorting {
        case Settings.CanteenSorting.alphabetical.rawValue:
            nonFavorites.sort { $0.name < $1.name }
        case Settings.CanteenSorting.distance.rawValue:
            if let location = locationManager.lastLocation {
                nonFavorites.sort { lhs, rhs in
                    guard let lhsLoc = lhs.location,
                        let rhsLoc = rhs.location else {
                            return lhs.name < rhs.name
                    }
                    let lhsDistance = location.distance(from: lhsLoc)
                    let rhsDistance = location.distance(from: rhsLoc)
                    return lhsDistance < rhsDistance
                }
            }
        default:
            break
        }

        return sortedFavorites + nonFavorites
    }

    var body: some View {
        NavigationView {
            LoadingListView(result: api.canteens,
                            noDataMessage: "canteens.no-data",
                            retryAction: { Task { await self.api.loadCanteens() } },
                            showRetryOnNoData: true,
                            listView: { canteens in
                                List(self.sort(canteens: canteens)) { canteen in
                                    NavigationLink(destination: MealListView(canteen: canteen)) {
                                        CanteenCell(canteen: canteen)
                                    }
                                }
                                .listStyle(PlainListStyle())
                            }
            )
            .navigationBarTitle("canteens.nav")
            VStack {
                Text("ipad.bon-appetit")
                    .font(.title)
                if !deviceOrientation.isLandscape {
                    Text("ipad.swipe-hint")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()

        return CanteenListView()
            .environmentObject(settings)
            .environmentObject(API())
    }
}
