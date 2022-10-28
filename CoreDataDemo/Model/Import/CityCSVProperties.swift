//
//  CityCSVProperties.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 28.10.22.
//

import Foundation

struct CityCSVProperties {
    public var id: UUID?
    public var name: String?
    public var capital: Bool
    public var population: Int32
    public var countryID: UUID?
    public var latitude: Double
    public var longitude: Double
    public var latitudeDelta: Double
    public var longitudeDelta: Double
    
    var dictionaryValue: [String: Any] {
        [
            "id": id!,
            "name": name ?? "",
            "capital": capital,
            "population": population,
            "countryID": countryID!,
            "latitude": latitude,
            "longitude": longitude,
            "latitudeDelta": latitudeDelta,
            "longitudeDelta": longitudeDelta,

        ]
    }
    
    
    init(countryID: UUID, name:String, population: String, coordinate:String){
        
        self.id = UUID()
        self.name = name
        self.capital = false
        self.population = Int32(population) ?? -1
        self.countryID = countryID
        
        let coordinateElements = coordinate.components(separatedBy:",")
        self.latitude = 0.0
        self.longitude = 0.0
        if coordinateElements.count == 2 {
            self.latitude = Double(coordinateElements[0]) ?? 0.0
            self.longitude = Double(coordinateElements[1]) ?? 0.0
        }
        self.latitudeDelta = 0.5
        self.longitudeDelta = 0.5
        
    }
}
