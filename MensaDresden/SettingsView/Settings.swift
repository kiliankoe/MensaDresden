import Foundation
import SwiftUI
import Combine
import KeychainItem
import EmealKit
import os.log
import KeychainAccess

extension Keychain {
    var autoloadCardnumber: String? {
        get {
            self["autoloadCardnumber"]
        }
        set {
            self["autoloadCardnumber"] = newValue
        }
    }

    var autoloadPassword: String? {
        get {
            self["autoloadPassword"]
        }
        set {
            self["autoloadPassword"] = newValue
        }
    }
}

class Settings: ObservableObject {
    let keychain = Keychain(service: "io.kilian.mensadresden")

    init() {
        Self.migrateSettingsToAppGroup()

        $autoloadCardnumber
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                if let newValue {
                    self?.keychain.autoloadCardnumber = newValue
                }
            }
            .store(in: &cancelSet)

        $autoloadPassword
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                if let newValue {
                    self?.keychain.autoloadPassword = newValue
                }
            }
            .store(in: &cancelSet)

        migrateAutoloadCredentials()

        // Initialize UI with values from keychain
        if let cardnumber = keychain.autoloadCardnumber {
            self.autoloadCardnumber = cardnumber
        }
        if let password = keychain.autoloadPassword {
            self.autoloadPassword = password
        }
    }

    private var cancelSet: Set<AnyCancellable> = []

    // MARK: Migrations

    private static func migrateSettingsToAppGroup() {
        let migratedKey = "appSettingsMigratedToAppGroup"
        defer { UserDefaults.standard.setValue(true, forKey: migratedKey) }
        guard !UserDefaults.standard.bool(forKey: migratedKey) else { return }

        let defaults = [
            "favoriteCanteens",
            "priceType",
            "canteenSorting",
            "userDiet",
            "ingredientBlacklist",
            "allergenBlacklist"
        ]

        for key in defaults {
            if let value = UserDefaults.standard.object(forKey: key) {
                UserDefaults.mensaDresdenGroup.set(value, forKey: key)
                Logger.settings.info("Migrated \(key) to app group defaults")
            }
        }
    }

    // Potentially migrate old credentials from old keychain wrapper
    private func migrateAutoloadCredentials() {
        let migratedKey = "autoloadCredentialsMigratedFromKeychainItem"
        defer { UserDefaults.standard.setValue(true, forKey: migratedKey) }
        guard !UserDefaults.standard.bool(forKey: migratedKey) else { return }

        if let cardnumber = legacyAutoloadCardnumber {
            self.keychain.autoloadCardnumber = cardnumber
        }
        if let password = legacyAutoloadPassword {
            self.keychain.autoloadPassword = password
        }
    }

    // MARK: Favorites

    @UserDefault("favoriteCanteens", defaultValue: [], suite: .mensaDresdenGroup)
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
                self.objectWillChange.send()
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
                self.objectWillChange.send()
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

    // These two are no longer used (KeychainItem behaves weirdly). They're sticking around to possibly be migrated
    // using `migrateAutoloadCredentials()` above and will be removed at some point in the future.
    @KeychainItem(account: "stuwedd.autoload.cardnumber")
    private var legacyAutoloadCardnumber: String?
    @KeychainItem(account: "stuwedd.autoload.password")
    private var legacyAutoloadPassword: String?

    @Published var autoloadCardnumber: String?
    @Published var autoloadPassword: String?

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
