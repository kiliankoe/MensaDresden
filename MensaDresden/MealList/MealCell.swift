import SwiftUI
import RemoteImage

struct MealCell: View {
    var meal: Meal

    var body: some View {
        HStack {
            MealImage(imageURL: meal.imageURL)
            VStack(alignment: .leading) {
                Text(meal.category)
                    .font(Font.caption.smallCaps())
                    .foregroundColor(.gray)

                Text(meal.name)
                    .lineLimit(3)
                    .padding(.top, 1)

                HStack {
                    PriceLabel(price: "2,80€")
                    PriceLabel(price: "4,70€")
                }
            }
        }
    }
}

struct MealCell_Previews: PreviewProvider {
    static var previews: some View {
        MealCell(meal: Meal(id: 1,
                            name: "Rindfleischpfanne mit Möhre, Ananas, Mango und Kokosmilch, dazu Mie Nudeln",
                            category: "Wok & Grill",
                            studentPrice: 2.9,
                            employeePrice: 4.7,
                            imageURL: URL(string: "https://bilderspeiseplan.studentenwerk-dresden.de/m18/201909/233593.jpg")!))
    }
}
