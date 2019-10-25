import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        NavigationView {
            List {
                if !settings.favoriteCanteens.isEmpty {
                    NavigationLink(destination: FavoriteCanteensSetting()) {
                        Text("settings.favorite-canteens")
                    }
                }

                NavigationLink(destination: IngredientsAllergensSetting()) {
                    Text("settings.ingredients-allergens")
                }

                Picker(selection: settings.canteenSortingBinding, label: Text("settings.canteen-sorting")) {
                    ForEach(Settings.CanteenSorting.allCases, id: \.self) { sorting in
                        Text(LocalizedStringKey(sorting.rawValue)).tag(sorting)
                    }
                }

                Section(header: Text("settings.price-type")) {
                    Picker(selection: settings.priceTypeBinding, label: Text("settings.price-type")) {
                        ForEach(Settings.PriceType.allCases, id: \.self) { priceType in
                            Text(LocalizedStringKey(priceType.rawValue)).tag(priceType)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("settings.autoload-description")) {
                    TextField("settings.autoload-cardnumber", text: settings.autoloadCardnumberBinding)
                        .textContentType(.username)
                    SecureField("settings.autoload-password", text: settings.autoloadPasswordBinding)
                    NavigationLink(destination: WebView.autoload, label: { Text("settings.autoload-information") })
                }

                Section(footer: Text("🖖")) {
                    NavigationLink(destination: InfoView()) {
                        Text("settings.about")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("settings.nav")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Settings())
    }
}
