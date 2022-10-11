//
//  StatisticsView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 11.10.22.
//

import SwiftUI

struct StatisticsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack{
            Text("Countries : \(CountryService.count(context: viewContext))").bold()
            Text("Cities : \(CityService.count(context: viewContext))").bold()
            
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
