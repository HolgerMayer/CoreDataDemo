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
    
     
    @State private var filterString: String = ""
    @State private var needsUpdate = false
    @State private var editableCountry : Country?
    
    var body: some View {
        
        
        VStack {
            
            FilteredList(context: viewContext,predicate:queryPredicate(),sortDescriptors:sortDescriptors(), selection:$navigationRouter.selectedCountry, deleteHandler: {country in
                navigationRouter.resetAll()
                    withAnimation{
                        CountryService.delete(country,context:viewContext)
                        needsUpdate.toggle()
                    }
                }) { (country: Country) in

                    HStack{
                        Text(country.flag ?? "?")
                        Text(country.name ?? "")
                        Spacer()
                        AppSymbol.edit.onTapGesture(perform: {
                            editableCountry = country
                            showEditSheet = true
                        })
                    }
                }
            Spacer()
            StatisticsView()
            
        }
         .searchable(text: $filterString, prompt: "Search")
        .sheet(isPresented: $showEditSheet ) {
            NavigationStack {
                    CountryView(country: editableCountry)
                    .navigationBarTitle(editableCountry != nil ? "Edit country" : "Add country")
            }
        }
        .toolbar{
            ToolbarItem {
                Button(action: addCountry) {
                    Label(title: {Text("Add country")}, icon: {
                        AppSymbol.add
                    })
                }.accessibilityIdentifier("AddCountryButton")
            }
             ToolbarItem(placement: .bottomBar) {
                 HStack {
                     Button("clear") {
                         
                         PersistenceController.clearData(viewContext: viewContext)
                         
                         needsUpdate.toggle()
                         
                     }
                     .accessibilityIdentifier("ClearDataButton")
                     
                     Button("load 1000") {
                         
                         Task {
                             do {
                                 try await PersistenceController.loadData(1000,viewContext: viewContext)
                             } catch {
                                 print("Error while setup")
                             }     
                        }

                         needsUpdate.toggle()
                     }
                     .accessibilityIdentifier("Load1000Button")
                     
                     Button("load all") {
                              Task {
                                  do {
                                      try await PersistenceController.loadData(viewContext: viewContext)
                                  } catch {
                                      print("Error while setup")
                                  }
          
                             }
                          needsUpdate.toggle()
                     }
                     .accessibilityIdentifier("LoadAllButton")
                 }
            }
        }
        
        
    }
    
    
    init(){
    }
    
      

    private func queryPredicate() -> NSPredicate {
        if filterString.isEmpty {
            return  NSPredicate(format: "1=1")
        }
        
        return NSPredicate(format: "(name CONTAINS [c] %@)",  filterString)
    }
    
    private func sortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key:"name",ascending:true)]
    }
    
    private func addCountry() {
        editableCountry = nil
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
