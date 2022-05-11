import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: IngredientsAllergensSetting()) {
                    Text("settings.ingredients-allergens.title")
                }

                Picker(selection: settings.canteenSortingBinding, label: Text("settings.canteen-sorting")) {
                    ForEach(Settings.CanteenSorting.allCases, id: \.self) { sorting in
                        Text(LocalizedStringKey(sorting.rawValue)).tag(sorting)
                    }
                }

                Picker(selection: settings.priceTypeBinding, label: Text("settings.price-type")) {
                    ForEach(Settings.PriceType.allCases, id: \.self) { priceType in
                        Text(LocalizedStringKey(priceType.rawValue)).tag(priceType)
                    }
                }
            }
        }
        .navigationTitle("settings.nav")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Settings())
            .previewLayout(.fixed(width: 375, height: 1000))
    }
}
