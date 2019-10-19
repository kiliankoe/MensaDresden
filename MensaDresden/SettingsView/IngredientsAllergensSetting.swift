import SwiftUI

struct IngredientsAllergensSetting: View {

    @EnvironmentObject var settings: Settings

    var body: some View {
        List {
            Section(header: Text("settings.ingredients-description")) {
                ForEach(Ingredient.allCases, id: \.self) { ingredient in
                    HStack {
                        Text(LocalizedStringKey(String(describing: ingredient)))
                        Spacer()
                        Toggle(isOn: self.settings.ingredientBlacklist.binding(for: ingredient), label: { EmptyView() })
                    }
                }
            }

            Section(header: Text("settings.allergens-description")) {
                ForEach(Allergen.allCases, id: \.self) { allergen in
                    HStack {
                        Text(LocalizedStringKey(String(describing: allergen)))
                        Spacer()
                        Toggle(isOn: self.settings.allergenBlacklist.binding(for: allergen), label: { EmptyView() })
                    }
                }
            }
        }
    }
}

struct IngredientsAllergensSetting_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsAllergensSetting()
    }
}
