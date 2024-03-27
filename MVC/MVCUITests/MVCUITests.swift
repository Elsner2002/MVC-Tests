//
//  MVCUITests.swift
//  MVCUITests
//
//  Created by Felipe  Elsner Silva on 26/03/24.
//

import XCTest

final class MVCUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCellTitle() throws {
        app.launch()
        let app = XCUIApplication()
        app.launch()
        
        let titleLabel = app.staticTexts["titleLabel"]
        XCTAssertTrue(titleLabel.exists)
    }
    
    func testCellExist() throws {
        app.launch()
        let cellExists = app.tables.cells["MovieCell"].firstMatch.exists
        XCTAssertTrue(cellExists, "A célula não existe")
        
    }
   
    func testNavigation() throws {
        app.launch()
        let cell = app.tables.cells["MovieCell"].firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5), "A célula não foi encontrada")
        
        let movieTitle = cell.staticTexts.firstMatch.label
        
        cell.tap()
        
        let movieDetailsNavigationBar = app.navigationBars["movieDetailsNavigationBar"]
        XCTAssertTrue(movieDetailsNavigationBar.waitForExistence(timeout: 5), "A view de detalhes não foi apresentada")
    }


    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
