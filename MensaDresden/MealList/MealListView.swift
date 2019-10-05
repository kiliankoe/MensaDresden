import SwiftUI

struct MealListView: View {
    @ObservedObject private var service = MealService()
    @State var canteen: Canteen

    @EnvironmentObject var settings: Settings

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
                NavigationLink(destination: MealDetailView(meal: meal)) {
                    MealCell(meal: meal)
                }
            }
            .navigationBarTitle(canteen.name)
        }
        .navigationBarItems(trailing: BarButtonButton(
            view: settings.favoriteCanteens.contains(canteen.name) ? AnyView(Image(systemName: "heart.fill").foregroundColor(.red)) : AnyView(Image(systemName: "heart")),
            action: {
                self.settings.toggleFavorite(canteen: self.canteen.name)
            }))
        .onAppear {
            self.service.canteenID = self.canteen.id
            self.service.fetchMeals(date: Date())
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static let alteMensa = Canteen(id: 1, name: "Alte Mensa", city: "Dresden", address: "Mommsenstr. 13, 01069 Dresden", coordinates: [51.02696733929933, 13.726491630077364], url: URL(string: "https://www.studentenwerk-dresden.de/mensen/details-alte-mensa.html")!, menu: URL(string: "https://www.studentenwerk-dresden.de/mensen/speiseplan/alte-mensa.html")!)

    static var previews: some View {
        MealListView(canteen: alteMensa)
    }
}
