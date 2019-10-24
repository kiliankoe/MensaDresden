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
}
