import SwiftUI
import RemoteImage

struct MealCell: View {
    var meal: Meal

    @EnvironmentObject var settings: Settings

    var body: some View {
        HStack {
            MealImage(imageURL: meal.image, size: 150, roundedCorners: true)

            VStack(alignment: .leading) {
                HStack {
                    Text(meal.category)
                        .font(Font.caption.smallCaps())
                        .foregroundColor(.gray)
                    Spacer()
                    ForEach(meal.diet, id: \.self) { diet in
                        Text(LocalizedStringKey(String(describing: diet)))
                            .font(Font.caption.smallCaps())
                            .bold()
                            .foregroundColor(.green)
                            .lineLimit(1)
                    }
                }

                Text(meal.name)
                    .lineLimit(3)
                    .padding(.top, 1)
                    .layoutPriority(1)

                HStack {
                    PriceLabel(price: meal.prices?.students)
                    PriceLabel(price: meal.prices?.employees)
                }
            }
        }
        .opacity(meal.contains(unwantedIngredients: settings.ingredientBlacklist.storage, unwantedAllergens: settings.allergenBlacklist.storage) ? 0.3 : 1.0)
    }
}

struct MealCell_Previews: PreviewProvider {
    static var previews: some View {
        MealCell(meal: Meal.example)
    }
}
