import SwiftUI
import os.log

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    @State private var showingAutoloadInformation = false

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
                    TextField(
                        L10n.Settings.autoloadCardnumber,
                        text: $settings.autoloadCardnumber.default("")
                    )
                    .textContentType(.username)

                    SecureField(
                        L10n.Settings.autoloadPassword,
                        text: $settings.autoloadPassword.default("")
                    )
                    
                    Text("settings.autoload-description")
                        .font(.caption)
                    HStack {
                        Image(systemName: "info.circle")
                        Text("settings.autoload-information")

                        Spacer()
                        DisclosureIndicator()
                    }
                    .onTapGesture {
                        self.showingAutoloadInformation.toggle()
                    }
                    .sheet(isPresented: $showingAutoloadInformation) {
                        SafariView(url: URL(string: "https://www.studentenwerk-dresden.de/wirueberuns/aktuelles-uebersicht.html")!)
                    }
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
        .onAppear {
            Logger.breadcrumb.info("Appear SettingsView")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Settings())
            .previewLayout(.fixed(width: 375, height: 1000))
    }
}
