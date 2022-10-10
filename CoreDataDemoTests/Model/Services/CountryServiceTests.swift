//
//  CountryServiceTests.swift
//  CoreDataDemoTests
//
//  Created by Holger Mayer on 10.10.22.
//

import XCTest
@testable import CoreDataDemo

final class CountryServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

 
    func testCreateValidCountry() throws {
        let context = PersistenceController.test.container.viewContext
        
        let result = CountryService.create(name: "Italy", context: context)
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(result!.id)
        XCTAssertEqual(result!.name!, "Italy")
    }

}
