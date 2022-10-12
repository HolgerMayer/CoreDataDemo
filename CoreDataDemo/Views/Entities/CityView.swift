//
//  CityView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI

struct CityView: View {
    @Environment(\.presentationMode) var presentationMode
   @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var formVM : CityViewModel

    
    var body: some View {
        Form {
            TextField("City name", text:$formVM.name)
            TextField("Population", value: $formVM.population, format: .number)
            Toggle("Capital", isOn: $formVM.isCapital)

         }.toolbar{
            updateSaveButton
        }
    }
    
    var updateSaveButton: some View {
        Button( formVM.isUpdating ? "Update" : "Save", action: {
            let shallDismiss = !formVM.isUpdating
            formVM.update(context: viewContext)
            if shallDismiss {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .disabled(!formVM.isValid)
    }
    
    init(city:City){
        formVM = CityViewModel(city: city)
    }
    
    init(country: Country){
        formVM = CityViewModel(country:country)
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView(city: CityService.example)
    }
}
