import Foundation
import SwiftUI
import Combine
import KeychainItem

class Settings: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()

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
            CanteenSorting(rawValue: self.canteenSorting)!
        },
        set: { val in
            if val == .distance {
                UserLocation.shared.start()
            } else {
                UserLocation.shared.stop()
            }
            self.canteenSorting = val.rawValue
        })
    }

    // MARK: Ingredients & Allergens

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
    var autoloadCardnumberBinding: Binding<String> {
        return Binding<String>(
            get: {
                self.autoloadCardnumber ?? ""
            },
            set: { val in
                self.autoloadCardnumber = val
            })
    }

    @KeychainItem(account: "stuwedd.autoload.password")
    var autoloadPassword: String?
    var autoloadPasswordBinding: Binding<String> {
        return Binding<String>(
            get: {
                self.autoloadPassword ?? ""
            },
            set: { val in
                self.autoloadPassword = val
            })
    }

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
}
