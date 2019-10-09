import SwiftUI
import RemoteImage

struct MealDetailView: View {
    var meal: Meal

    @State private var showingShareSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                MealImage(imageURL: meal.image, width: UIScreen.main.bounds.width, roundedCorners: false, contentMode: .fit)
                    .padding(.bottom)

                HStack {
                    if meal.isDinner {
                        Image(systemName: "moon.fill")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                    Text(meal.category)
                        .font(Font.headline.smallCaps())
                        .foregroundColor(.gray)

                    Spacer()

                    ForEach(meal.diet, id: \.self) { diet in
                        Text(LocalizedStringKey(String(describing: diet)))
                            .font(Font.headline.smallCaps())
                            .bold()
                            .foregroundColor(.green)
                            .lineLimit(1)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)


                Text(meal.name)
                    .font(.title)
                    .lineLimit(5)
                    .layoutPriority(1)
                    .padding(.horizontal)

                HStack {
                    PriceLabel(price: meal.prices?.students)
                    PriceLabel(price: meal.prices?.employees)
                }.padding()

                VStack(alignment: .leading) {
                    ForEach(meal.notes, id: \.self) { note in
                        Text(note)
                            .font(.caption)
                    }
                }.padding(.horizontal)

                Spacer()
            }
        }
        // FIXME: This is far from ideal, but is the best thing I can currently come up with.
        .sheet(isPresented: $showingShareSheet, content: { ShareSheet(sharing: [self.meal.activityItem]) })
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: BarButtonButton(view: Image(systemName: "square.and.arrow.up"), action: {
            self.showingShareSheet.toggle()
        }))
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
