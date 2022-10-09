//
//  EntityFactory.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//


import Foundation
import CoreData


class EntityFactory {
    
    
    static func update(_ object: NSManagedObject, context : NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    
    static func delete(_ object : NSManagedObject, context : NSManagedObjectContext){
        
        context.delete(object)
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
