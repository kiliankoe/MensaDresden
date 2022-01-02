import XCTest

class UITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }

    func testFavoriteCanteen() throws {
        app.launch()

        app.navigate(to: .settings)
        let favoriteCanteens = app.staticTexts["Favorite Canteens"]
        XCTAssertFalse(favoriteCanteens.exists)

        app.navigate(to: .menu)
        let alteMensa = app.staticTexts["Alte Mensa"]
        alteMensa.tap()
        app.favoriteCanteen()

        app.navigate(to: .settings)
        XCTAssertTrue(favoriteCanteens.exists)
    }

    func testShowAutoloadTransactions() {
        app.launch()

        app.navigate(to: .emeal)
        let autoloadHint = app.buttons["Autoload Information"]
        XCTAssertTrue(autoloadHint.exists)

        app.navigate(to: .settings)
        app.typeCardnumber("appledemo")
        app.typePassword("appledemo")

        app.navigate(to: .emeal)
        XCTAssertFalse(autoloadHint.exists)
        XCTAssertTrue(app.staticTexts["Surfing Paradise"].exists)
    }
}
