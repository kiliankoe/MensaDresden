import SwiftUI
import RemoteImage

struct MealDetailView: View {
    var meal: Meal?

    var body: some View {
        VStack(alignment: .leading) {
            RemoteImage(url: meal!.image, errorView: { error in
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
                Text(meal!.category)
                    .font(Font.callout.smallCaps())
                    .foregroundColor(.gray)
                Text(meal!.name)
                    .font(.headline)
                    .lineLimit(5)
                HStack {
                    PriceLabel(price: meal?.prices?.students)
                    PriceLabel(price: meal?.prices?.employees)
                }

                ForEach(meal!.notes, id: \.self) { note in
                    Text(note).font(.caption)
                }
            }.padding()

            Spacer()
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            UIApplication.shared.open(self.meal!.url, options: [:], completionHandler: nil)
        }) {
            Image(systemName: "globe")
        })
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
//        MealDetailView()
    }
}

extension String: Identifiable {
    public var id: String {
        return self
    }
}
