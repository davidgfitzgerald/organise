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
    let completions: [CompletionData]
    
    struct HabitData: Codable {
        let id: String
        let name: String
        let icon: String
        let color: String
        let maxStreak: Int
        let currentStreak: Int
    }
    
    struct CompletionData: Codable {
        let habitId: String
        let completedAt: String
    }
}

@MainActor
func createSampleData(context: ModelContext) throws {
    AppLogger.info("Loading data.json")
    let sampleData: SampleData = load("data.json")
    AppLogger.success("Loaded data.json")
    
    AppLogger.info("Creating habits")
    var habitsById: [UUID: Habit] = [:]
    for habitData in sampleData.habits {
        let habit = Habit(name: habitData.name, icon: habitData.icon, colorString: habitData.color, maxStreak: 0, currentStreak: 0)
        context.insert(habit)
        let habitId = UUID(uuidString: habitData.id)!
        habitsById[habitId] = habit
        AppLogger.info("Created habit \(habit.name)")
    }
    
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    AppLogger.info("Creating habit completions")
    for completionData in sampleData.completions {
        let habitId = UUID(uuidString: completionData.habitId)!
        guard let habit = habitsById[habitId] else {
            AppLogger.error("No habit found with ID \(completionData.habitId)")
            continue
        }
        
        let completedAt: Date = formatter.date(from: completionData.completedAt)!
        
        let completion = HabitCompletion(habit: habit, completedAt: completedAt, isCompleted: true)
        context.insert(completion)
    }
    
    AppLogger.info("Saving context")
    try context.save()
    AppLogger.success("Context saved")
}
