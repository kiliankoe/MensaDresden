import SwiftUI
import RemoteImage

struct MealImage: View {
    var imageURL: URL
    var width: CGFloat
    var height: CGFloat?
    var roundedCorners: Bool
    var contentMode: ContentMode

    var placeholderImage: some View {
        Image("meal_placeholder")
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: width)
            .clipShape(RoundedRectangle(cornerRadius: self.roundedCorners ? 8 : 0))
    }

    var body: some View {
        if imageURL == Meal.placeholderImageURL {
            return AnyView(placeholderImage)
        }

        return AnyView(RemoteImage(url: imageURL, errorView: { _ in
            self.placeholderImage
        }, imageView: { image in
            image
                .resizable()
                .aspectRatio(contentMode: self.contentMode)
                .frame(width: self.width, height: self.height)
                .clipShape(RoundedRectangle(cornerRadius: self.roundedCorners ? 8 : 0))
        }, loadingView: {
            self.placeholderImage
                .opacity(0.5)
        }))
    }
}

struct MealImage_Previews: PreviewProvider {
    static var previews: some View {
        MealImage(imageURL: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/201909/233593.jpg")!,
                  width: 130,
                  height: 95,
                  roundedCorners: true,
                  contentMode: .fill)
    }
}
