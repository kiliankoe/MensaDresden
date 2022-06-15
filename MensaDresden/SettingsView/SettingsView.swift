import SwiftUI
import os.log

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

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
                        Label {
                            Text("settings.favorite-canteens")
                        } icon: {
                            Image(systemName: "star")
                        }
                    }
                }

                NavigationLink(destination: IngredientsAllergensSetting()) {
                    Label {
                        Text("settings.ingredients-allergens.title")
                    } icon: {
                        Image(systemName: "leaf")
                    }
                }

                Picker(
                    selection: settings.canteenSortingBinding,
                    label:
                        Label {
                            Text("settings.canteen-sorting")
                        } icon: {
                            Image(systemName: "list.number")
                        }
                ) {
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

                    Label {
                        HStack {
                            Text("settings.autoload-information")
                            Spacer()
                            DisclosureIndicator()
                        }
                        .contentShape(Rectangle())
                    } icon: {
                        Image(systemName: "info.circle")
                    }
                    .onTapGesture {
                        SafariView(url: URL(string: "https://www.studentenwerk-dresden.de/mensen/emeal-autoload.html")!).present()
                    }
                }

                Section(footer: Text("✌️")) {
                    Button {
                        UIApplication.shared.open(URL(string: "mailto:mensadresden@kilian.io?subject=Feedback%20\(shortVersion)%20(\(version))")!)
                    } label: {
                        Label {
                            HStack {
                                Text("info.email")
                                Spacer()
                                DisclosureIndicator()
                            }
                            .containerShape(Rectangle())
                        } icon: {
                            Image(systemName: "envelope")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())

                    NavigationLink(destination: LicenseView()) {
                        Label {
                            Text(verbatim: L10n.Licenses.title)
                        } icon: {
                            Image(systemName: "book.closed")
                        }
                    }

                    NavigationLink(destination: AboutView()) {
                        Label {
                            Text("settings.about")
                        } icon: {
                            Image(systemName: "questionmark.circle")
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
