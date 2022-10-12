//
//  CityView.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI
import MapKit

struct CityView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
      @ObservedObject var formVM : CityViewModel
     @FocusState private var focus: AnyKeyPath?
    
    var body: some View {
        Form {
            Section {
                TextField("City name", text:$formVM.name)
                    .focused($focus,equals: \CityViewModel.name)
                TextField("Population", value: $formVM.population, format: .number)
                    .focused($focus,equals: \CityViewModel.population)
                Toggle("Capital", isOn: $formVM.isCapital)
              }  footer: {
                Text("Name is required")
                    .font(.caption)
                    .foregroundColor(formVM.name.isBlank ? .red : .clear)
            }
            Section {
                Map(coordinateRegion: $formVM.region)
                    .frame(height: 300)
            }
            
        }
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                prepareFocus()
                
            }
        }.toolbar{
            ToolbarItem(placement:.navigationBarTrailing) {
                HStack {
                    updateSaveButton
                }
            }
            ToolbarItemGroup(placement: .keyboard) {
                focusToolbarButtons
            }
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
    
    ///
    /// Focus toolbar buttons
    ///
    var focusToolbarButtons : some View {
        HStack {
            Button {
               previousFocus()
            } label: {
                Image(systemName: "arrow.backward.to.line")
            }
            Button {
                nextFocus()
            } label: {
                Image(systemName: "arrow.right.to.line")
            }
            Spacer()
            Button {
                focus = nil
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
    }
    
    init(city:City){
        formVM = CityViewModel(city: city)
    }
    
    init(country: Country){
        formVM = CityViewModel(country:country)
    }
}


///
/// Focus functions
///
extension CityView { // FOCUS
    
    func prepareFocus() {
            focus = \CityViewModel.name
    }
    
    func nextFocus() {
        switch focus {
        case \CityViewModel.name:
            focus = \CityViewModel.population
        case \CityViewModel.population:
            focus = \CityViewModel.name
       default:
            break
        }
    }
    
    func previousFocus() {
        switch focus {
        case \CityViewModel.population:
            focus = \CityViewModel.name
        case \CityViewModel.name:
            focus = \CityViewModel.population
      default:
            break
        }
    }
}


struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CityView(city: CityService.example)
        }
    }
}
