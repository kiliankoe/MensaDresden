import Foundation
import Combine
import EmealKit
import StoreKit

class ObservableEmeal: ObservableObject, EmealDelegate {
    var currentBalance: Double {
        get {
            UserDefaults.standard.double(forKey: "emeal.currentbalance")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "emeal.currentbalance")
            self.objectWillChange.send()
        }
    }

    var lastTransaction: Double {
        get {
            UserDefaults.standard.double(forKey: "emeal.lasttransaction")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "emeal.lasttransaction")
            self.objectWillChange.send()
        }
    }

    var lastScanDate: Date? {
        get {
            UserDefaults.standard.value(forKey: "emeal.lastscan") as? Date
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "emeal.lastscan")
            self.objectWillChange.send()
        }
    }

    public func readData(currentBalance: Double, lastTransaction: Double) {
        self.currentBalance = currentBalance
        self.lastTransaction = lastTransaction
        self.lastScanDate = Date()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            SKStoreReviewController.requestReview()
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
