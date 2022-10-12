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
    private var country : Country
    
    // edit sheet is used for creation
    @State private var showEditSheet = false
    @State private var query: String = ""
    @State private var needsUpdate = false
    
    
    var body: some View {
        List(selection: $navigationRouter.selectedCity) {
            ForEach (filteredResults) { city in
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
        .searchable(text: $query, prompt: "Search")
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
        .navigationTitle("\(country.flag ?? "?") Cities")
    }
    
    init(country : Country){
        self.country = country
    }
    
    var filteredResults : [City] {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \City.name, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "(countryID == %@)",country.id! as NSUUID)
        
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

