//
//  NavigationRouter.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 10.10.22.
//

import Foundation


class NavigationRouter : ObservableObject {
    
    @Published var selectedCountry : Country?
    @Published var selectedCity : City?
    
    
    func resetCity(){
        selectedCity = nil
    }
    
    func resetAll(){
        selectedCity = nil
        selectedCountry = nil
    }
    
    
}
