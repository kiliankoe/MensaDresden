import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var omStore: OMStore

    var autoloadCardnumberBinding: Binding<String> {
        Binding<String>(
            get: {
                settings.autoloadCardnumber ?? ""
            },
            set: { newValue in
                settings.autoloadCardnumber = newValue
                omStore.clearTransactionCache()
            }
        )
    }

    var autoloadPasswordBinding: Binding<String> {
        Binding<String>(
            get: {
                settings.autoloadPassword ?? ""
            },
            set: { newValue in
                settings.autoloadPassword = newValue
                omStore.clearTransactionCache()
            }
        )
    }

    var shortVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var version: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }

    var body: some View {
        NavigationView {
            List {
                if !settings.favoriteCanteens.isEmpty {
                    NavigationLink(destination: FavoriteCanteensSetting()) {
                        HStack {
                            Image(systemName: "star")
                            Text("settings.favorite-canteens")
                        }
                    }
                }

                NavigationLink(destination: IngredientsAllergensSetting()) {
                    HStack {
                        Image(systemName: "leaf")
                        Text("settings.ingredients-allergens.title")
                    }
                }

                Picker(selection: settings.canteenSortingBinding,
                       label: HStack {
                        Image(systemName: "list.number")
                        Text("settings.canteen-sorting")
                       }) {
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

                Section(header: Text("Autoload")) {
                    TextField(LocalizedStringKey("settings.autoload-cardnumber"), text: autoloadCardnumberBinding, prompt: nil)
                        .textContentType(.username)

                    SecureField(LocalizedStringKey("settings.autoload-password"), text: autoloadPasswordBinding, prompt: nil)
                    
                    Text("settings.autoload-description")
                        .font(.caption)
                    NavigationLink(destination: WebView.autoload,
                        label: {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("settings.autoload-information")
                            }
                        })
                }

                Section(footer: Text("✌️")) {
                    Button {
                        UIApplication.shared.open(URL(string: "mailto:mensadresden@kilian.io?subject=Feedback%20\(shortVersion)%20(\(version))")!)
                    } label: {
                        HStack {
                            Image(systemName: "envelope")
                            Text("info.email")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())

//                    Button {
//                        UIApplication.shared.open(URL(string: "https://poeditor.com/join/project/qAgTstzLia")!)
//                    } label: {
//                        HStack {
//                            Image(systemName: "text.quote")
//                            Text("info.translate")
//                        }
//                    }
//                    .buttonStyle(PlainButtonStyle())

                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                            Text("settings.about")
                        }
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
            .previewLayout(.fixed(width: 375, height: 1000))
    }
}
