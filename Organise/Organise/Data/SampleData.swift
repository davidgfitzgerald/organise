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
        let emoji: String
    }
    
    struct ActivityData: Codable {
        let habitId: Int
        let completedAt: String
    }
}

struct PreviewHelper {
    static func createSampleContainer() -> ModelContainer {
        do {
            let container = try ModelContainer(
                for: Habit.self, Activity.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            
            // Create a new context that isn't MainActor isolated
            let context = ModelContext(container)
            
            let sampleData: SampleData = load("data.json")
            
            var habitsById: [Int: Habit] = [:]
            for habitData in sampleData.habits {
                let habit = Habit(name: habitData.name, emoji: habitData.emoji)
                context.insert(habit)
                habitsById[habitData.id] = habit
            }
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            for activityData in sampleData.activities {
                guard let habit = habitsById[activityData.habitId] else {
                    print("⚠️ No habit found with ID \(activityData.habitId)")
                    continue
                }
                
                let completedAt: Date = formatter.date(from: activityData.completedAt)!
                
                let activity = Activity(habit: habit, completedAt: completedAt)
                context.insert(activity)
            }
            
            try context.save()
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
