import SwiftUI

struct EmealCardView: View {
    var amount: Double
    var lastTransaction: Double

    var body: some View {
        ZStack(alignment: .leading) {
            Image("emeal_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 10)

            VStack(alignment: .leading) {
                Text("Balance")
                    .font(Font.headline.smallCaps())
                    .foregroundColor(.white)
                Text("\(amount, specifier: "%.2f")€")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.04)

                Text("Last Transaction")
                    .font(Font.subheadline.smallCaps())
                    .foregroundColor(.white)
                Text("\(lastTransaction, specifier: "%.2f")€")
                    .font(.title)
                    .foregroundColor(.white)
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
            Text("Balance")
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
            Text("Last Transaction")
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
            EmealCardView(amount: 13.37, lastTransaction: 3.5)
                .previewLayout(.sizeThatFits)
            EmealCardView2(amount: 13.37, lastTransaction: 3.5)
                .previewLayout(.sizeThatFits)
//            EmealCardView(amount: 13.37, lastTransaction: 3.5)
//                .previewDevice("iPhone SE")
//            EmealCardView(amount: 13.37, lastTransaction: 3.5)
//                .previewDevice("iPhone 11 Pro")
        }
        .padding()
    }
}
