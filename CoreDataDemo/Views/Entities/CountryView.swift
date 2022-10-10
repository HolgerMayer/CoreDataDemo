//
//  CountryView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI

struct CountryView: View {
    
    var country : Country
    
    var body: some View {
        Text(country.name!)
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        CountryView(country: CountryService.example)
    }
}
