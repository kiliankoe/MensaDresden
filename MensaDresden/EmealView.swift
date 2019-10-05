import SwiftUI

struct EmealView: View {
    @State var amount: Double = 13.37
    @State var lastTransaction = 3.5

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Image("emeal_empty")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .padding(.bottom)
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

            Button(action: {

            }) {
                Text("Scan Mensa Card")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }.padding()
    }
}

struct EmealView_Previews: PreviewProvider {
    static var previews: some View {
        EmealView()
    }
}
