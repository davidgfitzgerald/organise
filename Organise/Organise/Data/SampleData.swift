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
    let habits: [HabitData]
    let activities: [ActivityData]
    
    struct HabitData: Codable {
        let id: Int
        let name: String
        let createdAt: String
    }
    
    struct ActivityData: Codable {
        let habitId: Int
        let completedAt: String
    }
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
        
        var habitsById: [Int: Habit] = [:]
        for habitData in sampleData.habits {
            let habit = Habit(name: habitData.name)
            container.mainContext.insert(habit)
            habitsById[habitData.id] = habit
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        for activityData in sampleData.activities {
            guard let habit = habitsById[activityData.habitId] else {
                fatalError("No habit found with ID \(activityData.habitId)")
            }
            if let completedAt = formatter.date(from: activityData.completedAt) {
                print(completedAt)
                let activity = Activity(habit: habit, completedAt: completedAt)
                container.mainContext.insert(activity)
            } else {
                print("Failed to parse date \(activityData.completedAt)")
            }
        }
        
        return container
    }
}

extension View {
    func withSampleData() -> some View {
        self.modelContainer(PreviewHelper.createSampleContainer())
    }
}
