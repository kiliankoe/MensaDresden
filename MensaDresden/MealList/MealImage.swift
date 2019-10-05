import SwiftUI
import RemoteImage

struct MealImage: View {
    var imageURL: URL
    var size: CGFloat
    var roundedCorners: Bool

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        if imageURL == Meal.placeholderImageURL && colorScheme == .dark {
            return AnyView(Image("meal_placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: self.size))
        }
        return AnyView(RemoteImage(url: imageURL, errorView: { error in
            MealImageText(text: error.localizedDescription)
        }, imageView: { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(self.roundedCorners ? 8 : 0)
                .frame(width: self.size)
        }, loadingView: {
            MealImageText(text: "Image loading...")
        }))
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
        MealImage(imageURL: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/201909/233593.jpg")!,
                  size: 500,
                  roundedCorners: true)
    }
}
