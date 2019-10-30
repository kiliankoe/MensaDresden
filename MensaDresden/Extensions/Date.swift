import Foundation

extension Date: Identifiable {
    public var id: TimeInterval {
        timeIntervalSince1970
    }
}

extension Date {
    static var today: Date {
        Calendar(identifier: .gregorian).startOfDay(for: Date())
    }

    static var tomorrow: Date {
        let calendar = Calendar(identifier: .gregorian)
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else {
            // I don't believe this can fail, but I still don't want to crash in that case.
            // Let's go for super weird behavior instead \o/
            return today
        }
        return Calendar(identifier: .gregorian).startOfDay(for: tomorrow)
    }

    var isToday: Bool {
        Calendar(identifier: .gregorian).isDateInToday(self)
    }

    var isWeekend: Bool {
        Calendar(identifier: .gregorian).isDateInWeekend(self)
    }
}
