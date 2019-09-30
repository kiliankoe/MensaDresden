import SwiftUI

struct MealListView: View {
    @ObservedObject private var service = MealService()
    @State var canteen: Canteen?
    @State var selectedDate = 0

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        return formatter
    }()

    var body: some View {
        VStack {
            HStack {
                Picker("Date", selection: $selectedDate) {
                    Text("Today").tag(0)
                    Text("Tomorrow").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }
            List(service.meals) { meal in
                MealCell(meal: meal)
            }
            .navigationBarTitle(canteen!.name)
        }
        .onAppear {
            self.service.fetchMeals(for: self.canteen!.id, date: Date())
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
