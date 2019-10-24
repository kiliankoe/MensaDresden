import SwiftUI

struct MealListView: View {
    @State var canteen: Canteen

    @EnvironmentObject var service: OpenMensaService
    @EnvironmentObject var settings: Settings

    var body: some View {
        VStack {
            Picker("Date", selection: $service.day) {
                Text(Formatter.stringForRelativeDate(offsetFromTodayBy: 0)).tag(Date.today)
                Text(Formatter.stringForRelativeDate(offsetFromTodayBy: 1)).tag(Date.tomorrow)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.leading, 20)
            .padding(.trailing, 20)

            List(service.meals[canteen.id] ?? []) { meal in
                NavigationLink(destination: MealDetailView(meal: meal)) {
                    MealCell(meal: meal)
                }
            }
            .navigationBarTitle(canteen.name)
        }
        .navigationBarItems(trailing:
            HStack {
                BarButtonNavigationLink(destination: DatePickerView(canteen: canteen), image: Image(systemName: "calendar"))
                    .padding(.trailing, 10)
                BarButtonButton(
                    view: settings.favoriteCanteens.contains(canteen.name) ? AnyView(Image(systemName: "heart.fill").foregroundColor(.red)) : AnyView(Image(systemName: "heart")),
                    action: {
                        self.settings.toggleFavorite(canteen: self.canteen.name)
                    }
                )
            }
        )
        .onAppear {
            self.service.fetchMeals(for: self.canteen.id, on: self.service.day)
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static let settings = Settings()
    static let service = OpenMensaService(settings: Self.settings)

    static var previews: some View {
        let settings = Settings()

        service.meals[1] = [
            Meal(id: 1, name: "Mahlzeit 1", notes: [], prices: Meal.Prices(students: 1.5, employees: 1.5), category: "Kategorie", image: Meal.placeholderImageURL, url: Meal.placeholderImageURL),
            Meal(id: 2, name: "Mahlzeit 2", notes: [], prices: Meal.Prices(students: 1.5, employees: 1.5), category: "Kategorie", image: Meal.placeholderImageURL, url: Meal.placeholderImageURL),
        ]

        return NavigationView {
            MealListView(canteen: Canteen.example)
        }
        .environmentObject(OpenMensaService(settings: settings))
        .environmentObject(settings)
        .accentColor(.green)
    }
}
