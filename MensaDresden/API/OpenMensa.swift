import Foundation
import Combine
import EmealKit

class OMStore: ObservableObject {
    static let baseURL = URL(string: "https://api.studentenwerk-dresden.de/openmensa/v2/")!

    var settings: Settings

    init(settings: Settings) {
        self.settings = settings
        loadCanteens()
    }

    // MARK: Canteens
    @Published
    var canteens: LoadingResult<[Canteen]> = .loading

    var cancellable: AnyCancellable?

    func loadCanteens() {
        cancellable = EmealKit.Canteen.allPublisher()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.canteens = .failure(error)
                }
            }, receiveValue: { canteens in
                if canteens.isEmpty {
                    self.canteens = .noData
                } else {
                    self.canteens = .success(canteens)
                }
            })
    }

    // MARK: Meals

    /// Load meals from cache.
    func meals(for canteen: Int, on date: Date) -> LoadingResult<[Meal]> {
        guard let previousResult = cachedMeals[cacheKey(for: canteen, on: date)] else {
            loadMeals(for: canteen, on: date)
            return .loading
        }
        if previousResult.isOlder(than: 2*60) {
            loadMeals(for: canteen, on: date)
        }
        return previousResult.result
    }

    /// Save meals with a key based on their origin canteen and date,
    /// e.g. "4/2019-10-31" referring to canteen with ID 4 on the specified date.
    private var cachedMeals: [String: CachedLoadingResult<[Meal]>] = [:]

    private func cacheKey(for canteen: Int, on date: Date) -> String {
        "\(canteen)/\(Formatter.string(for: date, format: .yearMonthDay, locale: Locale(identifier: "en_US")))"
    }

    private func save(result: LoadingResult<[Meal]>, for canteen: Int, on date: Date) {
        // TODO: Should sorting be happening here? Or rather on display of the meals like for canteens so it could be changeable by the user.
        var result = result
        result.sort { lhs, rhs -> Bool in
            if lhs.isDinner { return false }
            if rhs.isDinner { return true }
            return lhs.category.lowercased() < rhs.category.lowercased()
        }
        cachedMeals[cacheKey(for: canteen, on: date)] = CachedLoadingResult(result: result)
        objectWillChange.send()
    }

    func loadMeals(for canteen: Int, on date: Date) {
        let dateString = Formatter.string(for: date, format: .yearMonthDay, locale: Locale(identifier: "en_US"))
        var request = URLRequest(url: URL(string: "canteens/\(canteen)/days/\(dateString)/meals", relativeTo: Self.baseURL)!)
        request.addValue(Locale.preferredLanguages.joined(separator: ", "), forHTTPHeaderField: "Accept-Language")

        cancellable = Meal.publisherFor(canteen: canteen, on: date)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.save(result: .failure(error), for: canteen, on: date)
                }
            }, receiveValue: { meals in
                if meals.isEmpty {
                    self.save(result: .noData, for: canteen, on: date)
                } else {
                    self.save(result: .success(meals), for: canteen, on: date)
                }
            })
    }

    // MARK: Transactions

    private var cachedTransactions: CachedLoadingResult<[EmealKit.Transaction]>?

    func transactions() -> LoadingResult<[EmealKit.Transaction]> {
        guard let cached = cachedTransactions else {
            loadTransactions()
            return .loading
        }
        if cached.isOlder(than: 10*60) {
            loadTransactions()
        }
        return cached.result
    }

    private func save(result: LoadingResult<[EmealKit.Transaction]>) {
        cachedTransactions = CachedLoadingResult(result: result)
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    func loadTransactions() {
        guard let cardnumber = settings.autoloadCardnumber, let password = settings.autoloadPassword else {
            return
        }

        if cardnumber == "appledemo" && password == "appledemo" {
            save(result: .success(Transaction.exampleValues))
            return
        }

        let calendar = Calendar(identifier: .gregorian)
        guard let ninetyDaysAgo = calendar.date(byAdding: .day, value: -90, to: Date()) else {
            return
        }

        Cardservice.login(username: cardnumber, password: password) { result in
            switch result {
            case .failure(let error):
                // FIXME: The error here is an EmealKit.Error without a good localizedDescription.
                self.save(result: .failure(error))
            case .success(let service):
                service.transactions(begin: ninetyDaysAgo, end: Date()) { result in
                    switch result {
                    case .failure(let error):
                        // FIXME: The error here is an EmealKit.Error without a good localizedDescription.
                        self.save(result: .failure(error))
                    case .success(let transactions):
                        if transactions.isEmpty {
                            self.save(result: .noData)
                        } else {
                            self.save(result: .success(transactions.reversed()))
                        }
                    }
                }
            }
        }
    }
}
