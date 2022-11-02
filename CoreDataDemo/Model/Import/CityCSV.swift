//
//  CityCSV.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 28.10.22.
//


import Foundation
import CoreData
import CSV


struct CityCSV  {
    
    private var countryHash : [String: UUID] = [String: UUID]()

    
    var cityPropertiesList = [CityCSVProperties]()
    
    init(noOfCities: Int, from url:URL, countryHash : [String: UUID] , context : NSManagedObjectContext) throws {
        
        self.countryHash = countryHash
        
        guard let url = Bundle.main.url(forResource: "CountryCityDataLarge", withExtension: "csv") else {
            print("Error : no bundle file CountryCityDataLarge.csv")
            return
        }
        
        guard let stream = InputStream(url: url) else {
            print("Error : can't create input stream for CountryCityDataLarge.csv")
            return
        }
        
        let csv = try! CSVReader(stream: stream,
                                 codecType: UTF8.self,
                                 hasHeaderRow: true,
                                 delimiter:";"
        )
 
        var count = 0
        while csv.next() != nil {
            
            guard let countryCode = csv["CountryCode"] else {
                print("Error - no Country")
                return
            }
            let countryID = getCountryID(countryCode, context: context)
            
            guard let city = csv["Name"] else {
                print("Error - no City")
                return
            }
            
            guard let population = csv["Population"] else {
                print("Error - no Population")
                return
            }
            
            
            guard let coordinate = csv["Coordinates"]  else {
                
                
                print("Error - no coordinates")
                return
            }
            
            
            let cityProperties = CityCSVProperties(countryID: countryID, name: city, population: population, coordinate: coordinate)
            cityPropertiesList.append(cityProperties)
            
            count = count + 1
            
            if noOfCities > 0 && count > noOfCities {
                return
            }
        }
    }
    
    private mutating func getCountryID(_ countryCode:String, context:NSManagedObjectContext)-> UUID {
        
        var countryID = countryHash[countryCode]
        if countryID == nil {
            let flag = "?"
            guard let country = CountryService.create(name: countryCode, flag:flag,context: context) else {
                return UUID()
            }
            
            countryHash[countryCode] = country.id!
            
            countryID = country.id
        }
        
        return countryID!
    }
    
    
}

