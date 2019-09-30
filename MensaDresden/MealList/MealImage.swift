import SwiftUI
import RemoteImage

struct MealImage: View {
    var imageURL: URL

    var body: some View {
        RemoteImage(url: imageURL, errorView: { error in
            MealImageText(text: error.localizedDescription)
        }, imageView: { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .frame(width: 150, height: 100, alignment: .leading)
        }) {
            MealImageText(text: "Image loading...")
        }
    }
}

struct MealImageText: View {
    var text: String

    var body: some View {
        HStack {
            Spacer()
            Text(self.text)
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
        }.frame(width: 150, height: 100, alignment: .leading)
    }
}

struct MealImage_Previews: PreviewProvider {
    static var previews: some View {
        MealImage(imageURL: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/201909/233593.jpg")!)
    }
}
