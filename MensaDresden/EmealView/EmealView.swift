import SwiftUI
import Combine
import CoreNFC

struct EmealView: View {
    @EnvironmentObject var service: OpenMensaService
    @EnvironmentObject var settings: Settings

    @ObservedObject var emeal = Emeal()

    var transactionList: some View {
        List(service.transactions, id: \.id) { transaction in
            VStack(alignment: .leading) {
                Text(Formatter.string(for: transaction.date, dateStyle: .medium, timeStyle: .short))
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack {
                    Text(transaction.location)
                    Spacer()
                    Text("\(transaction.amount, specifier: "%.2f")€")
                }
                ForEach(transaction.positions, id: \.id) { pos in
                    HStack {
                        Text(pos.name)
                        Spacer()
                        Text("\(pos.price, specifier: "%.2f")€")
                    }
                    .font(.caption)
                }
            }
        }
    }

    var autoloadHint: some View {
        VStack(alignment: .leading) {
            Text("emeal.autoload-hint")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            NavigationLink(destination: WebView.autoload) {
                Text("emeal.autoload-information")
                    .font(.caption)
            }
        }
        .padding(.top)
        .padding(.horizontal)
    }

    var body: some View {
        NavigationView {
            VStack {
                if NFCReaderSession.readingAvailable {
                    EmealCardView(amount: emeal.currentBalance, lastTransaction: emeal.lastTransaction, lastScan: emeal.lastScan)
                        .padding(.horizontal)

                    LargeButton(content: {
                        Text("emeal.scan-button")
                    }) {
                        self.emeal.readCard()
                    }
                    .padding(.horizontal)
                }

                if settings.areAutoloadCredentialsAvailable {
                    transactionList
                } else {
                    autoloadHint
                }

                Spacer()
            }
            .navigationBarTitle("Emeal")
            .navigationBarItems(trailing: NavigationLink(
                destination: ScrollView { Text("emeal.info").padding() },
                label: { Image(systemName: "info.circle").imageScale(.large) }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: { () -> Void in
            self.service.getTransactions()
        })
    }
}

struct EmealView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()

        return EmealView()
            .environmentObject(OpenMensaService(settings: settings))
            .environmentObject(settings)
    }
}
