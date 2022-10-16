//
//  CountryViewModelTests.swift
//  CoreDataDemoTests
//
//  Created by Holger Mayer on 14.10.22.
//

import XCTest
@testable import CoreDataDemo

final class CountryViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        
        let sut = CountryViewModel()
        
        XCTAssertNil( sut.dataItem)
        XCTAssertEqual(sut.name,"")
        XCTAssertEqual(sut.flag,"")

    }
    
    func testInitWithCountry() throws {
        let testName = "Germany"
        let testFlag = "🇩🇪"
        
        let country = CountryService.create(name: testName,flag: testFlag, context: PersistenceController.test.container.viewContext)
        

        let sut = CountryViewModel(country: country!)
        
        XCTAssertEqual( sut.dataItem, country)
        XCTAssertEqual(sut.name,testName)
        XCTAssertEqual(sut.flag,testFlag)

    }
    

    func testIsValid_nameEmpty() throws {
        let sut = CountryViewModel()
        
        XCTAssertFalse(sut.isValid)

    }

    func testIsValid_nameWhitespaces() throws {
        let sut = CountryViewModel()
        
        sut.name = "            "
        
        XCTAssertFalse(sut.isValid)

    }
    
    func testIsValid_validName() throws {
        let sut = CountryViewModel()
        
        sut.name = "Germany"
        
        XCTAssertTrue(sut.isValid)

    }

    func testIsUpdating_newCountryUnsaved() throws {
        let sut = CountryViewModel()
        
        XCTAssertFalse(sut.isUpdating)

    }
    
    
    func testIsUpdating_savedCountry() throws {
        let testName = "Germany"
        let testFlag = "🇩🇪"
        
        let country = CountryService.create(name: testName,flag: testFlag, context: PersistenceController.test.container.viewContext)
        

        let sut = CountryViewModel(country: country!)
        
        XCTAssertTrue(sut.isUpdating)

    }
    
    func testUpdate_newCountry_NotValid() throws {
        let context = PersistenceController.test.container.viewContext
        let count = CountryService.count(context: context)
        
        let sut = CountryViewModel()
        
        sut.update(context: context)
        
        XCTAssertEqual(count,CountryService.count(context: context))
    }
   
    func testUpdate_newCountry_Valid() throws {
        let context = PersistenceController.test.container.viewContext
        let count = CountryService.count(context: context)
        
        let sut = CountryViewModel()
        sut.name = "Germany"
        sut.flag = "🇩🇪"
        
        sut.update(context: context)
        
        XCTAssertEqual(count+1,CountryService.count(context: context))

    }

    
    func testUpdate_existingCountry_NotValid() throws {
        let testName = "Germany"
        let testFlag = "🇩🇪"
        let context = PersistenceController.test.container.viewContext
        let country = CountryService.create(name: testName,flag: testFlag, context:context)
        let count = CountryService.count(context: context)
 
        let sut = CountryViewModel(country: country!)
        
        sut.name = ""
        sut.flag = "🇧🇪"
        
        sut.update(context: context)
        
        XCTAssertEqual(count,CountryService.count(context: context))
        
        let result = CountryService.queryByID(country!.id!, context: context)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.name!, "Germany")
        XCTAssertEqual(result!.flag!, "🇩🇪")
    }
    
    
    func testUpdate_existingCountry_Valid() throws {
        let testName = "Germany"
        let testFlag = "🇩🇪"
        let context = PersistenceController.test.container.viewContext
        let country = CountryService.create(name: testName,flag: testFlag, context:context)
        let count = CountryService.count(context: context)
 
        let sut = CountryViewModel(country: country!)
        
        sut.name = "Belgium"
        sut.flag = "🇧🇪"
        
        sut.update(context: context)
        
        XCTAssertEqual(count,CountryService.count(context: context))
        
        let result = CountryService.queryByID(country!.id!, context: context)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.name!, "Belgium")
        XCTAssertEqual(result!.flag!, "🇧🇪")
   }
    
  

}
