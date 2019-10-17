import Foundation
import Combine
import CoreNFC

// Huge thanks to Georg Sieber for a reference implementation of this at https://github.com/schorschii/MensaGuthaben-iOS

class Emeal: NSObject, ObservableObject, NFCTagReaderSessionDelegate {
    static var APP_ID  : Int    = 0x5F8415
    static var FILE_ID : UInt8  = 1
    static var DEMO    : Bool   = false

    var cardID: Int = 0

    @UserDefault("emeal.currentbalance", defaultValue: 0)
    var currentBalance: Double {
        didSet {
            lastScan = Date()
        }
    }

    @UserDefault("emeal.lasttransaction", defaultValue: 0)
    var lastTransaction: Double

    @UserDefault("emeal.lastscan", defaultValue: nil)
    var lastScan: Date?

    let objectWillChange = ObservableObjectPublisher()
    var readerSession: NFCTagReaderSession?

    func readCard() {
        readerSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        readerSession?.alertMessage = NSLocalizedString("Hold your Emeal card to your device.", comment: "")
        readerSession?.begin()
    }

    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: NSLocalizedString("Unable to read NFC tag.", comment: ""))
            return
        }

        session.connect(to: tag) { error in
            guard error == nil else {
                session.invalidate(errorMessage: NSLocalizedString("Connection error. Please try again.", comment: ""))
                print(error!.localizedDescription)
                return
            }

            guard case .miFare(let miFareTag) = tag else {
                session.invalidate(errorMessage: NSLocalizedString("Connection error. Please try again.", comment: ""))
                return
            }

//            let idData = miFareTag.identifier
//            let idInt = idData.withUnsafeBytes {
//                $0.load(as: Int.self)
//            }

            var appIdBuffer: [Int] = []
            appIdBuffer.append ((Self.APP_ID & 0xFF0000) >> 16)
            appIdBuffer.append ((Self.APP_ID & 0xFF00) >> 8)
            appIdBuffer.append (Self.APP_ID & 0xFF)

            let appIdByteArray = [UInt8(appIdBuffer[0]), UInt8(appIdBuffer[1]), UInt8(appIdBuffer[2])]
            let selectAppData = Command.selectApp.wrapped(including: appIdByteArray).data()

            miFareTag.send(data: selectAppData) { result in
                guard let _ = try? result.get() else { return }
                let readValueData = Command.readValue.wrapped(including: [Self.FILE_ID]).data()
                miFareTag.send(data: readValueData) { result in
                    var trimmedData = try! result.get()
                    trimmedData.removeLast()
                    trimmedData.removeLast()
                    trimmedData.reverse()
                    let currentBalanceRaw = [UInt8](trimmedData).byteArrayToInt()
                    let currentBalanceValue = currentBalanceRaw.intToEuro()

                    let readLastTransactionData = Command.readLastTransaction.wrapped(including: [Self.FILE_ID]).data()
                    miFareTag.send(data: readLastTransactionData) { result in
                        var lastTransactionValue = 0.0
                        let buf = [UInt8](try! result.get())
                        if buf.count > 13 {
                            let lastTransactionRaw = [buf[13], buf[12]].byteArrayToInt()
                            lastTransactionValue = lastTransactionRaw.intToEuro()
                            DispatchQueue.main.async {
                                self.currentBalance = currentBalanceValue
                                self.lastTransaction = lastTransactionValue
                                self.objectWillChange.send()
                            }
                        }

                        session.invalidate()
                    }
                }
            }
        }
    }
}

private enum Command {
    static let selectApp: UInt8 = 0x5a
    static let readValue: UInt8 = 0x6c
    static let readLastTransaction: UInt8 = 0xf5
}

fileprivate extension UInt8 {
    func wrapped(including parameter: [UInt8]?) -> [UInt8] {
        var buff: [UInt8] = []
        buff.append(0x90)
        buff.append(self)
        buff.append(0x00)
        buff.append(0x00)
        if parameter != nil {
            buff.append(UInt8(parameter!.count))
            for p in parameter! {
                buff.append(p)
            }
        }
        buff.append(0x00)
        return buff
    }
}

fileprivate extension NFCMiFareTag {
    func send(data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        self.sendMiFareCommand(commandPacket: data) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(data))
        }
    }
}

fileprivate extension Array where Element == UInt8 {
    func byteArrayToInt() -> Int {
        var rawValue = 0
        for byte in self {
            rawValue = rawValue << 8
            rawValue = rawValue | Int(byte)
        }
        return rawValue
    }

    func data() -> Data {
        return Data(_: self)
    }
}

fileprivate extension Int {
    func intToEuro() -> Double {
        (Double(self) / 1000).rounded(toPlaces: 2)
    }
}

fileprivate extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
