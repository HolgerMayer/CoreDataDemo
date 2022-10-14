//
//  ModelData.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 14.10.22.
//

import Foundation
import CoreData
import CSV


struct ModelData {
    
    private var countryHash : [String: UUID] = [String: UUID]()
    
    mutating func  load( context : NSManagedObjectContext) {
        
        guard let url = Bundle.main.url(forResource: "CountryCityData", withExtension: "csv") else {
            print("Error : no bundle file CountryCityData.csv")
            return
        }
        
        guard let stream = InputStream(url: url) else {
            print("Error : can't create input stream for CountryCityData.csv")
            return
        }
        
        let csv = try! CSVReader(stream: stream,
                                 codecType: UTF8.self,
                                 hasHeaderRow: true
        )
        
        
        while csv.next() != nil {
            guard let name = csv["country"] else {
                print("Error - no Country")
                return
            }
            
            guard let city = csv["city"] else {
                print("Error - no City")
                return
            }
            guard let latitude = Double(csv["latitude"] ?? "0.0") else {
                print("Error - no latitude")
                return
            }
            guard let longitude = Double(csv["longitude"] ?? "0.0")  else {
                print("Error - no longitude")
                return
            }
            
            let countryID = getCountryID(name, context: context)
            
            createCity(city:city,latitude:latitude, longitude:longitude, countryID: countryID,context:context)
            print("\(csv["id"]!)")   // => "1"
            print("\(csv["city"]!)") // => "foo"
        }
    }
    
    private mutating func getCountryID(_ name:String, context:NSManagedObjectContext)-> UUID {
        
        var countryID = countryHash[name]
        if countryID == nil {
            
            guard let country = CountryService.create(name: name, context: context) else {
                return UUID()
            }
            
            countryHash[name] = country.id!
            
            countryID = country.id
        }
        
        return countryID!
    }
    
    
    private func createCity(city:String,latitude:Double, longitude:Double, countryID: UUID, context:NSManagedObjectContext){
        
        let _ = CityService.create(name:city,countryID: countryID,latitude: latitude,longitude: longitude,context: context)
    }
    
}
