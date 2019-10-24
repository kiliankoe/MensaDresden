import SwiftUI

struct PriceLabel: View {
    var price: Double?
    var priceText: String? {
        guard let price = price else { return nil }
        return Formatter.priceString(for: price)
    }

    var body: AnyView {
        if let priceText = priceText {
            return AnyView(
                Text(priceText)
                    .font(.system(.caption, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.gray)
                    .cornerRadius(4)
            )
        } else {
            return AnyView(Text(""))
        }
    }
}

struct PriceLabel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PriceLabel(price: nil)
            PriceLabel(price: 2.8)
            PriceLabel(price: 15)
            PriceLabel(price: -1.5)
            PriceLabel(price: 1337)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
