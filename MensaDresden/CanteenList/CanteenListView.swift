import SwiftUI
import EmealKit
import os.log

struct CanteenListView: View {
    @EnvironmentObject var api: API
    @EnvironmentObject var deviceOrientation: DeviceOrientation
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var locationManager: LocationManager

    @State private var searchQuery = ""

    var filteredCanteens: LoadingResult<[Canteen]> {
        switch api.canteens {
        case .success(let canteens):
            if searchQuery.isEmpty {
                return api.canteens
            }
            Logger.breadcrumb.info("Filtering canteens based on query: \(searchQuery)")
            let filtered = canteens
                .filter { canteen in
                    if let possibleId = CanteenId.from(name: searchQuery) {
                        return canteen.id == possibleId.rawValue
                    }
                    return canteen.name.localizedCaseInsensitiveContains(searchQuery) || canteen.address.localizedCaseInsensitiveContains(searchQuery)
                }
            return .success(filtered)
        default:
            return api.canteens
        }
    }

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
            LoadingListView(result: filteredCanteens,
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
            .toolbar {
                ToolbarItem {
                    Menu(
                        content: {
                            Button(action: {
                                settings.canteenSortingBinding.wrappedValue = .default
                            }) {
                                Label(L10n.default, systemImage: "list.bullet")
                            }

                            Button(action: {
                                settings.canteenSortingBinding.wrappedValue = .distance
                            }) {
                                Label(L10n.distance, systemImage: "location")
                            }

                            Button(action: {
                                settings.canteenSortingBinding.wrappedValue = .alphabetical
                            }) {
                                Label(L10n.alphabetical, systemImage: "abc")
                            }
                        },
                        label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    )
                }
            }
            .searchable(text: $searchQuery)
            VStack {
                Text("ipad.bon-appetit")
                    .font(.title)
                if !deviceOrientation.isLandscape {
                    Text("ipad.swipe-hint")
                }
            }
        }
        .onAppear {
            Logger.breadcrumb.info("Appear CanteenListView")
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
