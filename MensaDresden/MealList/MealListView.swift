import SwiftUI

struct MealListView: View {
    @ObservedObject private var service = MealService()
    @State var canteen: Canteen?

    var body: some View {
        VStack {
            HStack {
                Picker("Date", selection: $service.dateOffset) {
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
            self.service.canteenID = self.canteen!.id
            self.service.fetchMeals(date: Date())
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
