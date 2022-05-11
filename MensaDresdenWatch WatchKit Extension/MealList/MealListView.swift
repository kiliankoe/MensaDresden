import SwiftUI
import EmealKit

struct MealListView: View {
    @State var canteen: Canteen

    @EnvironmentObject var api: API

    @State var showingDatePickerView = false

    @State var selectedDate: Date = .today

    var body: some View {
        MealList(canteen: canteen, selectedDate: $selectedDate)
        .navigationTitle(canteen.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if self.selectedDate < Date.today {
                self.selectedDate = .today
            }
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static let settings = Settings()

    static var previews: some View {
        let settings = Settings()

//        service.meals[1] = [
//            Meal(id: 1, name: "Mahlzeit 1", notes: [], prices: Meal.Prices(students: 1.5, employees: 1.5), category: "Kategorie", image: Meal.placeholderImageURL, url: Meal.placeholderImageURL),
//            Meal(id: 2, name: "Mahlzeit 2", notes: [], prices: Meal.Prices(students: 1.5, employees: 1.5), category: "Kategorie", image: Meal.placeholderImageURL, url: Meal.placeholderImageURL),
//        ]

        return NavigationView {
            MealListView(canteen: Canteen.example)
        }
        .environmentObject(settings)
        .environmentObject(API())
        .accentColor(.green)
    }
}
