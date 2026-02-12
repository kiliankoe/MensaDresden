import SwiftUI
import os.log

struct AppView: View {
    var body: some View {
        TabView {
            CanteenListView()
                .tabItem {
                    Label("tab.menu", systemImage: "takeoutbag.and.cup.and.straw")
                        .accessibilityIdentifier("tab.menu")
                }

            EmealView()
                .tabItem {
                    Label("tab.emeal", systemImage: "creditcard")
                        .accessibilityIdentifier("tab.emeal")
                }

            NewsfeedView()
                .tabItem {
                    Label("tab.newsfeed", systemImage: "bell")
                        .accessibilityIdentifier("tab.newsfeed")
                }

            SettingsView()
                .tabItem {
                    Label("tab.settings", systemImage: "gear")
                        .accessibilityIdentifier("tab.settings")
                }
        }
        .accentColor(.green)
        .onAppear {
            Logger.breadcrumb.info("Appear AppView")
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
