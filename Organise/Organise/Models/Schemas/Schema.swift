//
//  Schema.swift
//  Organise
//
//  Created by David Fitzgerald on 13/07/2025.
//

import Foundation
import SwiftData


typealias Habit = AppSchemaV1.Habit
typealias Activity = AppSchemaV1.Activity

let schema = Schema([
    Habit.self,
    Activity.self
])

let modelConfiguration = ModelConfiguration(schema: schema)
var container: ModelContainer {
    do {
        let modelConfiguration = ModelConfiguration(schema: schema)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Failed to create ModelContainer: \(error)")
    }
}
