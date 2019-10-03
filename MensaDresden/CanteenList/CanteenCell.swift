import SwiftUI
import MapKit

struct CanteenCell: View {
    var canteen: Canteen

    var body: some View {
        HStack {
            Image(canteen.name.replacingOccurrences(of: "/", with: ""))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 100, alignment: .trailing)
                .cornerRadius(8)
                .padding(.trailing, 2)
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
