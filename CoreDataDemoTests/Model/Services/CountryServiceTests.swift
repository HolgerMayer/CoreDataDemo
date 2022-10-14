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

    
    func testDeleteAll_NothingToDelete() throws {
        
        let context = PersistenceController.test.container.viewContext
        XCTAssertEqual(CountryService.count(context:context),0)
        
        try CountryService.deleteAll(context)
        
        XCTAssertEqual(CountryService.count(context:context),0)
    }
    
    func testDeleteAll_ModelData() throws {
        
        let context = PersistenceController.test.container.viewContext
        var modelData = ModelData()
        
        modelData.load(context: context)
        XCTAssertTrue(CountryService.count(context:context) > 0)
        XCTAssertEqual(CountryService.count(context:context),119) // 119 Countries in 1000 lines of data

        try CountryService.deleteAll(context)
        
        XCTAssertEqual(CountryService.count(context:context),0)
        XCTAssertEqual(CityService.count(context: context),1000)
    }
    
    func testDeleteObject_recusiveRemoveCity() throws {
        let context = PersistenceController.test.container.viewContext
        let country = CountryService.create(name: "Italy", context: context)
        let _ = CityService.create(name: "Rome", countryID: country!.id!, context: context)
        XCTAssertEqual(CountryService.count(context:context),1)
        XCTAssertEqual(CityService.count(context: context),1)

        CountryService.delete(country!, context: context)
        
        
        XCTAssertEqual(CountryService.count(context:context),0)
        XCTAssertEqual(CityService.count(context: context),0)

        
    }
    
}
