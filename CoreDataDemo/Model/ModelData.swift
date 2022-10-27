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
    
    
    /// A persistent container to set up the Core Data stack.
    var container: NSPersistentContainer {
        PersistenceController.shared.container
    }


    var taskContext: NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.name = "importContext"
        context.transactionAuthor = "importCSV"
        return context

    }
    
    mutating func  load(_ noOfCities : Int = -1,  container : NSPersistentContainer) async {
        
   
        
        guard let url = Bundle.main.url(forResource: "CountryCityDataLarge", withExtension: "csv") else {
            print("Error : no bundle file CountryCityDataLarge.csv")
            return
        }
       

        do {
            let context = container.viewContext
            try await loadCountryHash(context:context)

            let cityList = try CityCSV(from: url, countryHash:countryHash, context: context)
            
            // Add name and author to identify source of persistent history changes.
            
            await syncCities(with: cityList.cityPropertiesList)
            
        } catch {
            print("Error : CityCSV")
        }
    }
    
    
    private mutating func syncCities(with cityPropertiesList: [CityProperties]) async {
        
        let bgContext = container.newBackgroundContext()
        bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let mainContext = container.viewContext
        
 
             bgContext.performAndWait {
                 let insertRequest = self.newBatchInsertRequest(with: cityPropertiesList)
                 insertRequest.resultType = NSBatchInsertRequestResultType.objectIDs
               let result = try? bgContext.execute(insertRequest) as? NSBatchInsertResult
        
                if let objectIDs = result?.result as? [NSManagedObjectID], !objectIDs.isEmpty {
                    let save = [NSInsertedObjectsKey: objectIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: save, into: [mainContext])
                }
            }
        }
    
    private func newBatchInsertRequest(with propertyList: [CityProperties]) -> NSBatchInsertRequest {
        var index = 0
        let total = propertyList.count

        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: City.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: propertyList[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }

    
    private mutating func loadCountryHash(context:NSManagedObjectContext) async throws {
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

        try context.save()
    }

    
    private mutating func getCountryID(_ code : String, name:String,flag : String, context:NSManagedObjectContext)-> UUID {
        
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
