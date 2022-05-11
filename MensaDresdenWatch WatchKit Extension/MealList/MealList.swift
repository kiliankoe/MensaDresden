import SwiftUI
import EmealKit
import SwiftyHolidays

struct MealList: View {
    @EnvironmentObject var api: API
    @EnvironmentObject var settings: Settings

    var canteen: Canteen
    @Binding var selectedDate: Date

    var noDataMessage: LocalizedStringKey {
        switch selectedDate {
        case .today:
            return "meals.no-meals-today"
        case .tomorrow:
            return "meals.no-meals-tomorrow"
        default:
            return "meals.no-meals-other"
        }
    }

    var noDataSubtitle: String? {
        if let holiday = selectedDate.getHoliday(in: .germany(state: .saxony)) {
            return String(format: NSLocalizedString("meals.holiday", comment: ""), holiday.name)
        }
        guard selectedDate.isWeekend else { return nil }
        guard selectedDate == .today || selectedDate == .tomorrow else { return nil }
        return NSLocalizedString("meals.weekend", comment: "")
    }

    var body: some View {
        List {
            LoadingListView(result: api.meals(for: canteen.id, on: selectedDate),
                            noDataMessage: noDataMessage,
                            noDataSubtitle: noDataSubtitle,
                            retryAction: {
                                Task { await self.api.loadMeals(for: self.canteen.id, on: self.selectedDate) }
                            },
                            listView: { meals in
                                 ForEach(meals) { meal in
                                     NavigationLink(destination: MealDetailView(meal: meal)) {
                                         MealCell(meal: meal)
                                     }
                                 }
                            }
            )
            Button(action: {
                self.settings.toggleFavorite(canteen: self.canteen.name)
            }) {
                Label("settings.favorite-canteens", systemImage:  settings.favoriteCanteens.contains(canteen.name) ? "heart.fill" : "heart")
            }
        }
        .refreshable {
            await api.loadMeals(for: canteen.id, on: selectedDate)
        }
        .onAppear {
            Analytics.send(.openedMealList, with: [
                "canteen": self.canteen.name
            ])
        }
    }
}

struct MealList_Previews: PreviewProvider {
    static var previews: some View {
        MealList(canteen: Canteen.example, selectedDate: .constant(Date()))
    }
}
