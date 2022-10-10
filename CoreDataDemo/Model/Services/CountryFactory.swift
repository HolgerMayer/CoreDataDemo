//
//  CountryService.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//


import Foundation
import CoreData

class CountryService : EntityService {
    
 
    static func create(name: String, context:NSManagedObjectContext) -> Country? {
        let item = Country(context: context)
        item.id = UUID()
        item.name = name

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


extension CountryService {
    
    // Example country for Xcode previews
    static var example: Country {
        
        // Get the first movie from the in-memory Core Data store
        let context = PersistenceController.preview.container.viewContext
        
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try? context.fetch(fetchRequest)
        
        return (results?.first!)!
    }
    
}
