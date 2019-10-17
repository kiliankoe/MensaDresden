import SwiftUI
import MapKit
import CoreNFC

struct CanteenListView: View {
    @EnvironmentObject var service: OpenMensaService
    @EnvironmentObject var deviceOrientation: DeviceOrientation
    @EnvironmentObject var settings: Settings

    @ObservedObject var userLocation = UserLocation.shared

    var canteens: [Canteen] {
        let favorites = service.canteens.filter { settings.favoriteCanteens.contains($0.name) }
        var nonFavorites = service.canteens.filter { !settings.favoriteCanteens.contains($0.name) }

        let sortedFavorites = favorites.sorted { (lhs, rhs) in
            // Force Unwrap should be safe here, since the list was just filtered based on favorites.
            settings.favoriteCanteens.firstIndex(of: lhs.name)! < settings.favoriteCanteens.firstIndex(of: rhs.name)!
        }

        // FIXME: The entire location handling here is utterly... ugh >.<
        switch settings.canteenSorting {
        case Settings.CanteenSorting.alphabetical.rawValue:
            nonFavorites.sort { $0.name < $1.name }
        case Settings.CanteenSorting.distance.rawValue:
            if let location = userLocation.lastLocation {
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
            Group {
                List(canteens) { canteen in
                    NavigationLink(destination: MealListView(service: self.service, canteen: canteen)) {
                        CanteenCell(canteen: canteen)
                    }
                }
                .navigationBarTitle("Canteens")
                VStack {
                    Text("🍲 Bon appétit!")
                        .font(.title)
                    if !deviceOrientation.isLandscape {
                        Text("Swipe from the left to open the list of canteens.")
                    }
                }
            }
        }
        .onAppear {
            self.service.fetchCanteens()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()

        return CanteenListView()
            .environmentObject(settings)
            .environmentObject(OpenMensaService(settings: settings))
    }
}
