//
//  City+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//
//

import Foundation
import CoreData
import CSV

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

struct CityCSV  {
    
    private var countryHash : [String: UUID] = [String: UUID]()

    
    var cityPropertiesList = [CityProperties]()
    
    init(from url:URL, countryHash : [String: UUID] , context : NSManagedObjectContext) throws {
        
        self.countryHash = countryHash
        
        guard let url = Bundle.main.url(forResource: "CountryCityDataLarge", withExtension: "csv") else {
            print("Error : no bundle file CountryCityDataLarge.csv")
            return
        }
        
        guard let stream = InputStream(url: url) else {
            print("Error : can't create input stream for CountryCityDataLarge.csv")
            return
        }
        
        let csv = try! CSVReader(stream: stream,
                                 codecType: UTF8.self,
                                 hasHeaderRow: true,
                                 delimiter:";"
        )
 
        while csv.next() != nil {
            
            guard let countryCode = csv["CountryCode"] else {
                print("Error - no Country")
                return
            }
            let countryID = getCountryID(countryCode, context: context)
            
            guard let city = csv["Name"] else {
                print("Error - no City")
                return
            }
            
            guard let population = csv["Population"] else {
                print("Error - no Population")
                return
            }
            
            
            guard let coordinate = csv["Coordinates"]  else {
                
                
                print("Error - no coordinates")
                return
            }
            
            
            let cityProperties = CityProperties(countryID: countryID, name: city, population: population, coordinate: coordinate)
            cityPropertiesList.append(cityProperties)
        }
    }
    
    private mutating func getCountryID(_ countryCode:String, context:NSManagedObjectContext)-> UUID {
        
        var countryID = countryHash[countryCode]
        if countryID == nil {
            let flag = "?"
            guard let country = CountryService.create(name: countryCode, flag:flag,context: context) else {
                return UUID()
            }
            
            countryHash[countryCode] = country.id!
            
            countryID = country.id
        }
        
        return countryID!
    }
    
    
}

struct CityProperties {
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
