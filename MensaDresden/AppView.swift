import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            CanteenListView()
                .tabItem {
                    VStack {
                        Image(systemName: "bag")
                        Text("Menu")
                    }
                }

            EmealView()
                .tabItem {
                    VStack {
                        Image(systemName: "creditcard")
                        Text("Emeal")
                    }
                }

            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
