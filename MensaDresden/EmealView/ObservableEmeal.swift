import Foundation
import Combine
import EmealKit
import StoreKit

class ObservableEmeal: ObservableObject, EmealDelegate {
    @UserDefault("emeal.currentbalance", defaultValue: 0)
    var currentBalance: Double

    @UserDefault("emeal.lasttransaction", defaultValue: 0)
    var lastTransaction: Double

    @UserDefault("emeal.lastscan", defaultValue: nil)
    var lastScanDate: Date?

    public func readData(currentBalance: Double, lastTransaction: Double) {
        self.currentBalance = currentBalance
        self.lastTransaction = lastTransaction
        self.lastScanDate = Date()
        self.objectWillChange.send()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
           }
        }
    }

    @Published var error: Error?

    func invalidate(with error: Error) {
        self.error = error
    }

    private var emeal: Emeal

    init() {
        emeal = Emeal(localizedStrings: .init(
            alertMessage: NSLocalizedString("emeal.nfc-text", comment: ""),
            nfcReadingError: NSLocalizedString("emeal.nfc-reading-error", comment: ""),
            nfcConnectionError: NSLocalizedString("emeal.nfc-connection-error", comment: "")
        ))
        emeal.delegate = self
    }

    func beginNFCSession() {
        emeal.beginNFCSession()
    }
}
