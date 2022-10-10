//
//  CoreDataDemoApp.swift
//  CoreDataDemo
//
//  Created by Holger Mayer on 09.10.22.
//

import SwiftUI

@main
struct CoreDataDemoApp: App {
    let persistenceController = PersistenceController.shared
    let navigationRouter = NavigationRouter()
    var body: some Scene {
        WindowGroup {
            ContentView()
               .environment(\.managedObjectContext, persistenceController.container.viewContext)
               .environmentObject(navigationRouter)
        }
    }
}
