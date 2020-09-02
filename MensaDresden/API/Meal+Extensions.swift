import Foundation
import UIKit
import SwiftUI
import EmealKit

extension Meal {
    var emoji: String? {
        if let emoji = emoji(for: category) {
            return emoji
        }
        return emoji(for: name)
    }

    private func emoji(for string: String) -> String? {
        let lowercased = string.lowercased()
        if lowercased.contains("pasta") || lowercased.contains("nudeln") {
            return "🍝"
        } else if lowercased.contains("sushi") {
            return "🍣"
        } else if lowercased.contains("burger") {
            return "🍔"
        } else if lowercased.contains("burrito") {
            return "🌯"
        } else if lowercased.contains("döner") {
            return "🥙"
        } else if lowercased.contains("pizza") {
            return "🍕"
        } else if lowercased.contains("hotdog") {
            return "🌭"
        } else if lowercased.contains("falafel") {
            return "🧆"
        } else if lowercased.contains("steak") {
            return "🥩"
        } else if (lowercased.contains("curry") && !lowercased.contains("currywurst")) || lowercased.contains("rice") {
            return "🍛"
        } else if lowercased.contains("kuchen") {
            return "🍰"
        } else if lowercased.contains("suppe") {
            return "🍲"
        } else if lowercased.contains("fleisch") {
            return "🍖"
        } else if lowercased.contains("fisch") {
            return "🐟"
        }
        return nil
    }
}

extension Ingredient {
    var emoji: String {
        switch self {
        case .pork:
            return "🐖"
        case .beef:
            return "🐄"
        case .alcohol:
            return "🍷"
        case .garlic:
            return "🧄"
        }
    }
}

// MARK: Activity Item

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

// MARK: Preview Data

extension Meal {
    static var examples: [Meal] = [
        Meal(id: 1,
             name: "Zucchini-Champignon-Linsenpfanne mit Falafelbällchen",
             notes: ["Menü ist vegan", "enthält Knoblauch", "Glutenhaltiges Getreide (A)", "Weizen (A1)"],
             prices: Meal.Prices(students: 2.58, employees: 4.7),
             category: "Alternativ",
             image: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m15/202008/247506.jpg")!,
             url: URL(string: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-247506.html?pni=30")!),
        Meal(id: 2,
             name: "Mediterraner Nudelsalat mit getrockneten Tomaten, Rucola, Paprika und Pinienkernen, dazu hausgebackenes Focaccia",
             notes: ["Menü ist vegetarisch", "enthält Knoblauch", "Glutenhaltiges Getreide (A)", "Weizen (A1)", "Haselnüsse (H2)", "Sulfit/Schwefeldioxid (L)"],
             prices: Meal.Prices(students: 2.7, employees: 4.91),
             category: "Vegetarisch Abendangebot",
             image: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m35/202009/248176.jpg")!,
             url: URL(string: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-248176.html?pni=13")!),
        Meal(id: 3,
             name: "Langos mit Schmandcreme wahlweise mit Gouda und Schinken oder Tomate-Mozzarella",
             notes: ["mit tierischem Lab",
                     "mit Gelantine",
                     "enthält Schweinefleisch",
                     "enthält Knoblauch",
                     "enthält Rindfleisch", // Nur zu Previewzwecken :P
                     "enhält Alkohol", // Nur zu Previewzwecken
                     "mit Konservierungsstoff (2)",
                     "mit Antioxydationsmittel (3)",
                     "mit Phosphat (8)",
                     "Glutenhaltiges Getreide (A)",
                     "Weizen (A1)",
                     "Milch/Milchzucker (Laktose) (G)",
                     "Schalenfrüchte (Nüsse) (H)",
                     "Haselnüsse (H2)",
                     "auch vegan erhältlich (A, A1, F, H, H2)"],
             prices: Meal.Prices(students: 2.35, employees: 4.27),
             category: "Fleisch/Fisch",
             image: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m35/202008/247755.jpg")!,
             url: URL(string: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-247755.html?pni=3")!),
    ]
}
