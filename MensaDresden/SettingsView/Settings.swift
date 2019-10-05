import Foundation
import Combine

class Settings: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()

    @UserDefault("favoriteCanteens", defaultValue: [])
    var favoriteCanteens: [String] {
        didSet {
            self.objectWillChange.send()
        }
    }

    func toggleFavorite(canteen: String) {
        if let idx = favoriteCanteens.firstIndex(of: canteen) {
            favoriteCanteens.remove(at: idx)
        } else {
            favoriteCanteens.append(canteen)
        }
    }

    var ingredientBlacklist = BlacklistBinding<Ingredient>(userDefaultsKey: "ingredientBlacklist") {
        didSet {
            self.objectWillChange.send()
        }
    }

    var allergenBlacklist = BlacklistBinding<Allergen>(userDefaultsKey: "allergenBlacklist") {
        didSet {
            self.objectWillChange.send()
        }
    }
}
