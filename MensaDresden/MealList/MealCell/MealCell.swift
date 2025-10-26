import SwiftUI
import EmealKit
import Translation

struct MealCell: View {
    var meal: Meal

    @EnvironmentObject var settings: Settings
    @State private var translatedText: String?

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
            HStack(spacing: 8) {
                ZStack(alignment: .bottomLeading) {
                    MealImage(meal: meal,
                              width: 130,
                              height: 95,
                              contentMode: .fill)
                        .frame(width: 130, height: 95)
                    if settings.priceTypeIsStudent {
                        PriceLabel(price: meal.prices?.students, shadow: 2)
                            .padding(.bottom, 4)
                    } else {
                        PriceLabel(price: meal.prices?.employees, shadow: 2)
                            .padding(.bottom, 4)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 4) {
                        Text(meal.category)
                            .font(Font.caption.smallCaps())
                            .foregroundColor(.gray)

                    Group {
                        if #available(iOS 18.0, *), settings.translateMeals, TranslationService.shared.shouldTranslate {
                            Text(translatedText ?? meal.allergenStrippedTitle)
                                .lineLimit(5)
                                .translationTask(
                                    TranslationSession.Configuration(
                                        source: Locale.Language(identifier: "de"),
                                        target: Locale.current.language
                                    )
                                ) { session in
                                    Task { @MainActor in
                                        do {
                                            let response = try await session.translate(meal.allergenStrippedTitle)
                                            translatedText = response.targetText
                                        } catch {
                                            // Translation failed, keep original text
                                        }
                                    }
                                }
                        } else {
                            Text(meal.allergenStrippedTitle)
                                .lineLimit(5)
                        }
                    }

                    ForEach(meal.diet, id: \.self) { diet in
                        Text(LocalizedStringKey(String(describing: diet)))
                            .font(Font.caption.smallCaps())
                            .bold()
                            .foregroundColor(.green)
                            .lineLimit(1)
                    }

                    HStack {
                        ForEach(meal.ingredients, id: \.rawValue) { ingredient in
                            Text(ingredient.emoji)
                                .font(.system(size: 20))
                                .accessibility(label: Text(LocalizedStringKey(ingredient.rawValue)))
                                .accessibilityIgnoresInvertColors()
                        }
                        if meal.isDinner {
                            Spacer()
                            Image(systemName: "moon.fill")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .accessibility(label: Text("meal.dinner"))
                        }
                    }.padding(.top, 5)
                }
            }
            if (meal.isSoldOut ?? false) {
                Text("meal.sold-out")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.red)
                    .padding()
                    .border(.red, width: 3)
                    .opacity(0.6)
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
