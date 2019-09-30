import SwiftUI

struct Meal: Identifiable {
    let id: Int
    let name: String
    let category: String
    let studentPrice: Double
    let employeePrice: Double
    let imageURL: URL
}

struct MealListView: View {
    var canteenName = ""

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        return formatter
    }()

    @State var meals: [Meal] = [
        Meal(id: 1, name: "Rindfleischpfanne mit Möhre, Ananas, Mango und Kokosmilch, dazu Mie Nudeln", category: "Wok & Grill", studentPrice: 2.9, employeePrice: 4.7, imageURL: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/201909/233593.jpg")!),
        Meal(id: 2, name: "Hausgemachte Kartoffelpuffer mit Wurzelgemüse, dazu Kräuterquark-Dip und Salat", category: "fertig 3", studentPrice: 2.25, employeePrice: 4.05, imageURL: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/201909/233594.jpg")!),
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
