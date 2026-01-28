import Foundation
import EmealKit

extension Transaction {
    init(id: Int, date: Date, location: String, kind: Transaction.Kind, amount: Double, positions: [Position]) {
        self.init(clientID: 0, id: id, transactionID: "0", date: date, location: location, register: "", kind: kind, amount: amount, positions: positions)
    }
    
    init(id: Int, date: Date, location: String, register: String, kind: Transaction.Kind, amount: Double, positions: [Position]) {
        self.init(clientID: 0, id: id, transactionID: "0", date: date, location: location, register: register, kind: kind, amount: amount, positions: positions)
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
    
    static var extensiveExampleValues: [Transaction] {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        var transactions: [Transaction] = []
        var id = 0
        
        let locations = [
            ("Mensa Reichenbachstraße", ["Kasse 1", "Kasse 2"]),
            ("Alte Mensa", ["Westsaal Nord", "Westsaal Süd", "Ostsaal Nord", "Ostsaal Süd", "Cafeteria Zebradiele"]),
            ("Mensa Siedepunkt", ["Kasse A", "Kasse B"]),
            ("Mensa Zeltschlösschen", ["Kasse 1"]),
            ("Mensologie", ["Kasse"]),
            ("Mensa U-Boot", ["Kasse 1", "Kasse 2"])
        ]
        
        let meals = [
            ("Pasta mit Tomatensauce", 2.50, 0.90),
            ("Schnitzel mit Pommes", 3.80, 1.20),
            ("Vegetarisches Curry", 3.90, 1.00),
            ("Fischstäbchen", 3.20, 0.80),
            ("Pizza Margherita", 3.20, 1.10),
            ("Salat Bowl", 5.50, 1.40),
            ("Burger", 4.90, 1.20),
            ("Suppe des Tages", 2.10, 0.50),
            ("Lasagne", 4.40, 1.10),
            ("Wrap", 2.35, 0.95)
        ]
        
        // Generate transactions over last 180 days
        for dayOffset in 0...180 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
            
            // Skip weekends
            let weekday = calendar.component(.weekday, from: date)
            if weekday == 1 || weekday == 7 { continue }
            
            // Random number of transactions per day (0-3)
            let transactionsPerDay = Int.random(in: 0...2)
            
            for _ in 0..<transactionsPerDay {
                let (location, registers) = locations.randomElement()!
                let register = registers.randomElement()!
                
                // Random number of positions (1-3)
                let positionCount = Int.random(in: 1...2)
                var positions: [Position] = []
                var totalAmount = 0.0
                
                for posId in 0..<positionCount {
                    let (mealName, guestPrice, discount) = meals.randomElement()!
                    let studentPrice = guestPrice - discount
                    positions.append(Position(id: posId, name: mealName, price: studentPrice, discount: discount))
                    totalAmount += studentPrice
                }
                
                transactions.append(Transaction(
                    id: id,
                    date: date,
                    location: location,
                    register: register,
                    kind: .sale,
                    amount: -totalAmount,
                    positions: positions
                ))
                id += 1
            }
        }
        
        // Add some card charges
        for monthOffset in 0...2 {
            guard let chargeDate = calendar.date(byAdding: .month, value: -monthOffset, to: now) else { continue }
            transactions.append(Transaction(
                id: id,
                date: chargeDate,
                location: "Mensa Reichenbachstraße",
                register: "Aufwerter",
                kind: .cardCharge,
                amount: 50.0,
                positions: [Position(id: 0, name: "Aufwertung", price: 50.0)]
            ))
            id += 1
        }
        
        return transactions.sorted { $0.date > $1.date }
    }
}

extension Transaction.Position {
    init(id: Int, name: String, price: Double) {
        self.init(clientID: 0, id: id, transactionID: "0", positionID: 1, name: name, amount: 1, price: price, totalPrice: price, discount: 0, rating: 0)
    }
    
    init(id: Int, name: String, price: Double, discount: Double) {
        self.init(clientID: 0, id: id, transactionID: "0", positionID: 1, name: name, amount: 1, price: price, totalPrice: price, discount: discount, rating: 0)
    }
}

