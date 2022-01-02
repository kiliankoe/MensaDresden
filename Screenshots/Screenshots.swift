import XCTest

class Screenshots: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launchEnvironment = [
            "favoriteCanteens": "Alte Mensa,MiO - Mensa im Osten",
            "autoloadUsername": "appledemo",
            "autoloadPassword": "appledemo",
            "emeal.currentbalance": "13.37",
            "emeal.lasttransaction": "6.0",
            "emeal.lastscan": "1641205800", // Jan 03 2022 11:30:00 (CET)
        ]
    }

    func testTakeScreenshots() throws {
        setupSnapshot(app)
        app.launch()

        app.staticTexts["Alte Mensa"].tap()
        Thread.sleep(forTimeInterval: 1) // Make sure meals are loaded
        snapshot("01_Menu")

        app.navigate(to: .emeal)
        snapshot("02_Emeal")

        app.navigate(to: .menu)
        app.goBack()
        app.staticTexts["MiO - Mensa im Osten"].tap()
        app.selectMeal(0)
        snapshot("03_Meal")

        app.goBack()
        app.goBack()
        app.scrollToTop()
        Thread.sleep(forTimeInterval: 1) // Let scrolling indicator disappear
        snapshot("04_Canteens")
    }
}
