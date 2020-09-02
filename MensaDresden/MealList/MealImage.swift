import SwiftUI
import RemoteImage
import EmealKit

struct MealImage: View {
    var meal: Meal
    var width: CGFloat
    var height: CGFloat?
    var roundedCorners: Bool
    var contentMode: ContentMode

    var placeholderImage: some View {
        Image("meal_placeholder")
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: width)
    }

    var loadingImage: some View {
        ZStack {
            Image("meal_sample")
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .blur(radius: 5, opaque: true)
                .opacity(0.5)
                .frame(width: width, height: height)
            ProgressView()
        }
    }

    func mealImage(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: self.contentMode)
            .frame(width: self.width)
    }

    var body: some View {
        if meal.imageIsPlaceholder, let emoji = meal.emoji {
            ZStack {
                Color.gray.opacity(0.1)
                Text(emoji)
                    .font(.system(size: 80))
            }
            .frame(maxHeight: 400)
            .accessibility(hidden: true)
        } else if meal.imageIsPlaceholder {
            placeholderImage
        } else {
            RemoteImage(type: .url(meal.image),
                        errorView: { _ in placeholderImage },
                        imageView: mealImage,
                        loadingView: { loadingImage })
        }
    }
}

struct MealImage_Previews: PreviewProvider {
    static var previews: some View {
        MealImage(meal: Meal.examples[0],
                  width: 400,
                  height: 300,
                  roundedCorners: true,
                  contentMode: .fill)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
