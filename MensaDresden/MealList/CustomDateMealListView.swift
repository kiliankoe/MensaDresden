import SwiftUI
import EmealKit

struct CustomDateMealListView: View {
    @State var canteen: Canteen
    var selectedDate: Date

    var navigationTitle: String {
        Formatter.string(for: selectedDate, dateStyle: .full, timeStyle: .none)
    }

    var body: some View {
        MealList(canteen: canteen, selectedDate: .constant(selectedDate))
            .navigationBarTitle(Text(navigationTitle), displayMode: .inline)
    }
}

struct CustomDateMealListView_Previews: PreviewProvider {
    static let settings = Settings()

    static var previews: some View {
//        service.meals[1] = [
//            Meal(id: 1, name: "Mahlzeit 1", notes: [], prices: Meal.Prices(students: 1.5, employees: 1.5), category: "Kategorie", image: Meal.placeholderImageURL, url: Meal.placeholderImageURL),
//            Meal(id: 2, name: "Mahlzeit 2", notes: [], prices: Meal.Prices(students: 1.5, employees: 1.5), category: "Kategorie", image: Meal.placeholderImageURL, url: Meal.placeholderImageURL),
//        ]

        return NavigationView {
            CustomDateMealListView(canteen: Canteen.example, selectedDate: Date())
        }
        .accentColor(.green)
    }
}
