//
//  AppSymbol.swift
//  ProductTest
//
//  Created by Holger Mayer on 14.09.22.
//

import SwiftUI

enum AppSymbol : String , Codable , View {
    
    case add
    case delete
    case edit

    
    var body: some View {
        
        switch (self) {
        case .add:
            return Image(systemName: "plus.circle.fill")
        case .delete:
            return Image(systemName: "trash")
        case .edit:
            return Image(systemName:  "info.circle")
        }

    }
    
   
}
