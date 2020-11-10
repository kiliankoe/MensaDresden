import Foundation

enum DateFormat: String {
    case yearMonthDay = "yyyy-MM-dd"
}

enum Formatter {
    // MARK: Relative Date Formatter

    static private func relativeDateTimeFormatter(dateTimeStyle: RelativeDateTimeFormatter.DateTimeStyle? = nil,
                                                  unitsStyle: RelativeDateTimeFormatter.UnitsStyle? = nil,
                                                  formattingContext: RelativeDateTimeFormatter.Context?,
                                                  locale: Locale) -> RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        if let dateTimeStyle = dateTimeStyle {
            formatter.dateTimeStyle = dateTimeStyle
        }
        if let unitsStyle = unitsStyle {
            formatter.unitsStyle = unitsStyle
        }
        if let formattingContext = formattingContext {
            formatter.formattingContext = formattingContext
        }
        formatter.locale = locale
        return formatter
    }

    static func stringForRelativeDate(offsetFromTodayBy offset: Int, context: RelativeDateTimeFormatter.Context? = nil, locale: Locale = .current) -> String {
        relativeDateTimeFormatter(dateTimeStyle: .named, unitsStyle: .full, formattingContext: context, locale: locale)
            .localizedString(from: DateComponents(day: offset))
    }

    static func string(forRelativeDate relativeDate: Date, to otherDate: Date, context: RelativeDateTimeFormatter.Context? = nil, locale: Locale = .current) -> String {
        relativeDateTimeFormatter(dateTimeStyle: .named, unitsStyle: .full, formattingContext: context, locale: locale)
            .localizedString(for: relativeDate, relativeTo: otherDate)
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

    // MARK: Number Formatter

    private static func numberFormatter(style: NumberFormatter.Style, currencyCode: String? = nil, locale: Locale) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        if let currencyCode = currencyCode {
            formatter.currencyCode = currencyCode
        }
        formatter.locale = locale
        return formatter
    }

    static func priceString(for value: Double, locale: Locale = .current) -> String? {
        let formatter = numberFormatter(style: .currency, currencyCode: "EUR", locale: locale)
        return formatter.string(from: value as NSNumber)
    }

    // MARK: Measurement Formatter

    private static func distanceFormatter(locale: Locale) -> MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.usesSignificantDigits = true
        formatter.numberFormatter.maximumSignificantDigits = 2
        formatter.unitStyle = .short
        formatter.unitOptions = .naturalScale
        formatter.locale = locale
        return formatter
    }

    static func distanceString<Unit>(for value: Measurement<Unit>, locale: Locale = .current) -> String {
        let formatter = distanceFormatter(locale: locale)
        return formatter.string(from: value)
    }
}
