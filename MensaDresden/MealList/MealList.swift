import SwiftUI
import EmealKit

struct MealList: View {
    @EnvironmentObject var store: OMStore

    var canteen: Canteen
    var selectedDate: Date

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

    var noDataSubtitle: LocalizedStringKey? {
        guard selectedDate.isWeekend else { return nil }
        guard selectedDate == .today || selectedDate == .tomorrow else { return nil }
        return "meals.weekend"
    }

    var body: some View {
        let result = store.meals(for: canteen.id, on: selectedDate)
        return LoadingListView(result: result,
                               noDataMessage: noDataMessage,
                               noDataSubtitle: noDataSubtitle,
                               retryAction: { self.store.loadMeals(for: self.canteen.id, on: self.selectedDate) },
                               listView: { meals in
                                    List(meals) { meal in
                                        NavigationLink(destination: MealDetailView(meal: meal)) {
                                            MealCell(meal: meal)
                                        }
                                    }
                               }
        )
    }
}

struct MealList_Previews: PreviewProvider {
    static var previews: some View {
        MealList(canteen: Canteen.example, selectedDate: Date())
    }
}
