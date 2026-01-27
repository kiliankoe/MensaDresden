import SwiftUI
import EmealKit

struct MealCell: View {
    var meal: Meal

    @EnvironmentObject var settings: Settings

    var passesFilters: Bool {
        let diet = Settings.DietType(rawValue: settings.userDiet)!
        switch diet {
        case .vegan:
            if !meal.diet.contains(.vegan) {
                return false
            }
        case .vegetarian:
            if !meal.diet.contains(.vegetarian) && !meal.diet.contains(.vegan) {
                return false
            }
        case .all:
            break
        }
        return !meal.contains(unwantedIngredients: settings.ingredientBlacklist.storage,
                              unwantedAllergens: settings.allergenBlacklist.storage)
    }

    private var isPlaceholder: Bool {
        meal.imageIsPlaceholder && meal.emoji == nil
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.category)
                    .font(Font.caption.smallCaps())
                    .foregroundColor(.gray)
                
                Text(meal.allergenStrippedTitle)
                    .lineLimit(5)
                
                ForEach(meal.diet, id: \.self) { diet in
                    Text(LocalizedStringKey(String(describing: diet)))
                        .font(Font.caption.smallCaps())
                        .bold()
                        .foregroundColor(.green)
                        .lineLimit(1)
                }
                
                HStack(spacing: 8) {
                    
                    ZStack(alignment: .bottomLeading) {
                        if settings.priceTypeIsStudent {
                            PriceLabel(price: meal.prices?.students, shadow: 2)
                                .padding(.bottom, 4)
                        } else {
                            PriceLabel(price: meal.prices?.employees, shadow: 2)
                                .padding(.bottom, 4)
                        }
                    }
                    
                    HStack {
                        ForEach(meal.ingredients, id: \.rawValue) { ingredient in
                            Text(ingredient.emoji)
                                .font(.system(size: 20))
                                .accessibility(label: Text(LocalizedStringKey(ingredient.rawValue)))
                        }
                        if meal.isDinner {
                            Spacer()
                            Image(systemName: "moon.fill")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .accessibility(label: Text("meal.dinner"))
                        }
                    }
                }.padding(.top, 5)
            }
            .saturation((meal.isSoldOut ?? false) ? 0.2 : 1)
            .opacity((meal.isSoldOut ?? false) ? 0.5 : 1)
            if (meal.isSoldOut ?? false) {
                Text("meal.sold-out")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.red)
                    .padding()
                    .background(.black)
                    .border(.red, width: 3)
                    .opacity(0.8)
                    .rotationEffect(.degrees(-10))
            }
        }
        .compositingGroup()
        .opacity(passesFilters ? 1.0 : 0.5)
    }
}

struct MealCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MealCell(meal: Meal.examples[0])

            MealCell(meal: Meal.examples[1])
                .background(Color.black)
                .environment(\.colorScheme, .dark)

            MealCell(meal: Meal.examples[2])
                .environment(\.sizeCategory, .extraSmall)

            MealCell(meal: Meal.examples[1])
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
        .environmentObject(Settings())
        .previewLayout(.sizeThatFits)
    }
}
