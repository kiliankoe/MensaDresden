import SwiftUI
import RemoteImage

struct MealDetailView: View {
    var meal: Meal

    @EnvironmentObject var settings: Settings

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
                    if settings.priceTypeIsStudent {
                        PriceLabel(price: meal.prices?.students)
                    } else {
                        PriceLabel(price: meal.prices?.employees)
                    }
                }.padding()

                VStack(alignment: .leading) {
                    ForEach(meal.notes, id: \.self) { note in
                        Text(note)
                            .font(.caption)
                    }
                }.padding(.horizontal)

                FeedbackButton(meal: meal)
                    .padding(.vertical)
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

struct FeedbackButton: View {
    var meal: Meal

    var feedbackURL: URL {
        URL(string: "https://www.studentenwerk-dresden.de/kontakt.html?bereich=mensen&page=mensen_luk&thema=luk&eid=\(meal.id)")!
    }

    var body: some View {
        NavigationLink(destination: WebView(url: feedbackURL).navigationBarTitle("Rate meal", displayMode: .inline)) {
            VStack(alignment: .leading) {
                Text("meal.rate-title")
                Text("meal.rate-description")
                    .foregroundColor(.primary)
                    .font(.caption)
            }
            .padding(.horizontal)
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MealDetailView(meal: Meal.example)
        }
    }
}
