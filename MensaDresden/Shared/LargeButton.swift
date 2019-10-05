import SwiftUI

struct LargeButton: View {
    var text: String
    var textColor = Color.white
    var backgroundColor = Color.blue

    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(LocalizedStringKey(text))
                    .font(.headline)
                    .bold()
                    .foregroundColor(textColor)
                    .padding()
                Spacer()
            }

        }
        .background(backgroundColor)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct LargeButton_Previews: PreviewProvider {
    static var previews: some View {
        LargeButton(text: "Some Text", action: {})
    }
}
