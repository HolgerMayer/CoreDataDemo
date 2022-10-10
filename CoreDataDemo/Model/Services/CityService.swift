//
//  CityService.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import Foundation
import CoreData

class CityService : EntityService {
    
 
    static func create(name: String, countryID: UUID, capital:Bool = false, population: Int = 0, context:NSManagedObjectContext) -> City? {
        let item = City(context: context)
        item.id = UUID()
        item.name = name
        item.countryID = countryID
        item.captial = capital
        item.population = Int32(population)

        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return item
    }
    
}



extension CityService {
    // Example city for Xcode previews
    static var example: City {
        
        // Get the first movie from the in-memory Core Data store
        let context = PersistenceController.preview.container.viewContext
        
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try? context.fetch(fetchRequest)
        
        return (results?.first!)!
    }
    
}
