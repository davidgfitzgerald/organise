//
//  SampleData.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import Foundation
import SwiftUICore
import SwiftData

struct PreviewHelper {
    // Load habits.json into Swift Habit model data for
    // reuse in development across the project.
    @MainActor static func createSampleContainer() -> ModelContainer {
        let container = try! ModelContainer(
            for: Habit.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        let habits: [Habit] = load("habits.json")
        for habit in habits {
            container.mainContext.insert(Habit(name: habit.name))
        }
        
        return container
    }
}

extension View {
    func withSampleData() -> some View {
        self.modelContainer(PreviewHelper.createSampleContainer())
    }
}
