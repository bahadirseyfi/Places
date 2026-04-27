import XCTest

final class PlacesUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLocationsListLoads() throws {
        let app = launch(with: ["-uiTestMode", "-uiTestLocationsSuccess"])

        let list = app.collectionViews["locations_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 3))
        XCTAssertTrue(list.cells.count > 0)
        XCTAssertTrue(app.staticTexts["Amsterdam"].exists)
    }

    @MainActor
    func testRetryButtonAppearsOnFailure() throws {
        let app = launch(with: ["-uiTestMode", "-uiTestLocationsFailure"])

        let retry = app.buttons["retry_button"]
        XCTAssertTrue(retry.waitForExistence(timeout: 3))
    }

    @MainActor
    func testCustomLocationValidation() throws {
        let app = launch(with: ["-uiTestMode", "-uiTestLocationsSuccess"])

        app.buttons["custom_location_button"].tap()

        let latField = app.textFields["latitude_text_field"]
        XCTAssertTrue(latField.waitForExistence(timeout: 2))
        latField.tap()
        latField.typeText("999")

        let openButton = app.buttons["open_in_wikipedia_button"]
        XCTAssertFalse(openButton.isEnabled)
    }

    @MainActor
    func testCustomLocationFormAcceptsValidCoordinate() throws {
        let app = launch(with: ["-uiTestMode", "-uiTestLocationsSuccess"])

        app.buttons["custom_location_button"].tap()

        let latField = app.textFields["latitude_text_field"]
        XCTAssertTrue(latField.waitForExistence(timeout: 2))
        latField.tap()
        latField.typeText("52.35")

        let lonField = app.textFields["longitude_text_field"]
        lonField.tap()
        lonField.typeText("4.83")

        let openButton = app.buttons["open_in_wikipedia_button"]
        XCTAssertTrue(openButton.isEnabled)
    }

    @MainActor
    func testDarkModeLaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestMode", "-uiTestLocationsSuccess"]
        app.launchEnvironment["UITestDarkMode"] = "1"
        app.launch()

        XCUIDevice.shared.appearance = .dark
        XCTAssertTrue(app.navigationBars["Places"].waitForExistence(timeout: 3))
    }

    private func launch(with arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        return app
    }
}
