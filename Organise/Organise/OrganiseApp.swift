//
//  OrganiseApp.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//

import SwiftUI
import SwiftData

@main
struct OrganiseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(createModelContainer())
    }
    
    private func createModelContainer() -> ModelContainer {
        do {
            let container = try ModelContainer(for: Habit.self, Activity.self)
            return container
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
