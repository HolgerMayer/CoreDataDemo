//
//  ContentView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var navigationRouter : NavigationRouter
    
    var body: some View {
        
        NavigationSplitView(columnVisibility: .constant(.all)) {
            CountryListView()
                .navigationTitle("Countries")
        } content: {
                CityListView(country: navigationRouter.selectedCountry).hidden(navigationRouter.selectedCountry == nil)
        } detail: {
                 CityView(city: navigationRouter.selectedCity).hidden( navigationRouter.selectedCity == nil )
       }
        .navigationSplitViewStyle(.balanced)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NavigationRouter())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
