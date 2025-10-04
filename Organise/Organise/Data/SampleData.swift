//
//  SampleData.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//
import SwiftData
import Foundation


struct HabitData: Codable {
    var id: String
    var name: String
    var icon: String
    var color: String
}

struct CompletionData: Codable {
    var habitId: String
    var completedAt: String
}

struct JsonData: Codable {
    var habits: [HabitData]
    var completions: [CompletionData]
}

@MainActor
func createSampleData(container: ModelContainer, jsonFile: String = "data.json") {
    AppLogger.info("Loading \(jsonFile)")

    let jsonData: JsonData = load(jsonFile)
    
    // Create habits
    var habitsById: [UUID: Habit] = [:]
    for data in jsonData.habits {
        guard let id = UUID(uuidString: data.id) else {
            fatalError("Could not cast \(data.id) to UUID in \(data)")
        }

        let habit = Habit(
            id: id,
            name: data.name,
            icon: data.icon,
            color: data.color,
        )
        container.mainContext.insert(habit)
        habitsById[id] = habit
    }
    
    // Create habit completions
    for completionData in jsonData.completions {
        guard let habitId = UUID(uuidString: completionData.habitId),
              let habit = habitsById[habitId] else {
            continue
        }
        
        let formatter = ISO8601DateFormatter()
        guard let completedAt = formatter.date(from: completionData.completedAt) else {
            continue
        }
        
        let completion = HabitCompletion(
            completedAt: completedAt,
            habit: habit
        )
        container.mainContext.insert(completion)
    }
    
    AppLogger.success("Loaded \(jsonFile)")
}
