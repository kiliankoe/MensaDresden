import Foundation
import EmealKit

enum FixtureData {
    static let canteens: [Canteen] = [
        canteen(
            id: 4,
            name: "Alte Mensa",
            address: "Mommsenstr. 13, 01069 Dresden",
            coordinates: [51.02696733929933, 13.726491630077364],
            url: "https://www.studentenwerk-dresden.de/mensen/details-alte-mensa.html",
            menu: "https://www.studentenwerk-dresden.de/mensen/speiseplan/alte-mensa.html"
        ),
        canteen(
            id: 28,
            name: "MiO - Mensa im Osten",
            address: "Furtstr. 1a, 02826 Gorlitz",
            coordinates: [51.14924302208328, 14.998609721660616],
            url: "https://www.studentenwerk-dresden.de/mensen/details-mio-mensa-im-osten.html",
            menu: "https://www.studentenwerk-dresden.de/mensen/speiseplan/mio-mensa-im-osten.html"
        ),
        canteen(
            id: 6,
            name: "Mensa Matrix",
            address: "Reichenbachstr. 1, 01069 Dresden",
            coordinates: [51.034283226863565, 13.734020590782166],
            url: "https://www.studentenwerk-dresden.de/mensen/details-mensa-matrix.html",
            menu: "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-matrix.html"
        ),
    ]

    static func meals(for canteenId: Int) -> [Meal] {
        mealsByCanteen[canteenId] ?? alteMensaMeals
    }

    static let alteMensaMeals: [Meal] = [
        meal(
            id: 310958,
            name: "Besuchen Sie auch unsere Beilagentheke, hier finden Sie ausschlieBlich vegetarische und vegane Angebote.",
            notes: ["Menue ist vegan", "Soja (F)"],
            studentsPrice: 2.18,
            employeesPrice: 3.97,
            category: "Angebot des Tages 2",
            image: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/202411/310958.jpg",
            url: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310958.html"
        ),
        meal(
            id: 308943,
            name: "Pasta oder Vollkornpasta mit Wurstgulasch, dazu Gouda",
            notes: ["enthaelt Schweinefleisch", "Milch/Milchzucker (Laktose) (G)"],
            studentsPrice: 2.35,
            employeesPrice: 4.9,
            category: "Pasta",
            image: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/202411/308943.jpg",
            url: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-308943.html"
        ),
        meal(
            id: 310969,
            name: "Nuggets aus Gemuese und Jackfrucht, dazu Kraeuter-Dip und Gemuesebratkartoffeln",
            notes: ["Menue ist vegan", "Senf (J)"],
            studentsPrice: 3.8,
            employeesPrice: 6.9,
            category: "Fertig 2",
            image: "https://static.studentenwerk-dresden.de/bilder/mensen/studentenwerk-dresden-lieber-mensen-gehen.jpg",
            url: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310969.html"
        ),
        meal(
            id: 310965,
            name: "Haehnchenbrustfilet Piccata mit Pommes frites und Salat",
            notes: ["Glutenhaltiges Getreide (A)", "Milch/Milchzucker (Laktose) (G)"],
            studentsPrice: 3.91,
            employeesPrice: 7.1,
            category: "Fertig 1",
            image: "https://static.studentenwerk-dresden.de/bilder/mensen/studentenwerk-dresden-lieber-mensen-gehen.jpg",
            url: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310965.html"
        ),
    ]

    static let mioMeals: [Meal] = [
        meal(
            id: 400001,
            name: "Sueskartoffel-Curry mit Kichererbsen und Basmatireis",
            notes: ["Menue ist vegan"],
            studentsPrice: 3.2,
            employeesPrice: 5.6,
            category: "Tagesgericht",
            image: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/202411/310958.jpg",
            url: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-310958.html"
        ),
    ]

    private static let mealsByCanteen: [Int: [Meal]] = [
        4: alteMensaMeals,
        28: mioMeals,
    ]

    private static func canteen(id: Int, name: String, address: String, coordinates: [Double], url: String, menu: String) -> Canteen {
        Canteen(
            id: id,
            name: name,
            city: "Dresden",
            address: address,
            coordinates: coordinates,
            url: URL(string: url)!,
            menu: URL(string: menu)!,
            openingHours: OpeningHours(
                canteenName: name,
                regularHours: [alwaysOpenSlot],
                changedHours: []
            )
        )
    }

    private static func meal(id: Int, name: String, notes: [String], studentsPrice: Double, employeesPrice: Double, category: String, image: String, url: String) -> Meal {
        var meal = Meal(
            id: id,
            name: name,
            notes: notes,
            prices: Meal.Prices(students: studentsPrice, employees: employeesPrice),
            category: category,
            image: URL(string: image)!,
            url: URL(string: url)!
        )
        meal.isSoldOut = false
        return meal
    }

    private static let alwaysOpenSlot = OpeningHours.TimeSlot(
        area: "Mittagstisch",
        dateRange: nil,
        hoursText: "Mo-So 00:00-23:59",
        isRegular: true,
        parsedHours: [
            OpeningHours.WeekdayHours(
                label: "Mittagstisch",
                days: Set(OpeningHours.Weekday.allCases),
                openTime: OpeningHours.TimeOfDay(hour: 0, minute: 0),
                closeTime: OpeningHours.TimeOfDay(hour: 23, minute: 59)
            ),
        ]
    )
}
