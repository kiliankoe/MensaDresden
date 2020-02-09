import SwiftUI
import EmealKit

struct MealFeedbackView: View {
    var meal: Meal

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var showingAlert = false

    @State var title = ""
    @State var lastname: String = ""
    @State var firstname: String = ""
    @State var email: String = ""

    @State var preisLeistung = 1
    @State var sortiment = 1
    @State var speisenqualitaet = 1
    @State var portionsgroesse = 1
    @State var freundlichkeit = 1
    @State var wartezeit = 1

    @State var note: String = ""

    var body: some View {
        Form {
            Section {
                Picker(selection: $title, label: Text("Anrede")) {
                    Text("Herr").tag("Herr")
                    Text("Frau").tag("Frau")
                }
                TextField("Vorname", text: $firstname)
                    .textContentType(.givenName)
                TextField("Nachname", text: $lastname)
                    .textContentType(.familyName)
                TextField("E-Mail", text: $email)
                    .textContentType(.emailAddress)
            }

            Section {
                RatingPicker(selection: $preisLeistung, label: "Preis/Leistung")
                RatingPicker(selection: $sortiment, label: "Sortiment")
                RatingPicker(selection: $speisenqualitaet, label: "Speisenqualität")
                RatingPicker(selection: $portionsgroesse, label: "Portionsgröße")
                RatingPicker(selection: $freundlichkeit, label: "Freundlichkeit")
                RatingPicker(selection: $wartezeit, label: "Wartezeit")
            }

            Section {
                TextField("Nachricht/Bemerkung", text: $note)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Section(footer: Text("Das Feedback wird direkt an das Studentenwerk Dresden gesendet. Die Daten werden dort gespeichert, jedoch nicht an Dritte weitergegeben. Mehr Infos gibts unter https://www.studentenwerk-dresden.de/datenschutz.")) {
                Button("Abschicken", action: {
                    self.showingAlert.toggle()
                    self.presentationMode.wrappedValue.dismiss()
                })
                .disabled(lastname.isEmpty || firstname.isEmpty || email.isEmpty)
            }
        }
        .navigationBarTitle("Feedback", displayMode: .inline)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Danke!"))
        }
    }
}

struct RatingPicker: View {
    @Binding var selection: Int
    var label: String

    static let ratingOptions = ["❤️", "👍", "😐", "👎", "💔"]

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
            Picker(selection: $selection, label: Text(label)) {
                ForEach(0..<Self.ratingOptions.count) { idx in
                    Text(Self.ratingOptions[idx]).tag(idx)
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct MealFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MealFeedbackView(meal: Meal.example)
        }
    }
}
