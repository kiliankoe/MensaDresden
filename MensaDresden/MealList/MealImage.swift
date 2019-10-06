import SwiftUI
import RemoteImage

struct MealImage: View {
    var imageURL: URL
    var width: CGFloat
    var height: CGFloat?
    var roundedCorners: Bool
    var contentMode: ContentMode

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        if imageURL == Meal.placeholderImageURL && colorScheme == .dark {
            return AnyView(Image("meal_placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: self.width))
        }
        return AnyView(RemoteImage(url: imageURL, errorView: { error in
            MealImageText(text: error.localizedDescription)
        }, imageView: { image in
            image
                .resizable()
                .aspectRatio(contentMode: self.contentMode)
                .frame(width: self.width, height: self.height)
                .clipShape(RoundedRectangle(cornerRadius: self.roundedCorners ? 8 : 0))
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
        }.frame(width: 130, height: 95, alignment: .leading)
    }
}

struct MealImage_Previews: PreviewProvider {
    static var previews: some View {
        MealImage(imageURL: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/201909/233593.jpg")!,
                  width: 500,
                  roundedCorners: true,
                  contentMode: .fill)
    }
}
