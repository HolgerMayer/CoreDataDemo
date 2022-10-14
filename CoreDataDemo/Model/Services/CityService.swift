//
//  CityService.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import Foundation
import CoreData

class CityService : EntityService {
    
 
    static func create(name: String, countryID: UUID, capital:Bool = false, population: Int = 0,
latitude: Double = 0.0, longitude: Double = 0.0,
                       latitudeDelta : Double = 0.5, longitudeDelta :Double = 0.5,
                       context:NSManagedObjectContext) -> City? {
        let item = City(context: context)
        item.id = UUID()
        item.name = name
        item.countryID = countryID
        item.capital = capital
        item.population = Int32(population)
        item.latitude = latitude
        item.longitude = longitude
        item.latitudeDelta = latitudeDelta
        item.longitudeDelta = longitudeDelta
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
    
    static func deleteWhereCountryIDis(_ countryID : UUID, context: NSManagedObjectContext) throws{
        // Create a fetch request with a predicate
        let fetchRequest: NSFetchRequest<City>
        fetchRequest = City.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "(countryID == %@)",countryID as NSUUID)

        // Setting includesPropertyValues to false means
        // the fetch request will only get the managed
        // object ID for each object
        fetchRequest.includesPropertyValues = false

        // Perform the fetch request
        let objects = try context.fetch(fetchRequest)
            
        // Delete the objects
        for object in objects {
            context.delete(object)
        }

        // Save the deletions to the persistent store
        try context.save()
    }
    
    static func count(context:NSManagedObjectContext) -> Int {
        let fetchRequest: NSFetchRequest<City>
        fetchRequest = City.fetchRequest()
        
        do {
            
            return try context.count(for: fetchRequest)
        } catch {
            return -1
        }
    }
    
    static func deleteAll(_ context : NSManagedObjectContext) throws{
        // Specify a batch to delete with a fetch request
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "City")

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
