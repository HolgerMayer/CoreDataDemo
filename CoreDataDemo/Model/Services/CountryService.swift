//
//  CountryService.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//


import Foundation
import CoreData

class CountryService : EntityService {
    
 
    static func create(name: String, flag : String="?", context:NSManagedObjectContext) -> Country? {
        let item = Country(context: context)
        item.id = UUID()
        item.name = name
        item.flag = flag

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
    
    
    static func delete(_ object : Country, context : NSManagedObjectContext){
        
        
         do {
             
             try CityService.deleteWhereCountryIDis(object.id!, context:context)
             
             context.delete(object)
             
       
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    static func deleteAll(_ context : NSManagedObjectContext) throws{
        // Specify a batch to delete with a fetch request
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Country")

        // Create a batch delete request for the
        // fetch request
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )

        // Specify the result of the NSBatchDeleteRequest
        // should be the NSManagedObject IDs for the
        // deleted objects
        deleteRequest.resultType = .resultTypeObjectIDs

       // Perform the batch delete
        let batchDelete = try context.execute(deleteRequest)
            as? NSBatchDeleteResult

        guard let deleteResult = batchDelete?.result
            as? [NSManagedObjectID]
            else { return }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        // Merge the delete changes into the managed
        // object context
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [context]
        )
    }
    
    static func count(context:NSManagedObjectContext) -> Int {
        let fetchRequest: NSFetchRequest<Country>
        fetchRequest = Country.fetchRequest()
        
        do {
            
            return try context.count(for: fetchRequest)
        } catch {
            return -1
        }
    }
    
    static func queryByID(_ id: UUID,context:NSManagedObjectContext) -> Country? {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        
        let query = NSPredicate(format: "%K == %@", "id", id as CVarArg)
       
        fetchRequest.predicate = query
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
          print("Failed to fetch country: \(error)")
          return nil
        }
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
