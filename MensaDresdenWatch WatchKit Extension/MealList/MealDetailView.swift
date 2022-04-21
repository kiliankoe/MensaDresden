import SwiftUI
import EmealKit

struct MealDetailView: View {
    let meal: Meal

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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                if meal.isDinner {
                    Image(systemName: "moon.fill")
                        .font(.headline)
                        .foregroundColor(.yellow)
                        .accessibility(label: Text("meal.dinner"))
                }

                ForEach(meal.diet, id: \.self) { diet in
                    Text(LocalizedStringKey(String(describing: diet)))
                        .padding(.horizontal)
                }

                Text(meal.allergenStrippedTitle)
                    .padding(.horizontal)
                
                ZStack(alignment: .bottomLeading) {
                    if settings.priceTypeIsStudent {
                        PriceLabel(price: meal.prices?.students, shadow: 2)
                    } else {
                        PriceLabel(price: meal.prices?.employees, shadow: 2)
                    }
                }

                if !passesFilters {
                    Text("meal.ingredient-warning")
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                HStack {
                    ForEach(meal.ingredients, id: \.rawValue) { ingredient in
                        Text(ingredient.emoji)
                            .font(.system(size: 30))
                            .accessibility(label: Text(LocalizedStringKey(ingredient.rawValue)))
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    ForEach(meal.notes, id: \.self) { note in
                        Text(note)
                            .font(.caption)
                    }
                }.padding(.horizontal)
            }
        }.navigationTitle(meal.category.uppercased())
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyView()
            MealDetailView(meal: Meal.examples[0])
                .environmentObject(Settings())
        }
        .accentColor(.green)
    }
}
