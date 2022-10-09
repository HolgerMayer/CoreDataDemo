//
//  CityView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI

struct CityView: View {
    
    var city : City
    
    var body: some View {
        VStack {
            Text(city.name!)
            Text("Population: \(city.population)")
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView(city: CityFactory.example)
    }
}
