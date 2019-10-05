import Foundation
import SwiftUI

class BlacklistBinding<T> where T: Equatable, T: RawRepresentable {
    let userDefaultsKey: String

    init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
    }

    var storage: Array<T> {
        get {
            let rawArray = UserDefaults.standard.array(forKey: userDefaultsKey) as? [T.RawValue]
            return rawArray?.compactMap { T.init(rawValue: $0) } ?? []
        }
        set {
            UserDefaults.standard.set(newValue.map { $0.rawValue }, forKey: userDefaultsKey)
        }
    }

    func binding(for value: T) -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                !self.storage.contains(value)
            },
            set: { flag in
                if flag {
                    self.storage.removeAll { $0 == value }
                } else {
                    self.storage.append(value)
                }
            }
        )
    }
}
