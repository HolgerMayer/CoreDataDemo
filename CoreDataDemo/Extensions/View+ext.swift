//
//  View+ext.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 01.11.22.
//

import SwiftUI

extension View {
  func hidden(_ hidden: Bool) -> some View {
    self.opacity(hidden ? 0 : 1)
  }
}
