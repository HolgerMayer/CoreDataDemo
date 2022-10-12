//
//  CountryListView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI
import CoreData

struct CountryListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var navigationRouter : NavigationRouter
    
    // edit sheet is used for creation
    @State private var showEditSheet = false
    
     
    @State private var query: String = ""
    @State private var needsUpdate = false
    
    var body: some View {
        
        
        VStack {
            List(selection:$navigationRouter.selectedCountry) {
                ForEach (filteredResults) { country in
                    NavigationLink(value: country){
                        HStack{
                            Text(country.flag ?? "?")
                            Text(country.name ?? "")
                            Spacer()
                        }
                    }
                    // we implement delete as a swipe action because
                    // it is modern style
                    // it is posible to use wthout a ForEach loop
                    // the ForEach loop has no selection variable
                    .swipeActions{
                        Button(role:.destructive){
                            navigationRouter.resetAll()
                            withAnimation{
                                CountryService.delete(country,context:viewContext)
                                needsUpdate.toggle()
                            }
                        } label: {
                            Label(title: {
                                Text("Delete")
                            }, icon: {
                                AppSymbol.delete
                            })
                        }
                    }
                }
            }
            Spacer()
            StatisticsView(update:needsUpdate)
            
        }
         .searchable(text: $query, prompt: "Search")
        .sheet(isPresented: $showEditSheet ) {
            NavigationStack {
                CountryView()
                    .navigationBarTitle("Add country")
            }
        }
        .toolbar{
            ToolbarItem {
                Button(action: addCountry) {
                    Label(title: {Text("Add country")}, icon: {
                        AppSymbol.add
                    })
                }
            }
             ToolbarItem(placement: .bottomBar) {
                Button("Initialize") {
                    PersistenceController.loadData(viewContext: viewContext)
                    needsUpdate.toggle()
                }
            }
        }
        
        
    }
    
    
    init(){
    }
    
    var filteredResults : [Country] {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()

            do {
                let result =  try viewContext.fetch(fetchRequest)
                if query.isEmpty {
                    return result
                } else {
                    return result.filter({$0.name!.lowercased().contains(query.lowercased())})
                }
            } catch {
                print("Failed to fetch countries: \(error)")
                return []
            }
    }
    

    private func addCountry() {
        showEditSheet = true
    }
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CountryListView()
                .navigationBarTitle("Countries")
        }
        .environmentObject(NavigationRouter())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
