import Foundation

struct Meal: Identifiable, Decodable {
    let id: Int
    let name: String
    let notes: [String]
    let prices: Prices?
    let category: String
    let image: URL
    let url: URL

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case notes
        case prices
        case category
        case image
        case url
    }

    struct Prices: Decodable {
        let students: Double
        let employees: Double

        private enum CodingKeys: String, CodingKey {
            case students = "Studierende"
            case employees = "Bedienstete"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.notes = try container.decode([String].self, forKey: .notes)

        if let prices = try? container.decode(Prices.self, forKey: .prices) {
            self.prices = prices
        } else {
            self.prices = nil
        }

        self.category = try container.decode(String.self, forKey: .category)
        self.image = try container.decode(URL.self, forKey: .image)
        self.url = try container.decode(URL.self, forKey: .url)
    }

    internal init(id: Int, name: String, notes: [String], prices: Meal.Prices?, category: String, image: URL, url: URL) {
        self.id = id
        self.name = name
        self.notes = notes
        self.prices = prices
        self.category = category
        self.image = image
        self.url = url
    }
}
