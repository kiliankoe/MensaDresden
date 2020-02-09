import SwiftUI
import RemoteImage
import EmealKit

struct MealCell: View {
    var meal: Meal

    @EnvironmentObject var settings: Settings

    var body: some View {
        HStack {
            MealImage(imageURL: meal.image, width: 130, height: 95, roundedCorners: true, contentMode: .fill)

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
                    if settings.priceTypeIsStudent {
                        PriceLabel(price: meal.prices?.students)
                    } else {
                        PriceLabel(price: meal.prices?.employees)
                    }

                    if meal.isDinner {
                        Spacer()
                        Image(systemName: "moon.fill")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                }.padding(.top, 5)
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
