//
//  CountryListView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI

struct CountryListView: View {
    @Environment(\.managedObjectContext) private var viewContext


    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Country.name, ascending: true)],
        animation: .default)
    private var countries: FetchedResults<Country>
    var body: some View {
        List {
            ForEach (countries) { country in
                Text(country.name!)
            }
        }

    }
    
    
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
