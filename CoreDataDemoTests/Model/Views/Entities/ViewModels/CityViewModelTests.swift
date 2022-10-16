//
//  CityViewModelTests.swift
//  CoreDataDemoTests
//
//  Created by Holger Mayer on 14.10.22.
//

import XCTest
import CoreData
@testable import CoreDataDemo

final class CityViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitWithCountry() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        
        let sut = CityViewModel(country: testCountry)
        
        XCTAssertEqual(sut.name,"")
        XCTAssertEqual(sut.population, 0)
        XCTAssertFalse(sut.isCapital)
        XCTAssertTrue(sut.isEditing)
        XCTAssertEqual(sut.countryID,testCountry.id!)
        XCTAssertNil(sut.dataItem)
    }
    
    func testInitWithCity() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        let testCity = CityService.create(name: "Berlin",countryID:testCountry.id!,capital:true,population:10,context: context)

        let sut = CityViewModel(city: testCity!)
        
        XCTAssertEqual(sut.name,"Berlin")
        XCTAssertEqual(sut.population, 10)
        XCTAssertTrue(sut.isCapital)
        XCTAssertFalse(sut.isEditing)
        XCTAssertEqual(sut.countryID,testCountry.id!)
        XCTAssertEqual(sut.dataItem,testCity)
        
    }

    func testIsValid_nameEmpty() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        
        let sut = CityViewModel(country: testCountry)
  
        XCTAssertFalse(sut.isValid)
    }

    func testIsValid_nameWhitespaces() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        
        let sut = CityViewModel(country: testCountry)
        sut.name = "        "
        XCTAssertFalse(sut.isValid)

    }
    
    func testIsValid_validName() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        
        let sut = CityViewModel(country: testCountry)
        sut.name = "Berlin"
        XCTAssertTrue(sut.isValid)
    }

    func testIsUpdating_newCityUnsaved() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        
        let sut = CityViewModel(country: testCountry)
        XCTAssertFalse(sut.isUpdating)
    }
    
    
    func testIsUpdating_savedCity() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        let testCity = CityService.create(name: "Berlin",countryID:testCountry.id!,capital:true,population:10,context: context)

        let sut = CityViewModel(city: testCity!)
        XCTAssertTrue(sut.isUpdating)
    }

    func testUpdate_newCity_InValid() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        let count = CityService.count(context: context)
  
        let sut = CityViewModel(country: testCountry)
        
        sut.update(context: context)
        
        XCTAssertEqual(count,CityService.count(context: context))

    }
    
    func testUpdate_newCity_Valid() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        let count = CityService.count(context: context)
  
        let sut = CityViewModel(country: testCountry)
        sut.name = "Berlin"
        
        sut.update(context: context)
        
        XCTAssertEqual(count+1,CityService.count(context: context))
    }
    
    func testUpdate_existingCity_Invalid() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        let testCity = CityService.create(name: "Berlin",countryID:testCountry.id!,capital:true,population:10,context: context)
        let count = CityService.count(context: context)
        
        let sut = CityViewModel(city: testCity!)
        sut.name = "  "
        sut.update(context: context)
        XCTAssertEqual(count,CityService.count(context: context))
        
        let result = CityService.queryByID(testCity!.id!, context: context)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.name!, "Berlin")
    }
    
  
    func testUpdate_existingCity_Valid() throws {
        let context = PersistenceController.test.container.viewContext
        let testCountry = createCountry(context: context)
        let testCity = CityService.create(name: "Berlin",countryID:testCountry.id!,capital:true,population:10,context: context)
        let count = CityService.count(context: context)
        
        let sut = CityViewModel(city: testCity!)
        sut.name = "Hamburg"
        sut.population = 200
        sut.isCapital = false
        
        sut.update(context: context)
        XCTAssertEqual(count,CityService.count(context: context))
        
        let result = CityService.queryByID(testCity!.id!, context: context)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.name!, "Hamburg")
        XCTAssertEqual(result!.population,200)
        XCTAssertEqual(result!.capital, false)
  }

    
    
    func createCountry(context: NSManagedObjectContext) -> Country {
        let testName = "Germany"
        let testFlag = "🇩🇪"
        
        return CountryService.create(name: testName,flag: testFlag, context:context)!
    }
}


