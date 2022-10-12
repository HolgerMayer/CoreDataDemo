//
//  Country+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var flag: String?

}

extension Country : Identifiable {

}
