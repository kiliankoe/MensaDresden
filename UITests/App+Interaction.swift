import Foundation
import XCTest

extension XCUIApplication {
    enum Tab: Int {
        case menu = 0
        case emeal = 1
        case news = 2
        case settings = 3

        var identifier: String {
            switch self {
            case .menu:
                return "tab.menu"
            case .emeal:
                return "tab.emeal"
            case .news:
                return "tab.newsfeed"
            case .settings:
                return "tab.settings"
            }
        }

        var title: String {
            switch self {
            case .menu:
                return "Menu"
            case .emeal:
                return "Emeal"
            case .news:
                return "News"
            case .settings:
                return "Settings"
            }
        }

    }

    func navigate(to tab: Tab) {
        let tabBarButtonByIdentifier = self.tabBars.buttons[tab.identifier]
        if tabBarButtonByIdentifier.waitForExistence(timeout: 2) {
            tabBarButtonByIdentifier.tap()
            return
        }

        let tabBarButton = self.tabBars.buttons.element(boundBy: tab.rawValue)
        if tabBarButton.waitForExistence(timeout: 2) {
            tabBarButton.tap()
            return
        }

        let titleButtons = self.descendants(matching: .button)
            .matching(NSPredicate(format: "label == %@", tab.title))
        if let hittableTitleButton = titleButtons.allElementsBoundByIndex.first(where: { $0.isHittable }) {
            hittableTitleButton.tap()
            return
        }
        let firstTitleButton = titleButtons.firstMatch
        if firstTitleButton.waitForExistence(timeout: 2) {
            firstTitleButton.tap()
            return
        }

        let titleTexts = self.descendants(matching: .staticText)
            .matching(NSPredicate(format: "label == %@", tab.title))
        if let hittableTitleText = titleTexts.allElementsBoundByIndex.first(where: { $0.isHittable }) {
            hittableTitleText.tap()
            return
        }
        let firstTitleText = titleTexts.firstMatch
        if firstTitleText.waitForExistence(timeout: 2) {
            firstTitleText.tap()
            return
        }

        XCTFail("Could not navigate to tab '\(tab.title)'")
    }

    func goBack() {
        self.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func scrollToTop() {
        XCUIApplication().coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.02)).tap()
    }

    func selectCanteen(_ idx: Int) {
        let tableCell = self.tables.children(matching: .cell).element(boundBy: idx)
        if tableCell.waitForExistence(timeout: 10) {
            tableCell.tap()
            return
        }

        let collectionCell = self.collectionViews.children(matching: .cell).element(boundBy: idx)
        if collectionCell.waitForExistence(timeout: 5) {
            collectionCell.tap()
            return
        }

        XCTFail("Could not find canteen cell at index \(idx)")
    }

    enum DateControl: Int {
        case today = 0
        case tomorrow = 1
    }

    func selectDate(_ date: DateControl) {
        self.segmentedControls.buttons.element(boundBy: date.rawValue).tap()
    }

    func selectMeal(_ idx: Int) {
        let tableCell = self.tables.children(matching: .cell).element(boundBy: idx)
        if tableCell.waitForExistence(timeout: 10) {
            tableCell.tap()
            return
        }

        let collectionCell = self.collectionViews.children(matching: .cell).element(boundBy: idx)
        if collectionCell.waitForExistence(timeout: 5) {
            collectionCell.tap()
            return
        }

        XCTFail("Could not find meal cell at index \(idx)")
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
