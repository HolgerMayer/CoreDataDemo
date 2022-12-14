//
//  CountryView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI

struct CountryView: View {
    @Environment(\.presentationMode) var presentationMode
   @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var formVM : CountryViewModel


    var body: some View {
        Form {
            Section {
                TextField("Country name",
                          text: $formVM.name)
                .accessibilityIdentifier("CountryNameTextField")
                
                TextField("Flag",
                          text: $formVM.flag)
                .accessibilityIdentifier("FlagTextField")
                
           }  footer: {
                    Text("Name is required")
                        .font(.caption)
                        .foregroundColor(formVM.name.isBlank ? .red : .clear)
            }
 
        }.toolbar{
            updateSaveButton
        }
    }
    
    var updateSaveButton: some View {
        Button( formVM.isUpdating ? "Update" : "Save", action: {
            formVM.update(context: viewContext)
            presentationMode.wrappedValue.dismiss()
        })
        .disabled(!formVM.isValid)
        .accessibilityIdentifier(formVM.isUpdating ? "UpdateButton" : "SaveButton")
    }
    
    init(country: Country?){
        if country == nil {
            formVM = CountryViewModel()
        } else {
            formVM = CountryViewModel(country: country!)
        }
    }
    
    init(){
        formVM = CountryViewModel()
    }
    
   
}


struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
           NavigationStack {
                CountryView(country: CountryService.example)
                    .navigationTitle("Country")
            }
        NavigationStack {
             CountryView()
                 .navigationTitle("Country")
         }
    }
}
