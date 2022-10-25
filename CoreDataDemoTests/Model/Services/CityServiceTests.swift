//
//  CityServiceTests.swift
//  CoreDataDemoTests
//
//  Created by Holger Mayer on 10.10.22.
//

import XCTest
@testable import CoreDataDemo
final class CityServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testCreateValidCity() throws {
        let context = PersistenceController.test.container.viewContext
        let country = CountryService.create(name: "Italy", context: context)
        
        let result = CityService.create(name: "Rome", countryID: country!.id!,capital: true, population: 10, context: context)
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(result!.id)
        XCTAssertEqual(result!.name!, "Rome")
        XCTAssertTrue(result!.capital)
        XCTAssertEqual(result!.population, 10)
    }
    
    func testDeleteAll_NothingToDelete() throws {
        
        let context = PersistenceController.test.container.viewContext
        XCTAssertEqual(CityService.count(context:context),0)
        
        try CityService.deleteAll(context)
        
        XCTAssertEqual(CityService.count(context:context),0)
    }
    
    func testDeleteAll_ModelData() throws {
        
        let context = PersistenceController.test.container.viewContext
        var modelData = ModelData()
        
        modelData.load(context: context)
        
        XCTAssertEqual(CountryService.count(context:context), 119)// 119 Countries in 1000 lines of data
        XCTAssertEqual(CityService.count(context:context),1000)

        try CityService.deleteAll(context)
        
        XCTAssertEqual(CountryService.count(context:context),119)
        XCTAssertEqual(CityService.count(context: context),0)
    }
    
    func testDeleteWhereCountryIDis() throws {
        let context = PersistenceController.test.container.viewContext
        let country1 = CountryService.create(name: "Italy", context: context)
        let _ = CityService.create(name: "Rome", countryID: country1!.id!,capital: true, population: 10, context: context)
        let country2 = CountryService.create(name: "United States", context: context)
        let _ = CityService.create(name: "New York", countryID: country2!.id!,capital: true, population: 10, context: context)

        try CityService.deleteWhereCountryIDis(country1!.id!, context: context)
        
        XCTAssertEqual(CountryService.count(context:context),2)
        XCTAssertEqual(CityService.count(context: context),1)
    }
    
    func testPerformanceExample() throws {
        
        
        let context = PersistenceController.test.container.viewContext
        var modelData = ModelData()
        modelData.load(10000, context:context)
        self.measure {
            try! CityService.deleteAll(context)
        }
    }
}
