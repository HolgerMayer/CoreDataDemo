//
//  FilteredList.swift
//
//  Created by Holger Mayer on 19.07.21.
//

// Example usage:

//FilteredList(context: viewContext,predicate:queryPredicate(),sortDescriptors:sortDescriptors(), deleteHandler: {book in
//    viewContext.delete(book)
//    do {
//        try self.viewContext.save()
//    } catch {
//         Replace this implementation with code to handle the error appropriately.
//         fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        let nsError = error as NSError
//        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//    }
//}) { (item: Book) in
//
//        BookListRow(item: item)
//   }

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    
    var context : NSManagedObjectContext
    
    @Binding var selection : T?
    
    var fetchRequest: FetchRequest<T>
    var items: FetchedResults<T> { fetchRequest.wrappedValue }

    // this is our content closure; we'll call this once for each item in the list
    let deleteHandler:(T) -> Void?
    let content: (T) -> Content

    /// The view to create
    var body: some View {
        List(selection:$selection) {
            ForEach(fetchRequest.wrappedValue, id: \.self) { item in
                self.content(item)
                    .swipeActions{
                        Button(role:.destructive){
                            deleteHandler(item)
                         } label: {
                            Label(title: {
                                Text("Delete")
                            }, icon: {
                                Image(systemName: "trash")
                            })
                        }
                    }
            }
          
        }
    }

    /// Initilizer with key value semantics for filter
    init(context: NSManagedObjectContext, filterKey: String, filterValue: String, sortKey : String = "" , selection :  Binding<T?>,deleteHandler : @escaping (T) -> Void,   @ViewBuilder content: @escaping (T) -> Content) {
        
        self.context = context
        var sortDescriptor = [NSSortDescriptor]()
        if !sortKey.isEmpty {
            sortDescriptor = [NSSortDescriptor(key:sortKey,ascending:true)]
        }
        
        if filterValue.isEmpty {
            fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors:sortDescriptor)

        } else {
            fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors:sortDescriptor, predicate: NSPredicate(format: "%K CONTAINS [c] %@", filterKey, filterValue))
        }
        
        _selection = selection
        self.deleteHandler = deleteHandler
        self.content = content
    }
    
    
    // initializer with predicate
    init(context: NSManagedObjectContext, predicate : NSPredicate, sortDescriptors : [NSSortDescriptor] = [] , selection:Binding<T?>,deleteHandler : @escaping (T) -> Void,  @ViewBuilder content: @escaping (T) -> Content) {
        
 
        self.context = context
        
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors:sortDescriptors, predicate:predicate)
        
        _selection = selection
        self.deleteHandler = deleteHandler
        self.content = content
    }
    
}

