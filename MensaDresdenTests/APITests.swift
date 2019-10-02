import XCTest

class APITests: XCTestCase {
    func testMealAllergenDecoding() {
        let rawAllergens = [
            "Glutenhaltiges Getreide (A)",
            "Weizen (A1)",
            "Milch/Milchzucker (Laktose) (G)",
        ]

        let allergens = rawAllergens.compactMap { Allergen(note: $0) }
        XCTAssertEqual(allergens, [
            .gluten,
            .gluten,
            .lactose
        ])
    }
}
