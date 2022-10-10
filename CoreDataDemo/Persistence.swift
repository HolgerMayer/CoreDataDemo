//
//  Persistence.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        PersistenceController.loadData(viewContext: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataDemo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    
    static func loadData(viewContext : NSManagedObjectContext){
        let canada = CountryFactory.create(name: "Canada", context: viewContext)
        
        let _ = CityFactory.create(name: "Vancover", countryID: canada!.id! , population: 2632000,context: viewContext)
        let _ = CityFactory.create(name: "Victoria", countryID: canada!.id! ,capital:true, population: 394000,context: viewContext)
        let _ = CityFactory.create(name: "Toronto", countryID: canada!.id! , population: 6313000,context: viewContext)
        
        let usa = CountryFactory.create(name: "United States", context: viewContext)
        let _ = CityFactory.create(name: "Seattle", countryID: usa!.id! , population: 4102100,context: viewContext)
        let _ = CityFactory.create(name: "Denver", countryID: usa!.id! , capital:true,population: 2897000,context: viewContext)
        let _ = CityFactory.create(name: "Washington D.C.", countryID: usa!.id! , population: 5434000,context: viewContext)
    }
}
