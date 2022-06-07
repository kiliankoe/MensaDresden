import Foundation
import EmealKit

extension Meal {
    var allergenStrippedTitle: String {
        self.name.replacingOccurrences(of: #" (\((?:[A-N]\d?(?:, )?)+\))"#, with: "", options: .regularExpression)
    }

    func isIncompatible(withDiet diet: Settings.DietType, ingredients: [Ingredient], allergens: [Allergen]) -> Bool {
        switch diet {
        case .all:
            break
        case .vegan:
            guard self.diet.contains(.vegan) else {
                return true
            }
        case .vegetarian:
            guard self.diet.contains(.vegetarian) || self.diet.contains(.vegan) else {
                return true
            }
        }

        return contains(unwantedIngredients: ingredients, unwantedAllergens: allergens)
    }
}
