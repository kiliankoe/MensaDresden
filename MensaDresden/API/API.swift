import Foundation
import EmealKit

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
        self.canteens = .loading
        do {
            let canteens = try await Canteen.all()
            self.canteens = .success(canteens)
        } catch {
            self.canteens = .failure(error)
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
        do {
            let meals = try await Meal.for(canteen: canteenId, on: date)
            cache(result: .success(meals), for: canteenId, on: date)
        } catch {
            cache(result: .failure(error), for: canteenId, on: date)
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
        guard let previousResult = cachedMeals[key] else {
            Task {
                await loadMeals(for: canteenId, on: date)
            }
            return .loading
        }
        if previousResult.isOlder(than: 2 * 60) {
            Task {
                await loadMeals(for: canteenId, on: date)
            }
        }
        return LoadingResult(from: previousResult.result)
    }

    // MARK: Transactions

    private var cachedTransactions: CachedResult<[Transaction]>?

    private func cache(result: Result<[Transaction], Error>) {
        cachedTransactions = CachedResult(result: result)
        self.objectWillChange.send()
    }

    func loadTransactions(cardnumber: String, password: String) async {
        if cardnumber == "appledemo" && password == "appledemo" {
            cache(result: .success(Transaction.exampleValues))
            return
        }

        let calendar = Calendar(identifier: .gregorian)
        guard let ninetyDaysAgo = calendar.date(byAdding: .day, value: -90, to: Date()) else { return }

        do {
            let card = try await Cardservice.login(username: cardnumber, password: password)
            let transactions = try await card.transactions(begin: ninetyDaysAgo)
            cache(result: .success(transactions))
        } catch {
            guard let cardserviceError = error as? CardserviceError else {
                print("Unexpected error type, this shouldn't happen: \(error)")
                return
            }
            let wrappedError = CardserviceErrorWrapper(error: cardserviceError)
            cache(result: .failure(wrappedError))
        }
    }

    /// Get a list of transactions.
    /// - Returns: List of transactions wrapped in a `LoadingResult`
    func transactions() -> LoadingResult<[Transaction]> {
        guard let result = cachedTransactions?.result else { return .loading }
        return LoadingResult(from: result)
    }
}
