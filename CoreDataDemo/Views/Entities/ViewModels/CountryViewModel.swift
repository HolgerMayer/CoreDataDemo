//
//  CountryViewModel.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 11.10.22.
//

import Foundation
import CoreData


class CountryViewModel : ObservableObject {
    
    @Published var name : String
    
    var dataItem : Country?
    
    init() {
        self.name = ""
        self.dataItem = nil
    }
    
    
    init(country: Country){
        self.name = country.name ?? ""
        self.dataItem = country
    }
    
    var isValid : Bool {
        return !name.isEmpty
    }
    
    var isUpdating : Bool {
        return dataItem != nil
    }
    
    func update(context: NSManagedObjectContext){
        if isValid {
            if dataItem == nil {
                dataItem = CountryService.create(name: self.name, context: context)
            } else {
                dataItem!.name = self.name
                CountryService.update(dataItem!, context: context)
            }
        }
    }
}
