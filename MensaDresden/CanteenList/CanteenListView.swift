import SwiftUI
import MapKit

struct CanteenListView: View {
    @ObservedObject private var service = CanteenService()

    var body: some View {
        NavigationView {
            List(service.canteens) { canteen in
                NavigationLink(destination: MealListView(canteen: canteen)) {
                    CanteenCell(canteen: canteen)
                }
            }
            .navigationBarTitle("Canteens")
        }
        .onAppear {
            self.service.fetchCanteens()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CanteenListView()
    }
}
