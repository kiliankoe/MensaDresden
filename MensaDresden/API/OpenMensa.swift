import Foundation
import Combine

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
//                .dataTaskPublisher(for: URL(string: "canteens/\(id)/days/2019-10-02/meals", relativeTo: baseURL)!)
                .map { $0.data }
                .decode(type: [Meal].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .sink { self.meals[id] = $0 }
//                .assign(to: \.meals[id], on: self)
        }
}
