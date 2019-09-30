import SwiftUI
import MapKit

struct CanteenCell: View {
    var canteen: Canteen

    var body: some View {
        HStack {
            MapView(coordinate: canteen.coordinate)
                .frame(width: 150, height: 100, alignment: .trailing)
                .cornerRadius(8)
                .padding(.trailing, 2)
            VStack(alignment: .leading) {
                Text(canteen.name)
                    .font(.headline)
                Text(canteen.address)
                    .font(.subheadline)
            }
        }
    }
}

struct CanteenCell_Previews: PreviewProvider {
    static var previews: some View {
        CanteenCell(canteen: Canteen(id: 1, name: "Alte Mensa", address: "Mommsenstr. 13, 01069 Dresden",
                                     coordinate: CLLocationCoordinate2D(latitude: 51.02696733929933, longitude: 13.726491630077364)))
    }
}
