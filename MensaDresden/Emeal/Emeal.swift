import Foundation
import Combine
import CoreNFC

class Emeal: NSObject, ObservableObject, NFCTagReaderSessionDelegate {
    let objectWillChange = ObservableObjectPublisher()
    var readerSession: NFCTagReaderSession?

    func readCard() {
        readerSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        readerSession?.alertMessage = NSLocalizedString("Hold your Emeal card to your device.", comment: "")
        readerSession?.begin()
    }

    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {

    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {

    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: NSLocalizedString("Unable to read NFC tag.", comment: ""))
            return
        }

        session.connect(to: tag) { error in
            guard error == nil else {
                session.invalidate(errorMessage: NSLocalizedString("Connection error. Please try again.", comment: ""))
                return
            }

            if case .miFare(let miFareTag) = tag {
                print(miFareTag)
                session.invalidate(errorMessage: NSLocalizedString("Emeal recognized, but decoding has not yet been implemented.", comment: ""))
            }
        }
    }
}
