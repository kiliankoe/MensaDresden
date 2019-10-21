import SwiftUI

struct IngredientsAllergensSetting: View {

    @EnvironmentObject var settings: Settings

    var body: some View {
        Form {
            Section(header: Text("settings.ingredients-description")) {
                ForEach(Ingredient.allCases, id: \.self) { ingredient in
                    Toggle(isOn: self.settings.ingredientBlacklist.binding(for: ingredient)) {
                        Text(LocalizedStringKey(String(describing: ingredient)))
                    }
                }
            }

            Section(header: Text("settings.allergens-description")) {
                ForEach(Allergen.allCases, id: \.self) { allergen in
                    Toggle(isOn: self.settings.allergenBlacklist.binding(for: allergen)) {
                        Text(LocalizedStringKey(String(describing: allergen)))
                    }
                }
            }
        }
        .navigationBarTitle("settings.ingredients-allergens", displayMode: .inline)
    }
}

struct IngredientsAllergensSetting_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsAllergensSetting()
    }
}
