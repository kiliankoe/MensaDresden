import SwiftUI

struct AppView: View {
    var body: some View {
        let tabView = TabView {
            CanteenListView()
                .tabItem {
                    VStack {
                        Image(systemName: "bag")
                        Text("tab.menu")
                    }
                }

            EmealView()
                .tabItem {
                    VStack {
                        Image(systemName: "creditcard")
                        Text("tab.emeal")
                    }
                }

            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("tab.settings")
                    }
                }
        }
        .accentColor(.green)

        if #available(iOS 13.4, *) {
            return AnyView(tabView)
        }
        return AnyView(tabView.edgesIgnoringSafeArea(.top))
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
