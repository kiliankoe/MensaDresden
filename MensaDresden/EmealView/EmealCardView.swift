import SwiftUI

struct EmealCardView: View {
    var amount: Double
    var actualAmount: Double
    var lastTransaction: Double
    var lastScan: Date?

    var amountIsEstimated: Bool {
        amount != actualAmount
    }

    @State private var isShowingEstimationExplanation = false

    var lastScanned: some View {
        VStack(alignment: .leading) {
            if let lastScan = lastScan {
                Text(verbatim: L10n.Emeal.lastScanned)
                    .font(.caption.smallCaps())
                    .foregroundColor(.black)
                    .padding(.top, UIScreen.main.bounds.height * 0.01)
                Text(Formatter.string(for: lastScan, dateStyle: .medium, timeStyle: .short))
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
        }
        .padding(.leading)
        .offset(y: -5)
    }

    var mainBody: some View {
        VStack(alignment: .leading) {
            Text(verbatim: L10n.Emeal.balance)
                .font(.headline.smallCaps())
                .foregroundColor(.white)

            HStack(alignment: .lastTextBaseline) {
                Text("\(amount, specifier: "%.2f")€")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .if(amountIsEstimated) {
                        $0.italic()
                    }
                if amountIsEstimated {
                    Button(action: {
                        self.isShowingEstimationExplanation.toggle()
                    }, label: {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.white)
                    })
                }
            }
            .padding(.bottom, UIScreen.main.bounds.height * 0.02)

            if !amountIsEstimated {
                Text(verbatim: L10n.Emeal.lastTransaction)
                    .font(.subheadline.smallCaps())
                    .foregroundColor(.white)
                Text("\(lastTransaction, specifier: "%.2f")€")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .padding(.leading)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ZStack(alignment: .topLeading) {
                CampuscardView()
                    .cornerRadius(10)
                    .shadow(radius: 10)
                mainBody
                    .shadow(radius: 1)
                    .padding(.vertical)
            }
            lastScanned
        }
        .alert(
            Text(verbatim: L10n.Emeal.estimationExplanationTitle),
            isPresented: $isShowingEstimationExplanation,
            actions: {
                Button(role: .cancel, action: {}) {
                    Text(verbatim: L10n.Emeal.estimationExplanationOkAction)
                }
            },
            message: {
                Text(verbatim: L10n.Emeal.estimationExplanationText(Float(self.actualAmount)))
            }
        )
    }
}

struct EmealCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmealCardView(
                amount: 13.37,
                actualAmount: 15,
                lastTransaction: 3.5,
                lastScan: Date()
            )

            EmealCardView(
                amount: 13.37,
                actualAmount: 13.37,
                lastTransaction: 3.5,
                lastScan: Date()
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
