import SwiftUI

struct AppView: View {
    var body: some View {
        let tabView = TabView {
            CanteenListView()
                .tabItem {
                    VStack {
                        Image(systemName: "bag")
                            .accessibility(hidden: true)
                        Text("tab.menu")
                    }
                }

            EmealView()
                .tabItem {
                    VStack {
                        Image(systemName: "creditcard")
                            .accessibility(hidden: true)
                        Text("tab.emeal")
                    }
                }

            NewsfeedView()
                .tabItem {
                    VStack {
                        Image(systemName: "bell")
                            .accessibility(hidden: true)
                        Text("tab.newsfeed")
                    }
                }

            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                            .accessibility(hidden: true)
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
