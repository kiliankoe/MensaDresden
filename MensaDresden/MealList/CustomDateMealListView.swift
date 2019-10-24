import SwiftUI

struct CustomDateMealListView: View {

    @EnvironmentObject var service: OpenMensaService
    @State var canteen: Canteen
    var selectedDate: Date

    var navigationTitle: String {
        Formatter.string(for: selectedDate, dateStyle: .full, timeStyle: .none)
    }

    var body: some View {
        List(service.meals[canteen.id] ?? []) { meal in
            NavigationLink(destination: MealDetailView(meal: meal)) {
                MealCell(meal: meal)
            }
        }
        .navigationBarTitle(Text(navigationTitle), displayMode: .inline)
        .onAppear {
            self.service.fetchMeals(for: self.canteen.id, on: self.selectedDate)
        }
    }
}

struct CustomDateMealListView_Previews: PreviewProvider {
    static let settings = Settings()
    static let service = OpenMensaService(settings: Self.settings)

    static var previews: some View {
        service.meals[1] = [
            Meal(id: 1, name: "Mahlzeit 1", notes: [], prices: Meal.Prices(students: 1.5, employees: 1.5), category: "Kategorie", image: Meal.placeholderImageURL, url: Meal.placeholderImageURL),
            Meal(id: 2, name: "Mahlzeit 2", notes: [], prices: Meal.Prices(students: 1.5, employees: 1.5), category: "Kategorie", image: Meal.placeholderImageURL, url: Meal.placeholderImageURL),
        ]

        return NavigationView {
            CustomDateMealListView(canteen: Canteen.example, selectedDate: Date())
        }
        .environmentObject(OpenMensaService(settings: settings))
        .accentColor(.green)
    }
}
