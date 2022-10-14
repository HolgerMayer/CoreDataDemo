//
//  ModelDataTests.swift
//  CoreDataDemoTests
//
//  Created by Holger Mayer on 14.10.22.
//

import XCTest
@testable import CoreDataDemo

final class ModelDataTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadTest() throws {
        let context = PersistenceController.test.container.viewContext
        
        try CountryService.deleteAll(context)
        try CityService.deleteAll(context)

        var modelData = ModelData()
        
        modelData.load(context: context)
        
        XCTAssertEqual(CountryService.count(context:context),119)// 119 Countries in 1000 lines of data
        XCTAssertEqual(CityService.count(context:context),1000)

    }

    func testLoadPerformanceTest() throws {
        let context = PersistenceController.test.container.viewContext
        var modelData = ModelData()
        // This is an example of a performance test case.
        self.measure {
            modelData.load(context: context)
        }
    }

}
