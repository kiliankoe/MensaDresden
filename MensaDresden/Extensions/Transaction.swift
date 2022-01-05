import Foundation
import EmealKit

extension Transaction {
    init(id: Int, date: Date, location: String, kind: Transaction.Kind, amount: Double, positions: [Position]) {
        self.init(clientID: 0, id: id, transactionID: "0", date: date, location: location, register: "", kind: kind, amount: amount, positions: positions)
    }

    static var exampleValues: [Transaction] {
        let calendar = Calendar(identifier: .gregorian)
        let date_0 = Date()
        let date_3 = calendar.date(byAdding: .day, value: -3, to: date_0)!
        let date_2 = calendar.date(byAdding: .day, value: -2, to: date_0)!
        let date_1 = calendar.date(byAdding: .day, value: -1, to: date_0)!
        
        return [
            Transaction(id: 0, date: date_3, location: "Mensa Wundtstraße", kind: .cardCharge, amount: 10, positions: [
                Position(id: 0, name: "Aufwertung", price: 10)
            ]),
            Transaction(id: 1, date: date_2, location: "Mensa Wundtstraße", kind: .sale, amount: 6, positions: [
                Position(id: 0, name: "Surfing Paradise", price: 6)
            ]),
            Transaction(id: 2, date: date_1, location: "Alte Mensa", kind: .sale, amount: 3.7, positions: [
                Position(id: 0, name: "Sushi Menü", price: 3.7)
            ]),
            Transaction(id: 3, date: date_0, location: "Alte Mensa", kind: .sale, amount: 3.74, positions: [
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

