//
//  String+ext.swift
//  ProductTest
//
//  Created by Holger Mayer on 25.09.22.
//

import Foundation

extension String {
  var isBlank: Bool {
    self.trimmingCharacters(in: .whitespaces).isEmpty
  }
}
