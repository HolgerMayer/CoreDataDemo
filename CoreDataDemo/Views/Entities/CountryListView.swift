//
//  CountryListView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI

struct CountryListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var navigationRouter : NavigationRouter
 

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Country.name, ascending: true)],
        animation: .default)
    private var countries: FetchedResults<Country>
    var body: some View {
        List(selection:$navigationRouter.selectedCountry) {
            ForEach (countries) { country in
                NavigationLink(value: country){
                    Text(country.name!)
                    
                }
            }
        }

    }
    
    
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CountryListView()
        }
        .environmentObject(NavigationRouter())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
