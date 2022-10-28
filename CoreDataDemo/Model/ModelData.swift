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
    
        
    var countryImport : CountryImport
    
    
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
    
    init() {
        
        self.countryImport = CountryImport()
    }
    
    mutating func  load(_ noOfCities : Int = -1,  container : NSPersistentContainer) async {
        
   
        
        
        
        guard let url = Bundle.main.url(forResource: "CountryCityDataLarge", withExtension: "csv") else {
            print("Error : no bundle file CountryCityDataLarge.csv")
            return
        }
       

        do {
            let context = container.viewContext
            
            try await countryImport.loadCountryHash(context:context)

            let cityList = try CityCSV(from: url, countryHash:countryImport.countryHash, context: context)
            
            // Add name and author to identify source of persistent history changes.
            
            await syncCities(with: cityList.cityPropertiesList)
            
        } catch {
            print("Error : CityCSV")
        }
    }
    
    
    private mutating func syncCities(with cityPropertiesList: [CityCSVProperties]) async {
        
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
    
    private func newBatchInsertRequest(with propertyList: [CityCSVProperties]) -> NSBatchInsertRequest {
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

    

}
