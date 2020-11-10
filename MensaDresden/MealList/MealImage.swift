import SwiftUI
import RemoteImage
import EmealKit

struct MealImage: View {
    var meal: Meal
    var width: CGFloat?
    var height: CGFloat?
    var contentMode: ContentMode

    var placeholderImage: some View {
        Image("meal_placeholder")
            .resizable()
            .aspectRatio(contentMode: contentMode)
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
        if meal.imageIsPlaceholder {
            ZStack {
                Color.gray.opacity(0.1)
                if let emoji = meal.emoji {
                    Text(emoji)
                        .font(.system(size: 80))
                } else {
                    placeholderImage
                        .frame(width: 100)
                }
            }
            .frame(maxHeight: 150)
            .accessibility(hidden: true)
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
                  contentMode: .fill)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
