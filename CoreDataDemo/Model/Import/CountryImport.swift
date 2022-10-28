//
//  CountryImport.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 28.10.22.
//

import Foundation
import CoreData

struct CountryImport {
    
     var countryHash : [String: UUID] = [String: UUID]()
    
     mutating func loadCountryHash(context:NSManagedObjectContext) async throws {
        guard let url = Bundle.main.url(forResource: "CountryEmoji", withExtension: "json") else {
            print("Error : no bundle file CountryEmoji.json")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Error : can't convert to dataCountryEmoji.json ")
            return
        }
        
        let decoder = JSONDecoder()

        guard let jsonCountryEmojis = try? decoder.decode([CountryEmoji].self, from: data) else {
            print("Error : can't parse to dataCountryEmoji.json ")
            return
        }
        
        for countryEmoji in jsonCountryEmojis {
            guard let country = CountryService.create(name: countryEmoji.name, flag:countryEmoji.emoji,context: context) else {
                print("Error : Unable to save \(countryEmoji.name)")
                return
            }
            
            countryHash[countryEmoji.code] = country.id!
        }

        try context.save()
    }
    
    mutating func getCountryID(_ code : String, name:String,flag : String, context:NSManagedObjectContext)-> UUID {
        
        var countryID = countryHash[name]
        if countryID == nil {
            guard let country = CountryService.create(name: name, flag:flag,context: context) else {
                return UUID()
            }
            
            countryHash[name] = country.id!
            countryID = country.id
        }
        
        return countryID!
    }
}
