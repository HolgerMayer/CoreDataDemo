//
//  StatisticsView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 11.10.22.
//

import SwiftUI

struct StatisticsView: View {

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Country.name, ascending: true)],
        animation: .default)
    private var countries: FetchedResults<Country>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \City.name, ascending: true)],
        animation: .default)
    private var cities: FetchedResults<City>

    
    
    var body: some View {
        VStack{
            Text("Countries : \(countries.count)").bold()
            Text("Cities : \(cities.count)").bold()
            
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.blue)
            .cornerRadius(15)
    }
}
    

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}
