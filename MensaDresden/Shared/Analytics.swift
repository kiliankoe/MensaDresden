import Foundation
import TelemetryClient

enum Analytics: String {
    case currentSettings

    // Navigation
    case openedTabMenu
    case openedTabEmeal
    case openedTabNews
    case openedTabSettings

    // Meal List
    case openedMealList
    case selectedPickerDay
    case openedCalendarDatePicker
    case toggledCanteenFavorite
    case retriedMealData
    case refreshedMealData

    // Meal Detail
    case openedMealDetailView
    case openedMealShareSheet
    case openedMealFeedback

    // Emeal View
    case scannedEmeal
    case retriedAutoloadTransactions
    case refreshedAutoloadTransactions

    // SettingsView
    case openedAboutView
    case openedFavoriteCanteensSetting
    case openedIngredientsAndAllergensSetting
    case openedCanteenSortingSetting // not used right now

    // Settings
    case changedCanteenSortingMode
    case changedUserDiet
    case changedIngredients
    case changedAllergens
    case setAutoloadCredentials

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
