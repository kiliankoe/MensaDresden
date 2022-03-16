import SwiftUI

struct AppView: View {
    var body: some View {
        let tabView = TabView {
            CanteenListView()
                .tabItem {
                    VStack {
                        Image(systemName: "takeoutbag.and.cup.and.straw")
                            .accessibility(hidden: true)
                        Text("tab.menu")
                    }
                }
                .onAppear {
                    Analytics.send(.openedTabMenu)
                }

            EmealView()
                .tabItem {
                    VStack {
                        Image(systemName: "creditcard")
                            .accessibility(hidden: true)
                        Text("tab.emeal")
                    }
                }
                .onAppear {
                    Analytics.send(.openedTabEmeal)
                }

            NewsfeedView()
                .tabItem {
                    VStack {
                        Image(systemName: "bell")
                            .accessibility(hidden: true)
                        Text("tab.newsfeed")
                    }
                }
                .onAppear {
                    Analytics.send(.openedTabNews)
                }

            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                            .accessibility(hidden: true)
                        Text("tab.settings")
                    }
                }
                .onAppear {
                    Analytics.send(.openedTabSettings)
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
