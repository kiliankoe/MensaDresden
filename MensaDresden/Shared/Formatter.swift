import Foundation

enum DateFormat: String {
    case yearMonthDay = "yyyy-MM-dd"
}

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

    // MARK: Date Formatter

    private static func dateFormatter(format: DateFormat? = nil,
                                      dateStyle: DateFormatter.Style? = nil,
                                      timeStyle: DateFormatter.Style? = nil,
                                      locale: Locale) -> DateFormatter {
        let formatter = DateFormatter()
        if let format = format {
            formatter.dateFormat = format.rawValue
        }
        if let dateStyle = dateStyle {
            formatter.dateStyle = dateStyle
        }
        if let timeStyle = timeStyle {
            formatter.timeStyle = timeStyle
        }
        formatter.locale = locale
        return formatter
    }

    static func string(for date: Date, format: DateFormat, locale: Locale = .current) -> String {
        let formatter = dateFormatter(format: format, locale: locale)
        return formatter.string(from: date)
    }

    static func string(for date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, locale: Locale = .current) -> String {
        let formatter = dateFormatter(dateStyle: dateStyle, timeStyle: timeStyle, locale: locale)
        return formatter.string(from: date)
    }
}
