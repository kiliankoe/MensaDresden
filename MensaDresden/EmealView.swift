import SwiftUI

struct EmealView: View {
    var body: some View {
        VStack {
            Image("emeal")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width)
                .padding()
            Spacer()
        }
    }
}

struct EmealView_Previews: PreviewProvider {
    static var previews: some View {
        EmealView()
    }
}
