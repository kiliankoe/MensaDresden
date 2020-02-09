import Foundation
import UIKit
import EmealKit

extension Meal {
    static var example: Meal {
        Meal(id: 1,
             name: "Rindfleischpfanne mit Möhre, Ananas, Mango und Kokosmilch, dazu Mie Nudeln",
             notes: ["enthält Rindfleisch", "Irgendwas anderes"],
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
