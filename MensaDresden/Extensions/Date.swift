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
        Calendar(identifier: .gregorian).startOfDay(for: Date().addingTimeInterval(24 * 3600))
    }

    var isToday: Bool {
        Calendar(identifier: .gregorian).isDateInToday(self)
    }

    var isWeekend: Bool {
        Calendar(identifier: .gregorian).isDateInWeekend(self)
    }
}
