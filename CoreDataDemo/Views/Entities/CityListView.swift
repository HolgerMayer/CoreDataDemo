//
//  CityListView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI

struct CityListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var navigationRouter : NavigationRouter

    @FetchRequest var fetchRequest: FetchedResults<City>
    
    
    var body: some View {
        List(selection: $navigationRouter.selectedCity) {
            ForEach (fetchRequest) { city in
                NavigationLink(value: city){
                    Text(city.name!)
                }
            }
            
        }
        .navigationTitle("Cities")
    }
    
    init(country : Country){
        _fetchRequest = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \City.name, ascending: true)],predicate:  NSPredicate(format: "(countryID == %@)",country.id! as NSUUID),
            animation: .default)

    }
    
}

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            CityListView(country:CountryService.example)
        }    .environmentObject(NavigationRouter())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

