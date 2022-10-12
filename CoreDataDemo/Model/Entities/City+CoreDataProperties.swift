//
//  City+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var capital: Bool
    @NSManaged public var population: Int32
    @NSManaged public var countryID: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var latitudeDelta: Double
    @NSManaged public var longitudeDelta: Double

}

extension City : Identifiable {

}
