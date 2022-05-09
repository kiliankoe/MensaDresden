import SwiftUI
import EmealKit
import RemoteImage
import ImageViewerRemote

struct MealDetailContainerView: View {
    let meal: Meal

    @EnvironmentObject var settings: Settings

    var passesFilters: Bool {
        let diet = Settings.DietType(rawValue: settings.userDiet)!
        switch diet {
        case .vegan:
            if !meal.diet.contains(.vegan) {
                return false
            }
        case .vegetarian:
            if !meal.diet.contains(.vegetarian) && !meal.diet.contains(.vegan) {
                return false
            }
        case .all:
            break
        }
        return !meal.contains(unwantedIngredients: settings.ingredientBlacklist.storage,
                              unwantedAllergens: settings.allergenBlacklist.storage)
    }

    var body: some View {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            MealDetailView(meal: meal, passesFilters: passesFilters)
        default:
            LargeMealDetailView(meal: meal, passesFilters: passesFilters)
        }
    }
}

struct LargeMealDetailView: View {
    let meal: Meal

    @State private var showingDetailView = false

    @EnvironmentObject var settings: Settings

    let passesFilters: Bool

    private var isPlaceholder: Bool {
        meal.imageIsPlaceholder && meal.emoji == nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                ZStack(alignment: .bottomLeading) {
                    MealImage(meal: meal, contentMode: .fit)
                    .onTapGesture {
                        if !meal.imageIsPlaceholder {
                            self.showingDetailView.toggle()
                        }
                    }

                    if settings.priceTypeIsStudent {
                        PriceLabel(price: meal.prices?.students, shadow: 2)
                            .padding(.bottom, 10)
                    } else {
                        PriceLabel(price: meal.prices?.employees, shadow: 2)
                            .padding(.bottom, 10)
                    }
                }
                .frame(width: 450)
                .clipShape(RoundedRectangle(cornerRadius: isPlaceholder ? 0 : 15))
                .padding()

                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        if meal.isDinner {
                            Image(systemName: "moon.fill")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .accessibility(label: Text("meal.dinner"))
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

                    Text(meal.allergenStrippedTitle)
                        .font(.title)

                    FeedbackButton(meal: meal)
                }
            }

            if !passesFilters {
                Text("meal.ingredient-warning")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            HStack {
                ForEach(meal.ingredients, id: \.rawValue) { ingredient in
                    Text(ingredient.emoji)
                        .font(.system(size: 50))
                        .accessibility(label: Text(LocalizedStringKey(ingredient.rawValue)))
                }
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                ForEach(meal.notes, id: \.self) { note in
                    Text(note)
                        .font(.callout)
                }
            }
            .padding(.horizontal)

            Text(meal.name)
                .font(.caption)
                .padding(.horizontal)

            Spacer()
        }
        .padding(.horizontal)
        .overlay(ImageViewerRemote(
            imageURL: .constant(meal.image.absoluteString),
            viewerShown: $showingDetailView,
            aspectRatio: nil,
            disableCache: nil,
            caption: Text(meal.allergenStrippedTitle),
            closeButtonTopRight: nil
        ))
    }
}

struct MealDetailView: View {
    let meal: Meal

    @State private var showingDetailView = false

    @EnvironmentObject var settings: Settings

    let passesFilters: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                ZStack(alignment: .bottomLeading) {
                    MealImage(meal: meal, contentMode: .fit)
                    .onTapGesture {
                        if !meal.imageIsPlaceholder {
                            self.showingDetailView.toggle()
                        }
                    }

                    if settings.priceTypeIsStudent {
                        PriceLabel(price: meal.prices?.students, shadow: 2)
                            .padding(.bottom, 10)
                    } else {
                        PriceLabel(price: meal.prices?.employees, shadow: 2)
                            .padding(.bottom, 10)
                    }
                }

                HStack {
                    if meal.isDinner {
                        Image(systemName: "moon.fill")
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .accessibility(label: Text("meal.dinner"))
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

                Text(meal.allergenStrippedTitle)
                    .font(.title)
                    .padding(.horizontal)

                if !passesFilters {
                    Text("meal.ingredient-warning")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                HStack {
                    ForEach(meal.ingredients, id: \.rawValue) { ingredient in
                        Text(ingredient.emoji)
                            .font(.system(size: 30))
                            .accessibility(label: Text(LocalizedStringKey(ingredient.rawValue)))
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    ForEach(meal.notes, id: \.self) { note in
                        Text(note)
                            .font(.caption)
                    }
                }.padding(.horizontal)

                Text(meal.name)
                    .font(.caption)
                    .padding(.bottom)
                    .padding(.horizontal)

                FeedbackButton(meal: meal)
                    .padding([.bottom, .horizontal])
            }
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: BarButtonButton(view: Image(systemName: "square.and.arrow.up"), action: {
            let activityItems = [self.meal.activityItem]
            let activityVC = UIActivityViewController(activityItems: activityItems,
                                                      applicationActivities: nil)
            
            let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene)
            windowScene?.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }))
        .overlay(ImageViewerRemote(
            imageURL: .constant(meal.image.absoluteString),
            viewerShown: $showingDetailView,
            aspectRatio: nil,
            disableCache: nil,
            caption: nil,
            closeButtonTopRight: nil
        ))
    }
}

struct FeedbackButton: View {
    var meal: Meal

    @State private var webviewIsActive: Bool = false

    var feedbackURL: URL {
        URL(string: "https://www.studentenwerk-dresden.de/kontakt.html?bereich=mensen&page=mensen_luk&thema=luk&eid=\(meal.id)")!
    }

    var body: some View {
        NavigationLink(
            destination: WebView(url: feedbackURL).navigationBarTitle("meal.rate-title", displayMode: .inline),
            isActive: $webviewIsActive
        ) {
            HStack {
                Spacer()
                
                VStack(alignment: .center, spacing: 3) {
                    if #available(iOS 14, *) {
                        Label("meal.rate-title", systemImage: "hand.thumbsup.fill")
                            .font(.headline)
                    } else {
                        HStack {
                            Image(systemName: "hand.thumbsup.fill")
                                .accessibility(hidden: true)
                            Text("meal.rate-title")
                                .font(.headline)
                        }
                    }
                    Text("meal.rate-description")
                    .font(.caption)
                }
                .foregroundColor(.white)

                Spacer()
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.emealGreen)
            )
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyView()
            MealDetailContainerView(meal: Meal.examples[0])
                .environmentObject(Settings())
        }
        .accentColor(.green)
    }
}
