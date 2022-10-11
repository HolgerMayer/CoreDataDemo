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
    
    // edit sheet is used for creation
    @State private var showEditSheet = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Country.name, ascending: true)],
        animation: .default)
    private var countries: FetchedResults<Country>
    
    
    var body: some View {
        VStack {
            List(selection:$navigationRouter.selectedCountry) {
                ForEach (countries) { country in
                    NavigationLink(value: country){
                        Text(country.name ?? "")
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
            StatisticsView()

        }
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
        }
        .environmentObject(NavigationRouter())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
