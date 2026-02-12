import Foundation

enum AppDataMode: String {
    case live
    case fixtures

    static let launchEnvironmentKey = "MENSA_DATA_MODE"

    static func from(launchEnvironment: [String: String]) -> AppDataMode? {
        guard let value = launchEnvironment[Self.launchEnvironmentKey]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty
        else {
            return nil
        }

        return AppDataMode(rawValue: value.lowercased())
    }
}
