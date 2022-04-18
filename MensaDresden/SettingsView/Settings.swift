import Foundation
import SwiftUI
import Combine
import KeychainItem
import EmealKit

class Settings: ObservableObject {
    // MARK: Favorites

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

    // MARK: Price Type

    enum PriceType: String, CaseIterable {
        case student
        case employee
    }

    @UserDefault("priceType", defaultValue: PriceType.student.rawValue)
    var priceType: PriceType.RawValue
    var priceTypeBinding: Binding<PriceType> {
        return Binding<PriceType>(
            get: {
                PriceType(rawValue: self.priceType)!
            },
            set: { val in
                self.priceType = val.rawValue
            })
    }
    var priceTypeIsStudent: Bool {
        priceType == PriceType.student.rawValue
    }

    // MARK: Canteen Sorting

    enum CanteenSorting: String, CaseIterable {
        case `default`
        case distance
        case alphabetical
    }

    @UserDefault("canteenSorting", defaultValue: CanteenSorting.default.rawValue)
    var canteenSorting: CanteenSorting.RawValue
    var canteenSortingBinding: Binding<CanteenSorting> {
        return Binding<CanteenSorting>(
        get: {
            CanteenSorting(rawValue: self.canteenSorting) ?? .default
        },
        set: { val in
            if val == .distance {
                LocationManager.shared.start()
            } else {
                LocationManager.shared.stop()
            }
            self.canteenSorting = val.rawValue
            self.objectWillChange.send()
        })
    }

    // MARK: Ingredients & Allergens

    enum DietType: String, CaseIterable, Identifiable {
        case all
        case vegetarian
        case vegan

        var id: String {
            self.rawValue
        }
    }

    @UserDefault("userDiet", defaultValue: DietType.all.rawValue)
    var userDiet: DietType.RawValue
    var userDietBinding: Binding<String> {
        Binding<String>(
            get: {
                self.userDiet
            },
            set: {
                self.userDiet = $0
            }
        )
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

    // MARK: Autoload

    @KeychainItem(account: "stuwedd.autoload.cardnumber")
    var autoloadCardnumber: String?

    @KeychainItem(account: "stuwedd.autoload.password")
    var autoloadPassword: String?

    var areAutoloadCredentialsAvailable: Bool {
        switch (autoloadCardnumber, autoloadPassword) {
        case (nil, _), (_, nil):
            return false
        case ("", _), (_, ""):
            return false
        default:
            return true
        }
    }

    func resetAll() {
        self.favoriteCanteens = []
        self.priceType = PriceType.student.rawValue
        self.canteenSorting = CanteenSorting.default.rawValue
        self.userDiet = DietType.all.rawValue
        self.ingredientBlacklist.reset()
        self.allergenBlacklist.reset()
        self.autoloadCardnumber = nil
        self.autoloadPassword = nil
    }
}
