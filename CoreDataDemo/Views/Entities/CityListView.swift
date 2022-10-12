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
    private var country : Country
    
    // edit sheet is used for creation
    @State private var showEditSheet = false
    
    @State private var needsUpdate = false
    @FetchRequest var fetchRequest: FetchedResults<City>
    
    
    var body: some View {
        List(selection: $navigationRouter.selectedCity) {
            ForEach (fetchRequest) { city in
                NavigationLink(value: city){
                    Text(city.name ?? "")
                }
                .swipeActions{
                    Button(role:.destructive){
                        navigationRouter.resetCity()
                        withAnimation{
                            CityService.delete(city,context:viewContext)
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
        .sheet(isPresented: $showEditSheet ) {
            NavigationStack {
                CityView(country:country)
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
        .navigationTitle("Cities")
    }
    
    init(country : Country){
        self.country = country
        _fetchRequest = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \City.name, ascending: true)],predicate:  NSPredicate(format: "(countryID == %@)",country.id! as NSUUID),
            animation: .default)

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

