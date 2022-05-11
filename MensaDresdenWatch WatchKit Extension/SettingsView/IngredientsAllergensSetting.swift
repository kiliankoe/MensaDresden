import SwiftUI
import EmealKit

struct IngredientsAllergensSetting: View {

    @EnvironmentObject var settings: Settings

    var body: some View {
        Form {
            Section(header: Text("settings.user-diet")) {
                Picker("settings.user-diet", selection: settings.userDietBinding) {
                    ForEach(Settings.DietType.allCases) { dietType in
                        Text(LocalizedStringKey(dietType.rawValue))
                    }
                }
            }

            Section(header: Text("settings.ingredients")) {
                ForEach(Ingredient.allCases, id: \.self) { ingredient in
                    Toggle(isOn: self.settings.ingredientBlacklist.binding(for: ingredient)) {
                        Text(LocalizedStringKey(String(describing: ingredient)))
                    }
                }
            }

            Section(header: Text("settings.allergens")) {
                ForEach(Allergen.allCases, id: \.self) { allergen in
                    Toggle(isOn: self.settings.allergenBlacklist.binding(for: allergen)) {
                        Text(LocalizedStringKey(String(describing: allergen)))
                    }
                }
            }
        }
        .navigationTitle("settings.ingredients-allergens.title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IngredientsAllergensSetting_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsAllergensSetting()
    }
}
