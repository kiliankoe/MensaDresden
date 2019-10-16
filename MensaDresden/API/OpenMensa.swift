import Foundation
import Combine
import EmealKit

enum Day: Int {
    case today = 0
    case tomorrow
}

extension Date {
    static var today: Date {
        Date()
    }

    static var tomorrow: Date {
        Date().addingTimeInterval(Double(24 * 3600))
    }
}

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

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    // FIXME: This is a weird hack and far from the ideal solution.
    var lastCanteen: Int?
    var day: Day = .today {
        didSet {
            guard let lastCanteen = lastCanteen else { return }
            fetchMeals(for: lastCanteen, on: day)
        }
    }

    func fetchMeals(for id: Int, on day: Day) {
        lastCanteen = id
        var date = Date.today
        switch day {
        case .today:
            break
        case .tomorrow:
            date = Date.tomorrow
        }

        self.request?.cancel()
        self.request = URLSession.shared
            .dataTaskPublisher(for: URL(string: "canteens/\(id)/days/\(dateFormatter.string(from: date))/meals", relativeTo: baseURL)!)
//            .dataTaskPublisher(for: URL(string: "canteens/\(id)/days/2019-10-07/meals", relativeTo: baseURL)!)
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

            let threeMonthsAgo = Date().addingTimeInterval(-90 * 24 * 3600)
            service.transactions(begin: threeMonthsAgo, end: Date()) { result in
                guard let transactions = try? result.get() else { return }
                self.transactions = transactions.reversed()
            }
        }
    }
}
