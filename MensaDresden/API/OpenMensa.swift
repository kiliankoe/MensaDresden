import Foundation
import Combine

class CanteenService: ObservableObject {
    let baseURL = URL(string: "https://api.studentenwerk-dresden.de/openmensa/v2/")!

    var canteens: [Canteen] = [] {
        didSet {
            objectWillChange.send()
        }
    }

    private var cancellable: AnyCancellable?

    public let objectWillChange = PassthroughSubject<Void, Never>()

    func fetchCanteens() {
        self.cancellable = URLSession.shared
            .dataTaskPublisher(for: URL(string: "canteens", relativeTo: baseURL)!)
            .map { $0.data }
            .decode(type: [Canteen].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.canteens, on: self)
    }
}

class MealService: ObservableObject {
    let baseURL = URL(string: "https://api.studentenwerk-dresden.de/openmensa/v2/")!

    var meals: [Meal] = [] {
        didSet {
            objectWillChange.send()
        }
    }

    var canteenID: Int?

    var dateOffset = 0 {
        didSet {
            self.fetchMeals(date: Date().addingTimeInterval(Double(self.dateOffset * 24 * 3600)))
        }
    }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private var cancellable: AnyCancellable?

    public let objectWillChange = PassthroughSubject<Void, Never>()

    func fetchMeals(date: Date) {
        guard let canteenID = self.canteenID else { return }
        self.cancellable = URLSession.shared
            .dataTaskPublisher(for: URL(string: "canteens/\(canteenID)/days/\(dateFormatter.string(from: date))/meals", relativeTo: baseURL)!)
            .map { $0.data }
            .decode(type: [Meal].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.meals, on: self)
    }
}
