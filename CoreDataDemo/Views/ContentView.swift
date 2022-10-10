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
    
  
    var body: some View {
        
        NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
            CountryListView()
                .navigationTitle("Countries")
        } detail: {
            Text("Select a Country")
        }
        .navigationSplitViewStyle(.balanced)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
