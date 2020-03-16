import SwiftUI

struct EmealCardView: View {
    @Binding var amount: Double
    @Binding var lastTransaction: Double
    @Binding var lastScan: Date?

    var body: some View {
        ZStack(alignment: .leading) {
            Image("emeal_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 10)

            VStack(alignment: .leading) {
                Text("emeal.balance")
                    .font(Font.headline.smallCaps())
                    .foregroundColor(.white)
                Text("\(amount, specifier: "%.2f")€")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.02)

                Text("emeal.last-transaction")
                    .font(Font.subheadline.smallCaps())
                    .foregroundColor(.white)
                Text("\(lastTransaction, specifier: "%.2f")€")
                    .font(.title)
                    .foregroundColor(.white)

                if lastScan != nil {
                    Text("emeal.last-scanned")
                        .font(Font.caption.smallCaps())
                        .foregroundColor(.white)
                        .padding(.top, UIScreen.main.bounds.height * 0.01)
                    Text(Formatter.string(for: lastScan!, dateStyle: .medium, timeStyle: .short))
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }.offset(x: 20, y: 0)
        }
    }
}

struct EmealCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmealCardView(amount: .constant(13.37),
                          lastTransaction: .constant(3.5),
                          lastScan: .constant(Date()))
                .previewLayout(.sizeThatFits)
            EmealCardView(amount: .constant(13.37),
                          lastTransaction: .constant(3.5),
                          lastScan: .constant(nil))
            .previewLayout(.sizeThatFits)
        }
        .padding()
    }
}
