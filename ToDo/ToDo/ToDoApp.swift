//
//  ToDoApp.swift
//  ToDo
//
//  Created by David Fitzgerald on 27/04/2025.
//

import SwiftUI
import SwiftData

@main
struct ToDoApp: App {
    let persistenceManager = PersistenceManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceManager.context)
        }
    }
}
