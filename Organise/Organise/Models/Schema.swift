//
//  Schema.swift
//  Organise
//
//  Created by David Fitzgerald on 13/07/2025.
//

import Foundation
import SwiftData


typealias Habit = HabitV1
typealias HabitCompletion = HabitCompletionV1

let schema = Schema([
    Habit.self,
    HabitCompletion.self
])

enum AppSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 0)
    
    static var models: [any PersistentModel.Type] {
        [
            HabitV1.self,
            HabitCompletionV1.self
        ]
    }
}

enum AppSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 1)
    
    static var models: [any PersistentModel.Type] {
        [
            HabitV2.self,
            HabitCompletionV2.self
        ]
    }
}
