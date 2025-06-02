//
//  SampleData.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import Foundation
import SwiftUICore
import SwiftData

struct SampleData: Codable {
    let habits: [Habit]
    let activities: [Activity]
}

struct PreviewHelper {
    // Load data.json into Swift Habit model data for
    // reuse in development across the project.
    @MainActor static func createSampleContainer() -> ModelContainer {
        let container = try! ModelContainer(
            for: Habit.self, Activity.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        let sampleData: SampleData = load("data.json")

        for habit in sampleData.habits {
            container.mainContext.insert(Habit(name: habit.name))
        }
        
        for activity in sampleData.activities {
            container.mainContext.insert(Activity(name: activity.name))
        }
        
        return container
    }
}

extension View {
    func withSampleData() -> some View {
        self.modelContainer(PreviewHelper.createSampleContainer())
    }
}
