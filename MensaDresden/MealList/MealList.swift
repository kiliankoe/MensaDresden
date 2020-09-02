import SwiftUI
import EmealKit
import SwiftyHolidays

struct MealList: View {
    @EnvironmentObject var store: OMStore

    var canteen: Canteen
    @Binding var selectedDate: Date

    @State private var swipeStartPosition: CGPoint = .zero
    @State private var isSwiping = false

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
                                    .gesture(DragGesture()
                                                .onChanged { gesture in
                                                    if isSwiping {
                                                        swipeStartPosition = gesture.location
                                                        isSwiping.toggle()
                                                    }
                                                }
                                                .onEnded { gesture in
                                                    let xDist = abs(gesture.location.x - swipeStartPosition.x)
                                                    let yDist = abs(gesture.location.y - swipeStartPosition.y)
                                                    if swipeStartPosition.x > gesture.location.x && yDist < xDist {
                                                        if selectedDate == .today {
                                                            selectedDate = .tomorrow
                                                        }
                                                    }
                                                    else if swipeStartPosition.x < gesture.location.x && yDist < xDist {
                                                        if selectedDate == .tomorrow {
                                                            selectedDate = .today
                                                        }
                                                    }
                                                    isSwiping.toggle()
                                                }
                                    )
                               }
        )
    }
}

struct MealList_Previews: PreviewProvider {
    static var previews: some View {
        MealList(canteen: Canteen.example, selectedDate: .constant(Date()))
    }
}
