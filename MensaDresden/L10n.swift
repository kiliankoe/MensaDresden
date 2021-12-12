// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Alcohol
  internal static let alcohol = L10n.tr("Localizable", "alcohol")
  /// everything
  internal static let all = L10n.tr("Localizable", "all")
  /// Alphabetical
  internal static let alphabetical = L10n.tr("Localizable", "alphabetical")
  /// Beef
  internal static let beef = L10n.tr("Localizable", "beef")
  /// Celery
  internal static let celery = L10n.tr("Localizable", "celery")
  /// Default
  internal static let `default` = L10n.tr("Localizable", "default")
  /// Distance
  internal static let distance = L10n.tr("Localizable", "distance")
  /// Eggs
  internal static let eggs = L10n.tr("Localizable", "eggs")
  /// Employee
  internal static let employee = L10n.tr("Localizable", "employee")
  /// Fish
  internal static let fish = L10n.tr("Localizable", "fish")
  /// Garlic
  internal static let garlic = L10n.tr("Localizable", "garlic")
  /// Gluten
  internal static let gluten = L10n.tr("Localizable", "gluten")
  /// Lactose
  internal static let lactose = L10n.tr("Localizable", "lactose")
  /// Lupin
  internal static let lupin = L10n.tr("Localizable", "lupin")
  /// Molluscs
  internal static let molluscs = L10n.tr("Localizable", "molluscs")
  /// Mustard
  internal static let mustard = L10n.tr("Localizable", "mustard")
  /// Nuts
  internal static let nuts = L10n.tr("Localizable", "nuts")
  /// Peanuts
  internal static let peanuts = L10n.tr("Localizable", "peanuts")
  /// Pork
  internal static let pork = L10n.tr("Localizable", "pork")
  /// Sesame
  internal static let sesame = L10n.tr("Localizable", "sesame")
  /// Shellfish
  internal static let shellfish = L10n.tr("Localizable", "shellfish")
  /// Soy
  internal static let soy = L10n.tr("Localizable", "soy")
  /// Student
  internal static let student = L10n.tr("Localizable", "student")
  /// Sulfite
  internal static let sulfite = L10n.tr("Localizable", "sulfite")
  /// vegan
  internal static let vegan = L10n.tr("Localizable", "vegan")
  /// vegetarian
  internal static let vegetarian = L10n.tr("Localizable", "vegetarian")

  internal enum Canteens {
    /// Canteens
    internal static let nav = L10n.tr("Localizable", "canteens.nav")
    /// No canteens found 🤔
    internal static let noData = L10n.tr("Localizable", "canteens.no-data")
  }

  internal enum Emeal {
    /// Using Autoload? Enter your credentials in the app's settings and all of your recent transactions will show up here.
    internal static let autoloadHint = L10n.tr("Localizable", "emeal.autoload-hint")
    /// Autoload Information
    internal static let autoloadInformation = L10n.tr("Localizable", "emeal.autoload-information")
    /// Balance
    internal static let balance = L10n.tr("Localizable", "emeal.balance")
    /// Last scanned
    internal static let lastScanned = L10n.tr("Localizable", "emeal.last-scanned")
    /// Last Transaction
    internal static let lastTransaction = L10n.tr("Localizable", "emeal.last-transaction")
    /// Connection error. Please try again.
    internal static let nfcConnectionError = L10n.tr("Localizable", "emeal.nfc-connection-error")
    /// Unable to read NFC tag.
    internal static let nfcReadingError = L10n.tr("Localizable", "emeal.nfc-reading-error")
    /// Hold your Emeal card to your device.
    internal static let nfcText = L10n.tr("Localizable", "emeal.nfc-text")
    /// No transactions in the last 90 days.
    internal static let noTransactions = L10n.tr("Localizable", "emeal.no-transactions")
    /// Scan Emeal
    internal static let scanButton = L10n.tr("Localizable", "emeal.scan-button")
    internal enum Error {
      /// Failed to read data.
      internal static let decoding = L10n.tr("Localizable", "emeal.error.decoding")
      /// Invalid username or password
      internal static let invalidCredentials = L10n.tr("Localizable", "emeal.error.invalid-credentials")
      /// Network error
      internal static let network = L10n.tr("Localizable", "emeal.error.network")
      /// No Emeal found in account.
      internal static let noCardDetails = L10n.tr("Localizable", "emeal.error.no-card-details")
      /// Too many requests. Try again in a moment.
      internal static let rateLimited = L10n.tr("Localizable", "emeal.error.rate-limited")
      /// %d Server error
      internal static func server(_ p1: Int) -> String {
        return L10n.tr("Localizable", "emeal.error.server", p1)
      }
    }
  }

  internal enum Info {
    /// Developed by
    internal static let developedBy = L10n.tr("Localizable", "info.developed-by")
    /// Send Feedback
    internal static let email = L10n.tr("Localizable", "info.email")
    /// Icon
    internal static let icon = L10n.tr("Localizable", "info.icon")
    /// Image Rights
    internal static let imageRights = L10n.tr("Localizable", "info.image-rights")
    /// Eddy Wong from The Noun Project
    internal static let nounproject = L10n.tr("Localizable", "info.nounproject")
    /// Huge thanks to Lucas Vogel, Georg Sieber, all GitHub contributors and the beta testers for their great feedback!
    internal static let thanks = L10n.tr("Localizable", "info.thanks")
    /// Contribute Translations
    internal static let translate = L10n.tr("Localizable", "info.translate")
  }

  internal enum Ipad {
    /// 🍲 Bon appétit!
    internal static let bonAppetit = L10n.tr("Localizable", "ipad.bon-appetit")
    /// Swipe from the left to open the list of canteens.
    internal static let swipeHint = L10n.tr("Localizable", "ipad.swipe-hint")
  }

  internal enum List {
    /// Try again.
    internal static let tryAgain = L10n.tr("Localizable", "list.try-again")
  }

  internal enum Meal {
    /// Dinner
    internal static let dinner = L10n.tr("Localizable", "meal.dinner")
    /// This meal may not match your dietary preferences.
    internal static let ingredientWarning = L10n.tr("Localizable", "meal.ingredient-warning")
    /// Send feedback directly to the Studentenwerk.
    internal static let rateDescription = L10n.tr("Localizable", "meal.rate-description")
    /// Rate meal
    internal static let rateTitle = L10n.tr("Localizable", "meal.rate-title")
  }

  internal enum Meals {
    /// It's %@! 📅
    internal static func holiday(_ p1: Any) -> String {
      return L10n.tr("Localizable", "meals.holiday", String(describing: p1))
    }
    /// There's nothing on the menu for this day.
    internal static let noMealsOther = L10n.tr("Localizable", "meals.no-meals-other")
    /// There's nothing on the menu for today.
    internal static let noMealsToday = L10n.tr("Localizable", "meals.no-meals-today")
    /// There's nothing on the menu for tomorrow.
    internal static let noMealsTomorrow = L10n.tr("Localizable", "meals.no-meals-tomorrow")
    /// Have a nice weekend 🏖
    internal static let weekend = L10n.tr("Localizable", "meals.weekend")
  }

  internal enum Settings {
    /// About
    internal static let about = L10n.tr("Localizable", "settings.about")
    /// Allergens
    internal static let allergens = L10n.tr("Localizable", "settings.allergens")
    /// Cardnumber
    internal static let autoloadCardnumber = L10n.tr("Localizable", "settings.autoload-cardnumber")
    /// Using Autoload? Enter your credentials here to show transactions of the last 90 days on the Emeal page. Your credentials are securely saved on this device only and only sent to Studentenwerk servers for authentification purposes.
    internal static let autoloadDescription = L10n.tr("Localizable", "settings.autoload-description")
    /// Autoload Information
    internal static let autoloadInformation = L10n.tr("Localizable", "settings.autoload-information")
    /// Password
    internal static let autoloadPassword = L10n.tr("Localizable", "settings.autoload-password")
    /// Canteen Sorting
    internal static let canteenSorting = L10n.tr("Localizable", "settings.canteen-sorting")
    /// Favorite Canteens
    internal static let favoriteCanteens = L10n.tr("Localizable", "settings.favorite-canteens")
    /// Your favorite canteens. Tap the heart on a canteen's menu to toggle or edit the list here to delete and re-order.
    internal static let favoriteCanteensDescription = L10n.tr("Localizable", "settings.favorite-canteens-description")
    /// Ingredients
    internal static let ingredients = L10n.tr("Localizable", "settings.ingredients")
    /// Choose whether you follow a certain diet or do not want to ingest certain ingredients or allergens. These options are used as filters and meals that are unsuitable for you are grayed out in the menu. Unfortunately, the nutritional information is somewhat incomplete. It may happen that vegetarian and vegan dishes are not marked as such.
    /// Before buying a meal, please pay attention to the ingredients listed in the mensa. You should not rely on the information listed in the app.
    internal static let ingredientsDescription = L10n.tr("Localizable", "settings.ingredients-description")
    /// Settings
    internal static let nav = L10n.tr("Localizable", "settings.nav")
    /// Meal Price
    internal static let priceType = L10n.tr("Localizable", "settings.price-type")
    /// Diet
    internal static let userDiet = L10n.tr("Localizable", "settings.user-diet")
    internal enum IngredientsAllergens {
      /// Ingredients & Allergens
      internal static let title = L10n.tr("Localizable", "settings.ingredients-allergens.title")
    }
  }

  internal enum Tab {
    /// Emeal
    internal static let emeal = L10n.tr("Localizable", "tab.emeal")
    /// Menu
    internal static let menu = L10n.tr("Localizable", "tab.menu")
    /// News
    internal static let newsfeed = L10n.tr("Localizable", "tab.newsfeed")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "tab.settings")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
