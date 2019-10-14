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

struct EmealCardView_Previews: PreviewProvider {
    static var previews: some View {
        EmealCardView(amount: 13.37, lastTransaction: 3.5)
    }
}
