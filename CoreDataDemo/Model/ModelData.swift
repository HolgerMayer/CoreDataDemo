//
//  ModelData.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 14.10.22.
//
// Country-City-CSV : https://www.mockaroo.com
// Emoji-JSON : https://github.com/risan/country-flag-emoji-json


import Foundation
import CoreData
import CSV



struct ModelData {
    
    struct CountryEmoji : Codable {
        var name : String
        var code : String
        var emoji : String
        var unicode : String
        var image : String
    }
    
    private var countryHash : [String: UUID] = [String: UUID]()
    
    mutating func  load(_ noOfCities : Int = -1,  context : NSManagedObjectContext) {
        
        
        loadCountryHash(context:context)
        
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
        
        var counter = 0
        while csv.next() != nil {
            guard let country = csv["CountryCode"] else {
                print("Error - no Country")
                return
            }
            let countryID = getCountryID(country, context: context)

            guard let city = csv["Name"] else {
                print("Error - no City")
                return
            }
            
            guard let population = Int(csv["Population"] ?? "-1") else {
                print("Error - no Population")
                return
            }
            /*
            guard let latitude = Double(csv["latitude"] ?? "0.0") else {
                print("Error - no latitude")
                return
            }
            guard let longitude = Double(csv["longitude"] ?? "0.0")  else {
                print("Error - no longitude")
                return
            }
            */
            
            
            guard let coordinate = csv["Coordinates"]  else {
                

                print("Error - no coordinates")
                return
            }
            
            let coordinateElements = coordinate.components(separatedBy:",")

            var latitude = 0.0
            var longitude = 0.0
            if coordinateElements.count == 2 {
                latitude = Double(coordinateElements[0]) ?? 0.0
                longitude = Double(coordinateElements[1]) ?? 0.0
            }
            
            createCity(city:city,population:population,latitude:latitude, longitude:longitude, countryID: countryID,context:context)
            print("\(csv["ID"] ?? "Unkown")")   // => "1"
            print("\(csv["Name"] ?? "Unkown")") // => "foo"
            
            if noOfCities >= 0 {
                counter = counter + 1
                
                if counter >= noOfCities {
                    return
                }
            }
        }
    }
    
    
    private mutating func loadCountryHash(context:NSManagedObjectContext){
        guard let url = Bundle.main.url(forResource: "CountryEmoji", withExtension: "json") else {
            print("Error : no bundle file CountryEmoji.json")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Error : can't convert to dataCountryEmoji.json ")
            return
        }
        
        let decoder = JSONDecoder()

        guard let jsonCountryEmojis = try? decoder.decode([CountryEmoji].self, from: data) else {
            print("Error : can't parse to dataCountryEmoji.json ")
            return
        }
        
        for countryEmoji in jsonCountryEmojis {
            guard let country = CountryService.create(name: countryEmoji.name, flag:countryEmoji.emoji,context: context) else {
                print("Error : Unable to save \(countryEmoji.name)")
                return
            }
            
            countryHash[countryEmoji.code] = country.id!
        }

    }

    
    private mutating func getCountryID(_ name:String, context:NSManagedObjectContext)-> UUID {
        
        var countryID = countryHash[name]
        if countryID == nil {
            let flag = flagForName(name)
            guard let country = CountryService.create(name: name, flag:flag,context: context) else {
                return UUID()
            }
            
            countryHash[name] = country.id!
            
            countryID = country.id
        }
        
        return countryID!
    }
    
    
    private func createCity(city:String,population:Int=0, latitude:Double, longitude:Double, countryID: UUID, context:NSManagedObjectContext){
        
        let _ = CityService.create(name:city,countryID: countryID,population: population,latitude: latitude,longitude: longitude,context: context)
    }
    
    private func flagForName(_ name: String) -> String {
        
        switch name {
        case "China" :
            return "🇨🇳"
        case "United States" :
            return "🇺🇸"
        case "Canada" :
            return "🇨🇦"
        default :
            return "?"
        }
        
    }
}
