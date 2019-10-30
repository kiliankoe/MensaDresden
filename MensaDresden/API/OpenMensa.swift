import Foundation
import Combine
import EmealKit


class OpenMensaService: ObservableObject {
    var settings: Settings

    init(settings: Settings) {
        self.settings = settings
    }

    let baseURL = URL(string: "https://api.studentenwerk-dresden.de/openmensa/v2/")!

    var objectWillChange = ObservableObjectPublisher()

    var canteens: [Canteen] = [] {
        didSet {
            objectWillChange.send()
        }
    }

    var meals: [Int: [Meal]] = [:] {
        didSet {
            objectWillChange.send()
        }
    }

    private var request: AnyCancellable?

    func fetchCanteens() {
        self.request?.cancel()
        self.request = URLSession.shared
            .dataTaskPublisher(for: URL(string: "canteens", relativeTo: baseURL)!)
            .map { $0.data }
            .decode(type: [Canteen].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.canteens, on: self)
    }

    // FIXME: This is a weird hack and far from the ideal solution.
    var lastCanteen: Int?
    var day: Date = .today {
        didSet {
            guard let lastCanteen = lastCanteen else { return }
            fetchMeals(for: lastCanteen, on: day)
        }
    }

    func fetchMeals(for id: Int, on date: Date) {
        lastCanteen = id

        let dateString = Formatter.string(for: date, format: .yearMonthDay, locale: Locale(identifier: "en_US"))
        var request = URLRequest(url: URL(string: "canteens/\(id)/days/\(dateString)/meals", relativeTo: baseURL)!)
        request.addValue(Locale.preferredLanguages.joined(separator: ", "), forHTTPHeaderField: "Accept-Language")

        self.request?.cancel()
        self.request = URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [Meal].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                let meals = $0.sorted { lhs, rhs in
                    if lhs.isDinner { return false }
                    if rhs.isDinner { return true }
                    return lhs.name < rhs.name
                }
                self?.meals[id] = meals
            }
//            .assign(to: \.meals[id], on: self)
    }

    var transactions: [EmealKit.Transaction] = [] {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

    func getTransactions() {
        guard let cardnumber = settings.autoloadCardnumber, let password = settings.autoloadPassword else {
            return
        }

        if cardnumber == "appledemo" && password == "appledemo" {
            self.transactions = Transaction.exampleValues
            return
        }

        Cardservice.login(username: cardnumber, password: password) { result in
            guard let service = try? result.get() else { return }

            let calendar = Calendar(identifier: .gregorian)
            guard let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: Date()) else {
                return
            }

            service.transactions(begin: threeMonthsAgo, end: Date()) { result in
                guard let transactions = try? result.get() else { return }
                self.transactions = transactions.reversed()
            }
        }
    }
}
