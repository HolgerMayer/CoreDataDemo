//
//  CityViewModel.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 12.10.22.
//


import Foundation
import CoreData
import MapKit


class CityViewModel : ObservableObject {
    
    @Published var name : String
    @Published var population : Int
    @Published var isCapital : Bool
    @Published var region : MKCoordinateRegion
    
    @Published var isEditing : Bool
  
    var countryID: UUID
    var dataItem : City?
    
    init(country:Country) {
        self.name = ""
        self.population = 0
        self.isCapital = false
        self.countryID = country.id ?? UUID()
        self.dataItem = nil
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.isEditing = true
        
    }
    
    
    init(city: City){
        self.name = city.name ?? ""
        self.population = Int(city.population)
        self.isCapital = city.capital
        self.countryID = city.countryID ?? UUID()
        self.dataItem = city
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: city.latitude, longitude:city.longitude), span: MKCoordinateSpan(latitudeDelta:city.latitudeDelta, longitudeDelta:city.longitudeDelta))
        self.isEditing = false
        
    }
    
    var isValid : Bool {
        return !name.isBlank
    }
    
    var isUpdating : Bool {
        return dataItem != nil
    }
    
    func update(context: NSManagedObjectContext){
        if isValid {
            if dataItem == nil {
                dataItem = CityService.create(name:self.name,countryID: self.countryID,capital:self.isCapital,population:self.population,
                                              latitude:region.center.latitude,longitude:region.center.longitude,
                                              latitudeDelta: region.span.latitudeDelta, longitudeDelta:region.span.longitudeDelta,
                                              context:context)
            } else {
                dataItem!.name = self.name
                dataItem!.population = Int32(self.population)
                dataItem!.capital = self.isCapital
                dataItem!.latitude = self.region.center.latitude
                dataItem!.longitude = self.region.center.longitude
                dataItem!.latitudeDelta = self.region.span.latitudeDelta
                dataItem!.longitudeDelta = self.region.span.longitudeDelta
                CityService.update(dataItem!, context: context)
            }
        }
    }
}
