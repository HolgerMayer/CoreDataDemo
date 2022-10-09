//
//  CityListView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI

struct CityListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var fetchRequest: FetchedResults<City>
    private var cities: FetchedResults<City>
    
    
    var body: some View {
        List {
            ForEach (cities) { city in
                Text(city.name!)
            }
            
        }
        
    }
    
    init(country : Country){
        _fetchRequest = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \City.name, ascending: true)],predicate:  NSPredicate(format: "(countryID == %@)",country.id! as NSUUID),
            animation: .default)
        self.cities = cities
    }
    
}

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView(country:CountryFactory.example)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

