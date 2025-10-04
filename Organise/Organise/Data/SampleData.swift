//
//  SampleData.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//
import SwiftData
import Foundation


struct HabitData: Codable, Identifiable {
    var id: String
    var name: String
    var icon: String
    var color: String
}


struct JsonData: Codable {
    var habits: [HabitData]
}

@MainActor
func createSampleData(container: ModelContainer, jsonFile: String = "data.json") {
    AppLogger.info("Loading \(jsonFile)")

    let jsonData: JsonData = load(jsonFile)
    
    // Create habits
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
    }
    
    AppLogger.success("Loaded \(jsonFile)")
}
