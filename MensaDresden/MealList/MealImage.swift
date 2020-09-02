import SwiftUI
import RemoteImage
import EmealKit

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

    var loadingImage: some View {
        ZStack {
            Image("meal_sample")
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .blur(radius: 5, opaque: true)
                .opacity(0.5)
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: self.roundedCorners ? 8 : 0))
            ActivityIndicator()
        }
    }

    func mealImage(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: self.contentMode)
            .frame(width: self.width, height: self.height)
            .clipShape(RoundedRectangle(
                        cornerRadius: self.roundedCorners ? 8 : 0))
    }

    var body: some View {
        if imageURL == Meal.placeholderImageURL {
            placeholderImage
        } else {
            RemoteImage(type: .url(imageURL),
                        errorView: { _ in placeholderImage },
                        imageView: mealImage,
                        loadingView: { loadingImage })
        }
    }
}

struct MealImage_Previews: PreviewProvider {
    static var previews: some View {
        MealImage(imageURL: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m15/202008/247506.jpg")!,
                  width: 400,
                  height: 300,
                  roundedCorners: true,
                  contentMode: .fill)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
