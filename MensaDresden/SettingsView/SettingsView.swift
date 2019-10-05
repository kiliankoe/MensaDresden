import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings

    var editButton: AnyView {
        if settings.favoriteCanteens.isEmpty {
            return AnyView(EmptyView())
        }
        return AnyView(EditButton())
    }

    func deleteFavorite(at offsets: IndexSet) {
        for idx in offsets {
            settings.favoriteCanteens.remove(at: idx)
        }
    }

    func moveFavorites(fromOffsets offsets: IndexSet, toOffset offset: Int) {
        settings.favoriteCanteens.move(fromOffsets: offsets, toOffset: offset)
    }

    var body: some View {
        List {
            if !settings.favoriteCanteens.isEmpty {
                Section(header: Text("Your favorite canteens. Tap the heart on a canteen's menu to toggle or swipe to delete here.")) {
                    ForEach(settings.favoriteCanteens, id: \.self) { favorite in
                        Text(favorite)
                    }
                    .onMove(perform: moveFavorites(fromOffsets:toOffset:))
                    .onDelete(perform: deleteFavorite(at:))
                }
            }
            Section(header: Text("Deselect any ingredients you don't want to eat. Meals known to be containing them will be grayed out.")) {
                ForEach(Ingredient.allCases, id: \.self) { ingredient in
                    HStack {
                        Text(LocalizedStringKey(String(describing: ingredient)))
                        Spacer()
                        Toggle(isOn: self.settings.ingredientBlacklist.binding(for: ingredient), label: { EmptyView() })
                    }
                }
            }
            Section(header: Text("Same goes for allergens. Uncheck anything you don't want in your food.")) {
                ForEach(Allergen.allCases, id: \.self) { allergen in
                    HStack {
                        Text(LocalizedStringKey(String(describing: allergen)))
                        Spacer()
                        Toggle(isOn: self.settings.allergenBlacklist.binding(for: allergen), label: { EmptyView() })
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarItems(trailing: editButton)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
