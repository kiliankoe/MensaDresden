import SwiftUI

struct PriceLabel: View {
    var price: Double

    var body: some View {
        Text(String(format: "%.2f€", self.price))
            .font(.system(.caption, design: .rounded))
            .bold()
            .foregroundColor(.white)
            .padding(4)
            .background(Color.gray)
            .cornerRadius(4)
    }
}

struct PriceLabel_Previews: PreviewProvider {
    static var previews: some View {
        PriceLabel(price: 2.8)
    }
}
