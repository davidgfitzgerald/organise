//
//  OrganiseApp.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//

import SwiftUI
import SwiftData

// Type aliases at the top level
typealias Habit = AppSchemaV1.Habit
typealias Activity = AppSchemaV1.Activity

@main
struct OrganiseApp: App {
    @Environment(\.modelContext) private var context

    var body: some Scene {
        WindowGroup {
            ContentView()
            .onAppear {
                // TODO - determine pros/cons of this approach
                DataManager.shared.modelContext = context
            }
        }
        .modelContainer(
            createModelContainer()
        )

    }
    
    private func createModelContainer() -> ModelContainer {
        do {
            let container = try ModelContainer(
                for: Habit.self, Activity.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            return container
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
