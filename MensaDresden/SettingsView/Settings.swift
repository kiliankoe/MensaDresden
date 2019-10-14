import Foundation
import SwiftUI
import Combine
import KeychainItem

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
