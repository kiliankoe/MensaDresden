import SwiftUI
import Combine
import CoreNFC

struct EmealView: View {
    @EnvironmentObject var api: API
    @EnvironmentObject var settings: Settings

    @ObservedObject var emeal = ObservableEmeal()

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
                    EmealCardView(amount: $emeal.currentBalance,
                                  lastTransaction: $emeal.lastTransaction,
                                  lastScan: $emeal.lastScanDate)
                        .padding(.horizontal)

                    LargeButton(content: {
                        Text("emeal.scan-button")
                    }) {
                        self.emeal.beginNFCSession()
                    }
                    .padding(.horizontal)
                }

                if settings.areAutoloadCredentialsAvailable {
                    LoadingListView(result: api.transactions(),
                                    noDataMessage: "emeal.no-transactions",
                                    retryAction: { Task { await self.loadTransactions() } },
                                    listView: { transactions in
                                        List(transactions, id: \.id) { transaction in
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
                                        .listStyle(PlainListStyle())
                                        .refreshable {
                                            await self.loadTransactions()
                                        }
                                    }
                    )
                } else {
                    autoloadHint
                }

                Spacer()
            }
            .navigationBarTitle("Emeal")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .task {
            await loadTransactions()
        }
    }

    func loadTransactions() async {
        guard let cardnumber = settings.autoloadCardnumber,
              let password = settings.autoloadPassword
        else { return }
        await api.loadTransactions(cardnumber: cardnumber, password: password)
    }
}

struct EmealView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()

        return EmealView()
            .environmentObject(API())
            .environmentObject(settings)
    }
}
