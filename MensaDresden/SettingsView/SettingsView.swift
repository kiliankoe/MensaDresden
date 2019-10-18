import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        NavigationView {
            List {
                if !settings.favoriteCanteens.isEmpty {
                    NavigationLink(destination: FavoriteCanteensSetting()) {
                        Text("Favorite Canteens")
                    }
                }

                NavigationLink(destination: IngredientsAllergensSetting()) {
                    Text("Ingredients & Allergens")
                }

                Picker(selection: settings.canteenSortingBinding, label: Text("Canteen Sorting")) {
                    ForEach(Settings.CanteenSorting.allCases, id: \.self) { sorting in
                        Text(LocalizedStringKey(sorting.rawValue)).tag(sorting)
                    }
                }

                Section(header: Text("Price Type")) {
                    Picker(selection: settings.priceTypeBinding, label: Text("Price Type")) {
                        ForEach(Settings.PriceType.allCases, id: \.self) { priceType in
                            Text(LocalizedStringKey(priceType.rawValue)).tag(priceType)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Using Autoload? Enter your credentials here to show all latest transactions on the Emeal page. Your credentials are securely saved on this device only and only sent to Studentenwerk servers.")) {
                    TextField("Cardnumber", text: settings.autoloadCardnumberBinding)
                        .textContentType(.username)
                    SecureField("Password", text: settings.autoloadPasswordBinding)
                    NavigationLink(destination: WebView.autoload, label: { Text("Autoload Information") })
                }

                Section(footer: Text("🖖")) {
                    NavigationLink(destination: InfoView()) {
                        Text("About")
                    }
//                    NavigationLink(destination: Text("Open Source Libraries")) {
//                        Text("Open Source Libraries")
//                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings")
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
