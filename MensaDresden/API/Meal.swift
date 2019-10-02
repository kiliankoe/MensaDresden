import Foundation
import Regex

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

    var diet: [Diet] {
        self.notes
            .compactMap { Diet(note: $0) }
    }

    var ingredients: [Ingredient] {
        self.notes
            .compactMap { Ingredient(note: $0) }
    }

    var allergens: [Allergen] {
        self.notes
            .compactMap { Allergen(note: $0) }
    }
}

enum Diet: CustomStringConvertible {
    case vegan
    case vegetarian

    init?(note: String) {
        let note = note.lowercased()
        if note.contains("vegan") {
            self = .vegan
        } else if note.contains("vegetarisch") || note.contains("nomeat") {
            self = .vegetarian
        } else {
            return nil
        }
    }

    var description: String {
        switch self {
        case .vegan:
            return "vegan"
        case .vegetarian:
            return "vegetarian"
        }
    }
}

enum Ingredient {
    case pork
    case beef
    case alcohol
    case garlic

    init?(note: String) {
        let note = note.lowercased()
        if note.contains("schweinefleisch") {
            self = .pork
        } else if note.contains("rindfleisch") {
            self = .beef
        } else if note.contains("alkohol") {
            self = .alcohol
        } else if note.contains("knoblauch") {
            self = .garlic
        } else {
            return nil
        }
    }
}

enum Allergen: String, CaseIterable {
    case gluten = "A"
    case shellfish = "B"
    case eggs = "C"
    case fish = "D"
    case peanuts = "E"
    case soy = "F"
    case lactose = "G"
    case nuts = "H"
    case celery = "I"
    case mustard = "J"
    case sesame = "K"
    case sulfite = "L"
    case lupin = "M"
    case molluscs = "N"

    init?(note: String) {
        let regex = Regex(#"\(([A-Z])\d?\)"#)
        guard let identifier = regex.firstMatch(in: note)?.captures[0] else {
            return nil
        }
        self.init(rawValue: identifier)
    }
}
