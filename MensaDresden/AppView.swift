import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            CanteenListView()
                .tabItem {
                    VStack {
                        Image(systemName: "takeoutbag.and.cup.and.straw")
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
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
