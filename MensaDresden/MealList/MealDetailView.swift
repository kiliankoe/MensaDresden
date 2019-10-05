import SwiftUI
import RemoteImage

struct MealDetailView: View {
    var meal: Meal

    var body: some View {
        VStack(alignment: .leading) {
            RemoteImage(url: meal.image, errorView: { error in
                Text(error.localizedDescription)
            }, imageView: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width)
            }) {
                Text("Image loading...")
            }

            VStack(alignment: .leading) {
                Text(meal.category)
                    .font(Font.headline.smallCaps())
                    .foregroundColor(.gray)
                    .padding(.bottom)
                Text(meal.name)
                    .font(.title)
                    .lineLimit(5)
                    .layoutPriority(1)

                HStack {
                    PriceLabel(price: meal.prices?.students)
                    PriceLabel(price: meal.prices?.employees)
                }.padding(.vertical)

                ForEach(meal.notes, id: \.self) { note in
                    Text(note).font(.caption)
                }
            }.padding()

            Spacer()
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: BarButtonButton(action: {
            UIApplication.shared.open(self.meal.url, options: [:], completionHandler: nil)
        }, image: Image(systemName: "globe")))
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static let meal = Meal(id: 1, name: "Rahmsoße mit Tomaten und Zucchini", notes: [], prices: nil, category: "Pasta", image: URL(string: "https://static.studentenwerk-dresden.de/bilder/mensen/studentenwerk-dresden-lieber-mensen-gehen.jpg")!, url: URL(string: "https://www.studentenwerk-dresden.de/mensen/speiseplan/details-233603.html")!)

    static var previews: some View {
        MealDetailView(meal: meal)
    }
}

extension String: Identifiable {
    public var id: String {
        return self
    }
}
