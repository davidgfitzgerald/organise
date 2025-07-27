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
        let id: UUID
        let name: String
        let icon: String
        let color: String
        let maxStreak: Int
        let currentStreak: Int
    }
    
    struct ActivityData: Codable {
        let habitId: UUID
        let completedAt: String
    }
}

struct PreviewHelper {
    static func createSampleData() {
        do {
            // Create a new context that isn't MainActor isolated
            let context = ModelContext(container)
            
            let sampleData: SampleData = load("data.json")
            
            var habitsById: [UUID: Habit] = [:]
            for habitData in sampleData.habits {
//                let habit = Habit(name: habitData.name, emoji: habitData.emoji)
                let habit = Habit(name: habitData.name, icon: habitData.icon, color: ColorParser.color(from: habitData.color))
                context.insert(habit)
                habitsById[habitData.id] = habit
            }
            
//            let formatter = ISO8601DateFormatter()
//            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//            
//            for activityData in sampleData.activities {
//                guard let habit = habitsById[activityData.habitId] else {
//                    print("⚠️ No habit found with ID \(activityData.habitId)")
//                    continue
//                }
//                
//                let completedAt: Date = formatter.date(from: activityData.completedAt)!
//                
//                let activity = Activity(habit: habit, completedAt: completedAt)
//                context.insert(activity)
//            }
            
            try context.save()
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }
}

extension View {
    func withSampleData() -> some View {
        PreviewHelper.createSampleData()
        return self.modelContainer(container)
    }
}
