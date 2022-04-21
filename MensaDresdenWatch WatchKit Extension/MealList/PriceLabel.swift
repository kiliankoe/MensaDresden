import SwiftUI

struct PriceLabel: View {
    let price: Double?
    var priceText: String? {
        guard let price = price else { return nil }
        return Formatter.priceString(for: price)
    }

    var shadow: CGFloat = 0

    var body: some View {
        if let priceText = priceText {
            Text(priceText)
                .font(.system(.body, design: .rounded))
                .bold()
                .foregroundColor(.white)
                .padding(.vertical, 3)
                .padding(.leading, 8)
                .padding(.trailing, 15)
                .background(
                    PriceLabelShape()
                        .foregroundColor(.emealGreen)
                        .shadow(radius: shadow)
                )
        }
    }
}

private struct PriceLabelShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width - 8, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: rect.origin)
        return path
    }
}

struct PriceLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PriceLabel(price: nil)
            PriceLabel(price: 2.8, shadow: 2)
            PriceLabel(price: 15, shadow: 2)
            PriceLabel(price: -1.5)
            PriceLabel(price: 1337)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
