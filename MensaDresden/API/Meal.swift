import Foundation

struct Meal: Identifiable, Decodable {
    let id: Int
    let name: String
    let notes: [String]
    let prices: Prices
    let category: String
    let image: URL
    let url: URL

    struct Prices: Decodable {
        let students: Double
        let employees: Double

        private enum CodingKeys: String, CodingKey {
            case students = "Studierende"
            case employees = "Bedienstete"
        }
    }
}
