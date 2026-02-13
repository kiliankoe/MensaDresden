import Foundation
import EmealKit

enum FixtureData {
    // MARK: - Canteens

    static let canteens: [Canteen] = [
        canteen(
            id: 4,
            name: "Alte Mensa",
            address: "Mommsenstr. 13, 01069 Dresden",
            coordinates: [51.02696733929933, 13.726491630077364],
            url: "https://www.studentenwerk-dresden.de/mensen/details-alte-mensa.html",
            menu: "https://www.studentenwerk-dresden.de/mensen/speiseplan/alte-mensa.html",
            openingSlots: [
                timeSlot(area: "Cafeteria Zebradiele", hoursText: "Mo-Fr 08:00-15:00", days: monToFri, open: (8, 0), close: (15, 0)),
                timeSlot(area: "Mittagstisch im Brat²", hoursText: "Mo-Do 10:45-14:45", days: monToThu, open: (10, 45), close: (14, 45)),
                timeSlot(area: "Mittagstisch im Brat²", hoursText: "Fr 10:45-14:15", days: [.friday], open: (10, 45), close: (14, 15)),
                timeSlot(area: "Servicepunkt", hoursText: "Mo-Fr 11:00-14:30", days: monToFri, open: (11, 0), close: (14, 30)),
            ]
        ),
        canteen(
            id: 6,
            name: "Mensa Matrix",
            address: "Reichenbachstr. 1, 01069 Dresden",
            coordinates: [51.034283226863565, 13.734020590782166],
            url: "https://www.studentenwerk-dresden.de/mensen/details-mensa-matrix.html",
            menu: "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-matrix.html",
            openingSlots: [
                timeSlot(area: "House", hoursText: "Mo-Fr 10:45-14:00", days: monToFri, open: (10, 45), close: (14, 0)),
            ]
        ),
        canteen(
            id: 35,
            name: "Zeltschlösschen",
            address: "Nürnberger Str. 55, 01187 Dresden",
            coordinates: [51.03183, 13.72597],
            url: "https://www.studentenwerk-dresden.de/mensen/details-zeltschloesschen.html",
            menu: "https://www.studentenwerk-dresden.de/mensen/speiseplan/zeltschloesschen.html",
            openingSlots: [
                timeSlot(area: "Kaffeelounge", hoursText: "Mo-Fr 08:00-17:00", days: monToFri, open: (8, 0), close: (17, 0)),
                timeSlot(area: "House", hoursText: "Mo-Fr 08:30-17:00", days: monToFri, open: (8, 30), close: (17, 0)),
                timeSlot(area: "Mittagstisch", hoursText: "Mo-Fr 11:00-15:00", days: monToFri, open: (11, 0), close: (15, 0)),
            ]
        ),
        canteen(
            id: 8,
            name: "Mensologie",
            address: "Blasewitzer Str. 84, 01307 Dresden",
            coordinates: [51.05274, 13.78410],
            url: "https://www.studentenwerk-dresden.de/mensen/details-mensologie.html",
            menu: "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensologie.html",
            openingSlots: [
                timeSlot(area: "Mittagstisch", hoursText: "Mo-Fr 11:00-14:00", days: monToFri, open: (11, 0), close: (14, 0)),
            ]
        ),
        canteen(
            id: 9,
            name: "Mensa Siedepunkt",
            address: "Zellescher Weg 17, 01069 Dresden",
            coordinates: [51.02844, 13.73878],
            url: "https://www.studentenwerk-dresden.de/mensen/details-mensa-siedepunkt.html",
            menu: "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-siedepunkt.html",
            openingSlots: [
                timeSlot(area: "Mittagsangebot", hoursText: "Mo-Fr 11:00-14:30", days: monToFri, open: (11, 0), close: (14, 30)),
                timeSlot(area: "Abendangebot", hoursText: "Mo-Do 17:00-20:00", days: monToThu, open: (17, 0), close: (20, 0)),
            ]
        ),
        canteen(
            id: 32,
            name: "Mensa Johanna",
            address: "Marschnerstr. 38, 01307 Dresden",
            coordinates: [51.05308, 13.78023],
            url: "https://www.studentenwerk-dresden.de/mensen/details-mensa-johanna.html",
            menu: "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-johanna.html",
            openingSlots: [
                timeSlot(area: "House", hoursText: "Mo-Fr 11:00-14:00", days: monToFri, open: (11, 0), close: (14, 0)),
            ]
        ),
        canteen(
            id: 13,
            name: "Mensa Stimm-Gabel",
            address: "Wettiner Platz 13, 01067 Dresden",
            coordinates: [51.05051, 13.72282],
            url: "https://www.studentenwerk-dresden.de/mensen/details-mensa-stimm-gabel.html",
            menu: "https://www.studentenwerk-dresden.de/mensen/speiseplan/mensa-stimm-gabel.html",
            openingSlots: [
                timeSlot(area: "Mittagstisch", hoursText: "Mo-Fr 11:00-14:00", days: monToFri, open: (11, 0), close: (14, 0)),
            ]
        ),
    ]

    // MARK: - Meals

    static func meals(for canteenId: Int) -> [Meal] {
        mealsByCanteen[canteenId] ?? alteMensaMeals
    }

    static let alteMensaMeals: [Meal] = [
        meal(
            id: 329353,
            name: "Gnocchipfanne mit Brokkoli, Zucchini, Tomaten und Karotten, dazu fruchtige Tomatensoße",
            notes: ["Menü ist vegan"],
            studentsPrice: 3.75,
            employeesPrice: 6.82,
            category: "Fertig 2",
            image: fixtureMealImage("329353"),
            url: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-329353.html"
        ),
        meal(
            id: 329358,
            name: "Gyros in Metaxasoße mit Tsatsiki, dazu Reis und Weißkrautsalat",
            notes: ["enthält Schweinefleisch", "Milch/Milchzucker (Laktose) (G)"],
            studentsPrice: 4.15,
            employeesPrice: 7.55,
            category: "Fertig 1",
            image: fixtureMealImage("329358"),
            url: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-329358.html"
        ),
        meal(
            id: 329359,
            name: "Süßkartoffelschnitten auf Erbsencremesoße, dazu Gemüsecouscous mit Kichererbsen",
            notes: ["Menü ist vegan"],
            studentsPrice: 3.45,
            employeesPrice: 6.27,
            category: "Fertig 2",
            image: fixtureMealImage("329359"),
            url: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-329359.html"
        ),
        meal(
            id: 329382,
            name: "Pasta mit Basilikumsoße, getrockneter Tomate und veganem Schmelz",
            notes: ["Menü ist vegan", "Glutenhaltiges Getreide (A)"],
            studentsPrice: 2.78,
            employeesPrice: 5.05,
            category: "Pasta",
            image: fixtureMealImage("329382"),
            url: "https://www.studentenwerk-dresden.de/menschen/speiseplan/details-329382.html"
        ),
        meal(
            id: 329360,
            name: "Gekochte Eier in Senfsoße mit buntem Gemüse und Petersilienkartoffeln",
            notes: ["Menü ist vegetarisch", "Milch/Milchzucker (Laktose) (G)", "Ei (C)"],
            studentsPrice: 2.35,
            employeesPrice: 4.90,
            category: "Fertig 3",
            image: fixtureMealImage("329360"),
            url: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-329360.html"
        ),
    ]

    static let mioMeals: [Meal] = [
        meal(
            id: 400001,
            name: "Süßkartoffel-Curry mit Kichererbsen und Basmatireis",
            notes: ["Menü ist vegan"],
            studentsPrice: 3.20,
            employeesPrice: 5.60,
            category: "Tagesgericht",
            image: fixtureMealImage("329353"),
            url: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-400001.html"
        ),
    ]

    private static let mealsByCanteen: [Int: [Meal]] = [
        4: alteMensaMeals,
        6: alteMensaMeals,
        35: alteMensaMeals,
        8: alteMensaMeals,
        9: alteMensaMeals,
        32: alteMensaMeals,
        13: alteMensaMeals,
    ]

    // MARK: - Helpers

    private static let monToFri: Set<OpeningHours.Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday]
    private static let monToThu: Set<OpeningHours.Weekday> = [.monday, .tuesday, .wednesday, .thursday]

    private static func fixtureMealImage(_ name: String) -> URL {
        Bundle.main.url(forResource: name, withExtension: "jpg", subdirectory: "FixtureMealImages")
            ?? URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/202602/\(name).jpg")!
    }

    private static func timeSlot(
        area: String,
        hoursText: String,
        days: Set<OpeningHours.Weekday>,
        open: (Int, Int),
        close: (Int, Int)
    ) -> OpeningHours.TimeSlot {
        OpeningHours.TimeSlot(
            area: area,
            dateRange: nil,
            hoursText: hoursText,
            isRegular: true,
            parsedHours: [
                OpeningHours.WeekdayHours(
                    label: area,
                    days: days,
                    openTime: OpeningHours.TimeOfDay(hour: open.0, minute: open.1),
                    closeTime: OpeningHours.TimeOfDay(hour: close.0, minute: close.1)
                ),
            ]
        )
    }

    private static func canteen(
        id: Int,
        name: String,
        address: String,
        coordinates: [Double],
        url: String,
        menu: String,
        openingSlots: [OpeningHours.TimeSlot]
    ) -> Canteen {
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
                regularHours: openingSlots,
                changedHours: []
            )
        )
    }

    private static func meal(id: Int, name: String, notes: [String], studentsPrice: Double, employeesPrice: Double, category: String, image: URL, url: String) -> Meal {
        var meal = Meal(
            id: id,
            name: name,
            notes: notes,
            prices: Meal.Prices(students: studentsPrice, employees: employeesPrice),
            category: category,
            image: image,
            url: URL(string: url)!
        )
        meal.isSoldOut = false
        return meal
    }
}
