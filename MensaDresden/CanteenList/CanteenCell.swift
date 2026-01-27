import SwiftUI
import MapKit
import EmealKit

struct CanteenCell: View {
    let canteen: Canteen

    @EnvironmentObject var settings: Settings
    @EnvironmentObject var locationManager: LocationManager

    @State private var showingSafari = false

    var isFavorite: Bool {
        settings.favoriteCanteens.contains(canteen.name)
    }

    var distance: Double? {
        guard let userLocation = locationManager.lastLocation,
              let canteenLocation = canteen.location
        else { return nil }
        return userLocation.distance(from: canteenLocation)
    }

    var formattedDistance: String {
        guard let distance = distance else { return "" }
        return Formatter.distanceString(for: Measurement<UnitLength>(value: distance, unit: .meters))
    }

    var body: some View {
        HStack(spacing: 10) {
            ZStack(alignment: .bottomLeading) {
                Image(canteen.name.replacingOccurrences(of: "/", with: ""))
                    .resizable()
                    .frame(width: 130, height: 90)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    .padding(.trailing, 2)
                    .accessibilityIgnoresInvertColors()
                if isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(6)
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: 5, y: -5)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(canteen.name)
                            .font(.headline)
                        Text(canteen.address.split(separator: ", ").last ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "info.circle")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            showingSafari.toggle()
                        }
                }
                
                // Additional information section
                HStack(spacing: 8) {
                    // Opening status
                    OpeningStatusView(canteen: canteen)
                    
                    Spacer()
                    
                    // Distance and compass
                    if settings.canteenSorting == Settings.CanteenSorting.distance.rawValue {
                        HStack(spacing: 4) {
                            if let canteenLocation = canteen.location {
                                CompassView(towards: canteenLocation.coordinate)
                                    .font(.system(size: 13))
                            }
                            Text(formattedDistance)
                                .font(.caption2)
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 2)
            }
        }
        .sheet(isPresented: $showingSafari) {
            SafariView(url: canteen.url)
        }
    }
}

struct CanteenCell_Previews: PreviewProvider {
    static var previews: some View {
        CanteenCell(
            canteen: Canteen(
                id: 1,
                name: "Alte Mensa",
                city: "Dresden",
                address: "Mommsenstr. 13, 01069 Dresden",
                coordinates: [51.02696733929933, 13.726491630077364],
                url: URL(string: "https://studentenwerk-dresden.de")!,
                menu: URL(string: "https://studentenwerk-dresden.de")!
            )
        )
        .environmentObject(Settings())
    }
}
