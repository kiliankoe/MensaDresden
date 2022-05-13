import SwiftUI
import EmealKit
import os.log

struct MealListView: View {
    @State var canteen: Canteen

    @EnvironmentObject var api: API
    @EnvironmentObject var settings: Settings

    @State var showingDatePickerView = false

    @State var selectedDate: Date = .today

    var body: some View {
        VStack {
            Picker(
                "",
                selection: $selectedDate
            ) {
                Text(Formatter.stringForRelativeDate(offsetFromTodayBy: 0, context: .beginningOfSentence)).tag(Date.today)
                Text(Formatter.stringForRelativeDate(offsetFromTodayBy: 1, context: .beginningOfSentence)).tag(Date.tomorrow)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.leading, 20)
            .padding(.trailing, 20)

            MealList(canteen: canteen, selectedDate: $selectedDate)
                .horizontalSwipeGesture {
                    if selectedDate == .today {
                        selectedDate = .tomorrow
                    }
                } onSwipeRight: {
                    if selectedDate == .tomorrow {
                        selectedDate = .today
                    }
                }
        }
        .navigationBarTitle(canteen.name)
        .navigationBarItems(trailing:
            HStack {
                BarButtonButton(
                    view: Image(systemName: "calendar"),
                    action: {
                        self.showingDatePickerView.toggle()
                    }
                )
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
            .environmentObject(self.api)
            .environmentObject(self.settings)
            .accentColor(.green)
        }
        .onAppear {
            Logger.breadcrumb.info("Appear MealListView for \(canteen.name)")
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
