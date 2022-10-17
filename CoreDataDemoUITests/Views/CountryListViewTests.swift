//
//  CountryListViewTests.swift
//  CoreDataDemoUITests
//
//  Created by Holger Mayer on 17.10.22.
//

import XCTest

final class CountryListViewTests: XCTestCase {
    var app : XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddCountryContent() throws {
        readyDatabaseAndApp()
        
        app.navigationBars["Countries"]/*@START_MENU_TOKEN@*/.buttons["AddCountryButton"]/*[[".otherElements[\"Add country\"]",".buttons[\"Add country\"]",".buttons[\"AddCountryButton\"]",".otherElements[\"AddCountryButton\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let addCountryBarTitle = app.staticTexts["Add country"]
        XCTAssert(addCountryBarTitle.waitForExistence(timeout: 0.5))
        
        let countryName = app.textFields["CountryNameTextField"]
            XCTAssert(countryName.exists)
        
        let flag = app.textFields["FlagTextField"]
        XCTAssert(flag.exists)
        
    }
    
    
    func testCreateCountry() throws {
        // UI tests must launch the application that they test.
        readyDatabaseAndApp()
        
        
        app.navigationBars["Countries"]/*@START_MENU_TOKEN@*/.buttons["AddCountryButton"]/*[[".otherElements[\"Add country\"]",".buttons[\"Add country\"]",".buttons[\"AddCountryButton\"]",".otherElements[\"AddCountryButton\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let addCountryBarTitle = app.staticTexts["Add country"]
        XCTAssert(addCountryBarTitle.waitForExistence(timeout: 0.5))
        
        let collectionViewsQuery = app.collectionViews
        let countryNameTextField = collectionViewsQuery.textFields["CountryNameTextField"]
        countryNameTextField.tap()
        countryNameTextField.typeText("Germany")
        
        let flagTextField = collectionViewsQuery.textFields["FlagTextField"]
        flagTextField.tap()
        flagTextField.typeText("🇩🇪")
    
        app.navigationBars["Add country"].buttons["SaveButton"].tap()

        let countryListTitle = app.staticTexts["Countries"]
        XCTAssert(countryListTitle.waitForExistence(timeout: 0.5))

        
    }

    
    func readyDatabaseAndApp() {
        app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        app/*@START_MENU_TOKEN@*/.buttons["ToggleSidebar"]/*[[".buttons[\"Hide Sidebar\"]",".buttons[\"ToggleSidebar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars.matching(identifier: "_TtGC7SwiftUI32NavigationStackHosting")/*@START_MENU_TOKEN@*/.buttons["ToggleSidebar"]/*[[".buttons[\"Show Sidebar\"]",".buttons[\"ToggleSidebar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.toolbars["Toolbar"]/*@START_MENU_TOKEN@*/.buttons["ClearDataButton"]/*[[".otherElements[\"clear\"]",".buttons[\"clear\"]",".buttons[\"ClearDataButton\"]",".otherElements[\"ClearDataButton\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
   
}
