import SwiftUI
import Combine
import CoreNFC

struct EmealView: View {
    @EnvironmentObject var service: OpenMensaService
    @EnvironmentObject var settings: Settings

    @ObservedObject var emeal = Emeal()

    static var transactionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                if NFCReaderSession.readingAvailable {
                    EmealCardView(amount: emeal.currentBalance, lastTransaction: emeal.lastTransaction)
                        .padding(.horizontal)

                    LargeButton(content: {
                        Text("Scan Mensa Card")
                    }) {
                        self.emeal.readCard()
                    }
                    .padding(.horizontal)
                }

                if settings.areAutoloadCredentialsAvailable {
                    List(service.transactions, id: \.id) { transaction in
                        VStack(alignment: .leading) {
                            Text(Self.transactionDateFormatter.string(from: transaction.date))
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
                } else {
                    VStack(alignment: .leading) {
                        Text("Using Autoload? Enter your credentials in the app's settings and all of your recent transactions will show up here.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                        NavigationLink(destination: WebView(url: URL(string: "https://www.studentenwerk-dresden.de/mensen/emeal-autoload.html")!)) {
                            Text("Autoload Information")
                                .font(.caption)
                        }
                    }
                    .padding(.top)
                }

                Spacer()
            }
            .navigationBarTitle("Emeal")
            .navigationBarItems(trailing: NavigationLink(
                destination: ScrollView { Text("emeal.info").padding() },
                label: { Image(systemName: "info.circle").imageScale(.large) }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.service.getTransactions()
        }
    }
}

struct EmealView_Previews: PreviewProvider {
    static var previews: some View {
        EmealView()
    }
}
