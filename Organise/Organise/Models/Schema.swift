//
//  Schema.swift
//  Organise
//
//  Created by David Fitzgerald on 13/07/2025.
//

import Foundation
import SwiftData


typealias Habit = HabitV1
typealias Activity = ActivityV1

let schema = Schema([
    Habit.self,
    Activity.self
])

enum AppSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 0)
    
    static var models: [any PersistentModel.Type] {
        [
            HabitV1.self,
            ActivityV1.self
        ]
    }
}

enum AppSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 1)
    
    static var models: [any PersistentModel.Type] {
        [
            HabitV2.self,
            ActivityV2.self
        ]
    }
}
