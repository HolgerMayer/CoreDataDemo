//
//  CityListView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI
import CoreData

struct CityListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var navigationRouter : NavigationRouter
    private var country : Country?
    
    // edit sheet is used for creation
    @State private var showEditSheet = false
    @State private var filterString: String = ""
    @State private var needsUpdate = false
    
    
    var body: some View {
        FilteredList(context: viewContext,predicate:queryPredicate(),sortDescriptors:sortDescriptors(), selection:$navigationRouter.selectedCity, deleteHandler: {city in
            navigationRouter.resetAll()
                withAnimation{
                    CityService.delete(city,context:viewContext)
                    needsUpdate.toggle()
                }
            }) { (city: City) in

                NavigationLink(value: city){
                    Text(city.name ?? "")
                }
        }
            .hidden(country == nil)
        .searchable(text: $filterString, prompt: "Search")
        .sheet(isPresented: $showEditSheet ) {
            NavigationStack {
                CityView(country:country!)
                    .navigationBarTitle("Add city")
            }
        }
        .toolbar{
            ToolbarItem {
                Button(action: addCity) {
                    Label(title: {Text("Add city")}, icon: {
                        AppSymbol.add
                    })
                }
            }

        }
         .navigationBarTitleDisplayMode(.inline)
        .toolbar {
                   ToolbarItem(placement: .principal) {
                       HStack {
                           Text(country?.flag ?? " ").font(.system(size: 48))
                           Text(country?.name ?? "Select a country").font(.headline)
                          
                       }
                   }
                                
        }
    }
    
    init(country : Country?){
        self.country = country
    }
    
  
    
    private func queryPredicate() -> NSPredicate {
        let cid = country?.id ?? UUID()

        if filterString.isEmpty {
            return  NSPredicate(format: "(countryID == %@)",cid as NSUUID)
        }
        
        return NSPredicate(format: "(countryID == %@) AND (name CONTAINS [c] %@)",cid as NSUUID,  filterString)
    }
    
    private func sortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key:"name",ascending:true)]
    }
    
    private func addCity() {
        showEditSheet = true
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

