import Foundation
import XCTest

extension XCUIApplication {
    enum Tab: Int {
        case menu = 0
        case emeal = 1
        case news = 2
        case settings = 3
    }

    func navigate(to tab: Tab) {
        self.tabBars.buttons.element(boundBy: tab.rawValue).tap()
    }

    func goBack() {
        self.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func scrollToTop() {
        XCUIApplication().coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.02)).tap()
    }

    func selectCanteen(_ idx: Int) {
        self.tables.children(matching: .cell).element(boundBy: idx).tap()
    }

    enum DateControl: Int {
        case today = 0
        case tomorrow = 1
    }

    func selectDate(_ date: DateControl) {
        self.segmentedControls.buttons.element(boundBy: date.rawValue).tap()
    }

    func selectMeal(_ idx: Int) {
        self.tables.children(matching: .cell).element(boundBy: idx).tap()
    }

    func favoriteCanteen() {
        self.navigationBars.buttons.element(boundBy: 2).tap()
    }

    func typeCardnumber(_ cardnumber: String) {
        let cardnumberField = self.textFields["Cardnumber"]
        cardnumberField.tap()
        cardnumberField.typeText("appledemo")
        cardnumberField.typeText("\n")
    }

    func typePassword(_ password: String) {
        let passwordField = self.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText("appledemo")
        passwordField.typeText("\n")
    }
}
