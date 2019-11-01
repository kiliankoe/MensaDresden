import SwiftUI

struct MealListView: View {
    @State var canteen: Canteen

    @EnvironmentObject var store: OMStore
    @EnvironmentObject var settings: Settings

    @State var showingDatePickerView = false

    @State var selectedDate: Date = .today {
        didSet {
            store.loadMeals(for: canteen.id, on: selectedDate)
        }
    }

    var body: some View {
        VStack {
            Picker("", selection: $selectedDate) {
                Text(Formatter.stringForRelativeDate(offsetFromTodayBy: 0)).tag(Date.today)
                Text(Formatter.stringForRelativeDate(offsetFromTodayBy: 1)).tag(Date.tomorrow)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.leading, 20)
            .padding(.trailing, 20)

            MealList(canteen: canteen, selectedDate: selectedDate)
        }
        .navigationBarTitle(canteen.name)
        .navigationBarItems(trailing:
            HStack {
                BarButtonButton(view: Image(systemName: "calendar"), action: { self.showingDatePickerView.toggle() })
                    .padding(.trailing, 10)
                BarButtonButton(
                    view: settings.favoriteCanteens.contains(canteen.name) ? AnyView(Image(systemName: "heart.fill").foregroundColor(.red)) : AnyView(Image(systemName: "heart")),
                    action: {
                        self.settings.toggleFavorite(canteen: self.canteen.name)
                    }
                )
            }
        )
        .sheet(isPresented: $showingDatePickerView) {
            NavigationView {
                DatePickerView(canteen: self.canteen)
            }
            // Is this a bug that this is necessary? Shouldn't the environment be global?
            .environmentObject(self.store)
            .environmentObject(self.settings)
            .accentColor(.green)
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
        .environmentObject(OMStore(settings: settings))
        .accentColor(.green)
    }
}
