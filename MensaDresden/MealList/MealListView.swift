import SwiftUI

struct MealListView: View {
    @ObservedObject var service: OpenMensaService
    @State var canteen: Canteen

    @EnvironmentObject var settings: Settings

    var body: some View {
        VStack {
            HStack {
                Picker("Date", selection: $service.day) {
                    Text("Today").tag(Day.today)
                    Text("Tomorrow").tag(Day.tomorrow)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }
            List(service.meals[canteen.id] ?? []) { meal in
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
            self.service.fetchMeals(for: self.canteen.id, on: self.service.day)
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static let settings = Settings()
    static let service = OpenMensaService(settings: Self.settings)

    static var previews: some View {
        MealListView(service: service, canteen: Canteen.example)
    }
}
