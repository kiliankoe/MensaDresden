import SwiftUI

struct MealListView: View {
    var canteenName = ""

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        return formatter
    }()

    @State var meals: [Meal] = [
        Meal(id: 1, name: "Rindfleischpfanne mit Möhre, Ananas, Mango und Kokosmilch, dazu Mie Nudeln", notes: [""], prices: Meal.Prices(students: 2.9, employees: 4.7), category: "Wok & Grill", image: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/201909/233593.jpg")!, url: URL(string: "https://studentenwerk-dresden.de")!),
        Meal(id: 2, name: "Hausgemachte Kartoffelpuffer mit Wurzelgemüse, dazu Kräuterquark-Dip und Salat", notes: [""], prices: Meal.Prices(students: 2.25, employees: 4.05), category: "fertig 3", image: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/201909/233594.jpg")!, url: URL(string: "https://studentenwerk-dresden.de")!)
    ]

    @State var selectedDate = 0

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
            List(meals) { meal in
                MealCell(meal: meal)
            }
            .navigationBarTitle(canteenName)
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
