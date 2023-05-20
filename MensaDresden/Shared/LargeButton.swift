import SwiftUI

struct LargeButton<Content: View>: View {
    var textColor = Color.white
    var backgroundColor = Color("CampusCardBlue")

    var content: () -> Content

    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                content()
                    .font(.headline)
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
        LargeButton(
            content: {
                HStack {
                    Image(systemName: "hand.thumbsup")
                    Text("Upvote")
                }
            },
            action: {})
    }
}
