import XCTest

class GenerateScreenshots: XCTestCase {

    var app: XCUIApplication!

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

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
        app.launch()
        takeScreenshot("Menu", app)

        app.navigate(to: .emeal)
        takeScreenshot("Emeal", app)
    }

    private func takeScreenshot(_ name: String, _ app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        self.add(attachment)
    }
}
