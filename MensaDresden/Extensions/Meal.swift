import Foundation
import EmealKit
import Regex

extension Meal {
    private static var allergenRegex: Regex {
        Regex(#" \([A-N]\d?(?:, )?\)"#)
    }

    var allergenStrippedTitle: String {
        self.name.replacingOccurrences(of: #" (\((?:[A-N]\d?(?:, )?)+\))"#, with: "", options: .regularExpression)
    }
}
