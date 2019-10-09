import Foundation
import UIKit
import Regex
import HTMLString

struct Meal: Identifiable, Decodable {
    let id: Int
    let name: String
    let notes: [String]
    let prices: Prices?
    let category: String
    let image: URL
    let url: URL

    var imageIsPlaceholder: Bool {
        image.absoluteString == "https://static.studentenwerk-dresden.de/bilder/mensen/studentenwerk-dresden-lieber-mensen-gehen.jpg"
    }

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
            .map { $0.removingHTMLEntities }

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

    func contains(unwantedIngredients: [Ingredient], unwantedAllergens: [Allergen]) -> Bool {
        for ingredient in unwantedIngredients {
            if ingredients.contains(ingredient) {
                return true
            }
        }
        for allergen in unwantedAllergens {
            if allergens.contains(allergen) {
                return true
            }
        }
        return false
    }

    var isDinner: Bool {
        category.lowercased().contains("abend")
    }

    static var placeholderImageURL: URL {
        return URL(string: "https://static.studentenwerk-dresden.de/bilder/mensen/studentenwerk-dresden-lieber-mensen-gehen.jpg")!
    }

    static var example: Meal {
        Meal(id: 1,
             name: "Rindfleischpfanne mit Möhre, Ananas, Mango und Kokosmilch, dazu Mie Nudeln",
             notes: [""],
             prices: Meal.Prices(students: 2.9, employees: 4.7),
             category: "Wok & Grill",
             image: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/201909/233593.jpg")!,
             url: URL(string: "https://studentenwerk-dresden.de")!)
    }
}

extension Meal {
    var activityItem: ActivityItem {
        return ActivityItem(meal: self)
    }

    class ActivityItem: NSObject, UIActivityItemSource {
        let meal: Meal

        init(meal: Meal) {
            self.meal = meal
        }

        func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
            meal.name
        }

        func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
            meal.name
        }

        func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
            meal.url
        }
    }
}

enum Diet {
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
}

enum Ingredient: String, CaseIterable, Equatable {
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
