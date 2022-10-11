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
            if navigationRouter.selectedCountry == nil {
                Text("Select a Country")
            } else {
                CityListView(country: navigationRouter.selectedCountry!)
            }
        } detail: {
            if navigationRouter.selectedCity == nil {
                Text("Select a Country and a City")
            } else {
                CityView(city: navigationRouter.selectedCity!)
            }
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
