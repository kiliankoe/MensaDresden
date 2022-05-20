import SwiftUI
import Combine
import CoreNFC
import os.log

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

    var shouldShowEmealView: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
        if NFCReaderSession.readingAvailable {
            return true
        }
        return false
        #endif
    }

    // If there are autoload transactions newer than the last scan, we'll
    // use those to calculate an estimated current balance.
    var emealBalance: Double {
        guard let lastScanDate = emeal.lastScanDate,
              case .success(let transactions) = api.transactions(),
              let lastTransactionDate = transactions.last?.date,
              // If the last scan is older than the oldest transaction, the estimation won't be correct anyways,
              // so let's just not do it.
              lastScanDate > lastTransactionDate
        else {
            return emeal.currentBalance
        }

        Logger.breadcrumb.info("Transactions newer than last Emeal scan available, estimating Emeal balance")

        let newerTransactionsSum = transactions
            .filter { $0.date > lastScanDate }
            .reduce(0) { $0 + $1.amount }

        // Emeal balances can't be negative, so we're not going below that. This should only occur if the last scan is
        // over 90 days old (the max for old transactions) and an actual balance can't be calculated.
        return max(emeal.currentBalance + newerTransactionsSum, 0)
    }

    var body: some View {
        NavigationView {
            VStack {
                if shouldShowEmealView {
                    EmealCardView(
                        amount: self.emealBalance,
                        actualAmount: emeal.currentBalance,
                        lastTransaction: emeal.lastTransaction,
                        lastScan: emeal.lastScanDate
                    )
                    .padding(.horizontal)

                    LargeButton(content: {
                        Text("emeal.scan-button")
                    }) {
                        self.emeal.beginNFCSession()
                    }
                    .padding(.horizontal)
                }

                if settings.areAutoloadCredentialsAvailable {
                    LoadingListView(
                        result: api.transactions(),
                        noDataMessage: "emeal.no-transactions",
                        retryAction: {
                            Task { await self.loadTransactions() }
                        },
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
        .onAppear {
            Logger.breadcrumb.info("Appear EmealView")
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
