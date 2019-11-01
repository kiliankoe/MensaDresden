import SwiftUI

struct MealList: View {
    @EnvironmentObject var store: OMStore

    var canteen: Canteen
    var selectedDate: Date

    var body: some View {
        let result = store.meals(for: canteen.id, on: selectedDate)
        return LoadingListView(result: result,
                               noDataMessage: "meals.no-meals-\(Formatter.string(forRelativeDate: selectedDate, to: .today))",
                               noDataSubtitle: selectedDate.isWeekend ? "meals.weekend" : nil,
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
