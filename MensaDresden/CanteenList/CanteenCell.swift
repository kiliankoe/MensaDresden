import SwiftUI
import MapKit
import EmealKit

struct CanteenCell: View {
    var canteen: Canteen

    @EnvironmentObject var settings: Settings

    var isFavorite: Bool {
        settings.favoriteCanteens.contains(canteen.name)
    }

    var body: some View {
        HStack {
            ZStack(alignment: .bottomLeading) {
                Image(canteen.name.replacingOccurrences(of: "/", with: ""))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130, height: 90, alignment: .trailing)
                    .cornerRadius(8)
                    .padding(.trailing, 2)
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
            VStack(alignment: .leading) {
                Text(canteen.name)
                    .font(.headline)
                Text(canteen.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
        }
    }
}

struct CanteenCell_Previews: PreviewProvider {
    static var previews: some View {
        CanteenCell(canteen: Canteen(id: 1,
                                     name: "Alte Mensa",
                                     city: "Dresden",
                                     address: "Mommsenstr. 13, 01069 Dresden",
                                     coordinates: [51.02696733929933, 13.726491630077364],
                                     url: URL(string: "https://studentenwerk-dresden.de")!,
                                     menu: URL(string: "https://studentenwerk-dresden.de")!))
    }
}
