import Foundation
import EmealKit

extension Transaction {
    init(id: Int, date: Date, location: String, kind: Transaction.Kind, amount: Double, positions: [Position]) {
        self.init(clientID: 0, id: id, transactionID: "0", date: date, location: location, register: "", kind: kind, amount: amount, positions: positions)
    }

    static var exampleValues: [Transaction] {
        [
            Transaction(id: 0, date: Date(timeIntervalSince1970: 1571242020), location: "Mensa Wundtstraße", kind: .cardCharge, amount: 10, positions: [
                Position(id: 0, name: "Aufwertung", price: 10)
            ]),
            Transaction(id: 1, date: Date(timeIntervalSince1970: 1571242020), location: "Mensa Wundtstraße", kind: .sale, amount: 6, positions: [
                Position(id: 0, name: "Surfing Paradise", price: 6)
            ]),
            Transaction(id: 2, date: Date(timeIntervalSince1970: 1571132100), location: "Alte Mensa", kind: .sale, amount: 3.7, positions: [
                Position(id: 0, name: "Sushi Menü", price: 3.7)
            ]),
            Transaction(id: 3, date: Date(timeIntervalSince1970: 1571045400), location: "Alte Mensa", kind: .sale, amount: 3.74, positions: [
                Position(id: 0, name: "Pasta groß", price: 2.46),
                Position(id: 1, name: "Waage kleine Schüssel HAM", price: 1.28)
            ])
        ]
    }
}

extension Transaction.Position {
    init(id: Int, name: String, price: Double) {
        self.init(clientID: 0, id: id, transactionID: "0", positionID: 1, name: name, amount: 1, price: price, totalPrice: price, rating: 0)
    }
}

