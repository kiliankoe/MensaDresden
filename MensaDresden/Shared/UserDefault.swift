import Foundation

#warning("Delete me and use `AppStorage` when dropping iOS 13.")
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let suite: UserDefaults

    init(_ key: String, defaultValue: T, suite: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.suite = suite
    }

    var wrappedValue: T {
        get {
            suite.object(forKey: key) as? T ?? defaultValue
        }
        set {
            suite.set(newValue, forKey: key)
        }
    }
}
