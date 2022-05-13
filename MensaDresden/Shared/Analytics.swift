import Foundation
import TelemetryClient

enum Analytics: String {
    case currentSettings

    // API
    case apiFailedCanteenLoading
    case apiFailedMealLoading
    case apiFailedAutoloadTransactionsLoading

    static func send(_ signal: Analytics, with: [String: String] = [:]) {
        TelemetryManager.send(signal.rawValue, with: with)
    }

    static func setup() {
        let configuration = TelemetryManagerConfiguration(appID: "3EA0AAB8-D7B0-405B-9AE7-DF686B8009FE")
        TelemetryManager.initialize(with: configuration)
    }
}
