import Foundation
import EmealKit
import os.log

@MainActor
class API: ObservableObject {

    init() {
        Task {
            await loadCanteens()
        }
    }

    // MARK: Canteens

    // Canteens are cached indefinitely since they're not expected to change during the app's runtime.
    @Published var canteens: LoadingResult<[Canteen]> = .loading

    /// Get a list of available canteens, stored in `API.canteens`. Observe that value for updates.
    func loadCanteens() async {
        Logger.api.info("Loading canteens")
        self.canteens = .loading
        do {
            let canteens = try await Canteen.all()
            Logger.api.info("Successfully loaded \(canteens.count) canteens")
            self.canteens = .success(canteens)
        } catch {
            Logger.api.error("Failed loading canteens: \(error.localizedDescription)")
            self.canteens = .failure(error)
            track(error: error, signalType: .apiFailedCanteenLoading)
        }
    }

    // MARK: Meals

    private struct MealCacheKey: Hashable {
        let canteenId: Int
        let date: Date
    }

    private var cachedMeals: [MealCacheKey: CachedResult<[Meal]>] = [:]

    private func cache(result: Result<[Meal], Error>, for canteenId: Int, on date: Date) {
        let key = MealCacheKey(canteenId: canteenId, date: date)
        self.cachedMeals[key] = CachedResult(result: result)
        self.objectWillChange.send()
    }

    func loadMeals(for canteenId: Int, on date: Date) async {
        Logger.api.info("Loading meals for canteen \(canteenId) on \(date)")
        do {
            let meals = try await Meal.for(canteen: canteenId, on: date)
            Logger.api.info("Successfully loaded \(meals.count) meals")
            cache(result: .success(meals), for: canteenId, on: date)
        } catch {
            Logger.api.error("Failed loading meals: \(String(describing: error))")
            cache(result: .failure(error), for: canteenId, on: date)
            track(error: error, signalType: .apiFailedMealLoading, with: [
                "canteenID": String(canteenId),
                "date": Formatter.string(for: date, format: .yearMonthDay)
            ])
        }
    }

    /// Get a list of meals available at a canteen on a date. Returns a cached result for two minutes before polling the API again.
    /// - Parameters:
    ///   - canteenId: ID of the canteen
    ///   - date: Date
    /// - Returns: List of meals wrapped in a `LoadingResult`
    func meals(for canteenId: Int, on date: Date) -> LoadingResult<[Meal]> {
        #warning("This has the same bug as the transactions, multiple requests being fired.")
        let key = MealCacheKey(canteenId: canteenId, date: date)
        Logger.api.info("Getting meals for canteen \(canteenId) on \(date)")
        guard var previousResult = cachedMeals[key] else {
            Task {
                await loadMeals(for: canteenId, on: date)
            }
            return .loading
        }
        Logger.api.info("Found previously cached result")
        if previousResult.isOlder(than: 2 * 60) {
            Logger.api.info("Previously cached result is stale, reloading.")
            Task {
                await loadMeals(for: canteenId, on: date)
            }
        }

        // Sort meals
        if case .success(let meals) = previousResult.result {
            let sortedMeals = meals.sorted(by: Self.mealComparator())
                .sorted { !($0.isSoldOut ?? false) && ($1.isSoldOut ?? false) }
            previousResult.result = .success(sortedMeals)
        }

        return LoadingResult(from: previousResult.result)
    }

    private static func mealComparator() -> (Meal, Meal) -> Bool {
        let userDiet = UserDefaults.standard
            .string(forKey: "userDiet")
            .flatMap(Settings.DietType.init(rawValue:)) ?? .all
        let unwantedIngredients = (UserDefaults.standard
            .array(forKey: "ingredientBlacklist") as? [String])?
            .compactMap { Ingredient(rawValue: $0) } ?? []
        let unwantedAllergens = (UserDefaults.standard
            .array(forKey: "allergenBlacklist") as? [String])?
            .compactMap { Allergen(rawValue: $0) } ?? []

        return { lhs, rhs in
            let lhsIsBad = lhs.isIncompatible(
                withDiet: userDiet,
                ingredients: unwantedIngredients,
                allergens: unwantedAllergens
            )
            let rhsIsBad = rhs.isIncompatible(
                withDiet: userDiet,
                ingredients: unwantedIngredients,
                allergens: unwantedAllergens
            )

            switch (lhsIsBad, rhsIsBad) {
            case (true, true), (false, false):
                let currentTime = Calendar.current.component(.hour, from: Date())

                switch (lhs.isDinner, rhs.isDinner) {
                case (true, true), (false, false):
                    // Both are good/bad and both are dinner or not, so we're sorting based on name
                    return lhs.category < rhs.category
                case (true, false):
                    // Dinner should be at bottom before 3pm, at top after
                    return currentTime > 15
                case (false, true):
                    return currentTime < 15
                }
            case (true, false):
                return false
            case (false, true):
                return true
            }
        }
    }

    // MARK: Transactions

    private var cachedTransactions: CachedResult<[Transaction]>?

    private func cache(result: Result<[Transaction], Error>) {
        cachedTransactions = CachedResult(result: result)
        self.objectWillChange.send()
    }

    func loadTransactions(cardnumber: String, password: String) async {
        Logger.api.info("Loading transactions for \(cardnumber, privacy: .private)")
        if cardnumber == "appledemo" && password == "appledemo" {
            Logger.api.info("Returning example transactions")
            cache(result: .success(Transaction.extensiveExampleValues.reversed()))
            return
        }

        let calendar = Calendar(identifier: .gregorian)
        guard let hundredEightyDaysAgo = calendar.date(byAdding: .day, value: -180, to: Date()) else { return }

        do {
            let card = try await Cardservice.login(username: cardnumber, password: password)
            let transactions = try await card.transactions(begin: hundredEightyDaysAgo)
            Logger.api.info("Successfully loaded \(transactions.count) transactions")
            cache(result: .success(transactions.reversed()))
        } catch {
            Logger.api.error("Failed loading transactions: \(String(describing: error))")
            track(error: error, signalType: .apiFailedAutoloadTransactionsLoading)

            guard let cardserviceError = error as? CardserviceError else { return }
            let wrappedError = CardserviceErrorWrapper(error: cardserviceError)
            cache(result: .failure(wrappedError))
        }
    }

    /// Get a list of transactions.
    /// - Returns: List of transactions wrapped in a `LoadingResult`
    func transactions() -> LoadingResult<[Transaction]> {
        Logger.api.info("Getting cached transactions")
        guard let result = cachedTransactions?.result else { return .loading }
        return LoadingResult(from: result)
    }

    // MARK: Error Analytics

    func track(error: Error, signalType: Analytics, with otherData: [String: String] = [:]) {
        // These are errors that I don't care about, no need to track them.
        let allowedErrorCodes = [
            NSURLErrorNotConnectedToInternet,
            NSURLErrorTimedOut,
            NSURLErrorCallIsActive,
            NSURLErrorDataNotAllowed,
            NSURLErrorInternationalRoamingOff,
        ]
        let description: String
        switch error {
        case let error as EmealError:
            switch error {
            case .other(let wrapped):
                track(error: wrapped, signalType: signalType, with: otherData)
                return
            case .unknown:
                description = String(describing: error)
            }
        case let error as CardserviceError:
            switch error {
            case .network(let wrapped):
                if let wrapped {
                    track(error: wrapped, signalType: signalType, with: otherData)
                    return
                } else {
                    description = String(describing: error)
                }
            case .decoding(let wrapped):
                switch wrapped {
                case .other(let otherError):
                    track(error: otherError, signalType: signalType, with: otherData)
                    return
                case .unknownPaymentType, .unexpectedDateFormat:
                    description = String(describing: error)
                }
            case .invalidURL, .noCardDetails, .invalidLoginCredentials, .rateLimited, .server:
                description = String(describing: error)
            }
        case let error as DecodingError:
            // TODO: Is there anything more helpful I can do here instead?
            // This is the error that keeps popping up on Monday evenings for the Meal API.
            description = String(describing: error)
        default:
            let nsError = error as NSError
            guard !allowedErrorCodes.contains(nsError.code) else { return }
            description = "\(nsError.code)"
        }
        Analytics.send(signalType, with: [
            "error": description,
            "errorCode": "\(error._code)"
        ].merging(otherData, uniquingKeysWith: { lhs, _ in lhs }))
    }
}
