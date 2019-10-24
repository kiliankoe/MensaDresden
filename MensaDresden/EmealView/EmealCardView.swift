import SwiftUI

struct EmealCardView: View {
    var amount: Double
    var lastTransaction: Double
    var lastScan: Date?

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

struct EmealCardView2: View {
    var amount: Double
    var lastTransaction: Double

    var backgroundCard: some View {
        Rectangle()
            .foregroundColor(.emealGreen)
            .aspectRatio(1.55, contentMode: .fit)
            .cornerRadius(10)
            .shadow(radius: 8)
    }

    var emealText: some View {
        (Text("E").bold() + Text("meal").bold().italic())
            .font(.custom("Verdana", size: 60))
            .frame(width: 210, height: 50)
            .foregroundColor(.white)
            .rotationEffect(.radians(.pi * 1.5))
            .frame(width: 50, height: 210)
            .opacity(0.35)
    }

    var balanceText: some View {
        VStack(alignment: .leading) {
            Text("emeal.balance")
                .font(Font.headline.smallCaps())
                .foregroundColor(.white)
            Text("\(amount, specifier: "%.2f")€")
                .font(.system(size: 50))
                .foregroundColor(.white)
                .padding(.bottom, UIScreen.main.bounds.height * 0.04)
        }
    }

    var lastTransactionText: some View {
        VStack(alignment: .leading) {
            Text("emeal.last-transaction")
                .font(Font.subheadline.smallCaps())
                .foregroundColor(.white)
            Text("\(lastTransaction, specifier: "%.2f")€")
                .font(.title)
                .foregroundColor(.white)
        }
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ZStack(alignment: .topLeading) {
                ZStack(alignment: .trailing) {
                    backgroundCard
                    emealText
                }
                balanceText
                    .offset(x: 20, y: 30)
            }
            lastTransactionText
                .offset(x: 20, y: -30)
        }
    }
}

extension Color {
    static var emealGreen: Color {
        Color(red: 133/255.0, green: 187/255.0, blue: 37/255.0)
    }
}

struct EmealCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmealCardView(amount: 13.37, lastTransaction: 3.5, lastScan: Date())
                .previewLayout(.sizeThatFits)
            EmealCardView(amount: 13.37, lastTransaction: 3.5, lastScan: nil)
            .previewLayout(.sizeThatFits)
            EmealCardView2(amount: 13.37, lastTransaction: 3.5)
                .previewLayout(.sizeThatFits)
//            EmealCardView(amount: 13.37, lastTransaction: 3.5, lastScan: Date())
//                .previewDevice("iPhone SE")
//            EmealCardView(amount: 13.37, lastTransaction: 3.5, lastScan: nil)
//                .previewDevice("iPhone 11 Pro")
//            EmealCardView(amount: 13.37, lastTransaction: 3.5, lastScan: Date())
//                .previewDevice("iPad Pro (12.9-inch)")
        }
        .padding()
    }
}
