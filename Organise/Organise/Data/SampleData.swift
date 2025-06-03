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
        let completedAt: String?
    }
}

struct PreviewHelper {
    // FIXED: Removed @MainActor and restructured to avoid preview issues
    static func createSampleContainer() -> ModelContainer {
        do {
            let container = try ModelContainer(
                for: Habit.self, Activity.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            
            // Load and insert data in a Task to handle MainActor properly
            Task { @MainActor in
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
                        print("⚠️ No habit found with ID \(activityData.habitId)")
                        continue // Don't crash, just skip
                    }
                    let completedAt: Date?
                    if activityData.completedAt == nil {
                        completedAt = nil
                    } else {
                        completedAt = formatter.date(from: activityData.completedAt!)
                        if completedAt == nil {
                            print("⚠️ Failed to parse date \(String(describing: activityData.completedAt))")
                        }
                    }

                    let activity = Activity(habit: habit, completedAt: completedAt)
                    container.mainContext.insert(activity)
                }
                
                // Save the context
                try? container.mainContext.save()
            }
            
            return container
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }
}

extension View {
    func withSampleData() -> some View {
        self.modelContainer(PreviewHelper.createSampleContainer())
    }
}
