//
//  CityViewModel.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 12.10.22.
//


import Foundation
import CoreData


class CityViewModel : ObservableObject {
    
    @Published var name : String
    @Published var population : Int
    @Published var isCapital : Bool
  
    var countryID: UUID
    var dataItem : City?
    
    init(country:Country) {
        self.name = ""
        self.population = 0
        self.isCapital = false
        self.countryID = country.id!
        self.dataItem = nil
    }
    
    
    init(city: City){
        self.name = city.name ?? ""
        self.population = Int(city.population)
        self.isCapital = city.capital
        self.countryID = city.countryID!
        self.dataItem = city
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
                dataItem = CityService.create(name:self.name,countryID: self.countryID,capital:self.isCapital,population:self.population,context:context)
            } else {
                dataItem!.name = self.name
                dataItem!.population = Int32(self.population)
                dataItem!.capital = self.isCapital
                CityService.update(dataItem!, context: context)
            }
        }
    }
}
