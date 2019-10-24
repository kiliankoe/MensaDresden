import Foundation

enum Formatter {
    static private var relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .full
        return formatter
    }()

    static func stringForRelativeDate(offsetBy offset: Int, locale: Locale = .current) -> String {
        relativeDateFormatter
            .localizedString(from: DateComponents(day: offset))
            .capitalized(with: locale)
    }

    static func string(for date: Date, format: DateFormat, locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
}

extension Formatter {
    enum DateFormat: String {
        case yearMonthDay = "yyyy-MM-dd"
    }
}
