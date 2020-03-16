import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
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

            NewsfeedView()
                .tabItem {
                    VStack {
                        Image(systemName: "bell")
                        Text("tab.newsfeed")
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
        .edgesIgnoringSafeArea(.top)
        .accentColor(.green)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
