//
//  VersionedSchemaV1.swift
//  Organise
//
//  Created by David Fitzgerald on 18/08/2025.
//

import Foundation
import SwiftData


enum VersionedSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 0)
    
    static var models: [any PersistentModel.Type] {
        [
            Habit.self,
        ]
    }
}

extension VersionedSchemaV1 {

    @Model
    final class Habit: Identifiable {
        @Attribute(.unique) var id: UUID
        @Attribute(.unique) var name: String
        var icon: String
        var color: String
        @Relationship(deleteRule: .cascade, inverse: \HabitCompletion.habit) var completions: [HabitCompletion] = []

        init(id: UUID = UUID(), name: String, icon: String = "questionmark", color: String = ".gray") {
            self.id = id
            self.name = name
            self.icon = icon
            self.color = color
        }
    }
    
    @Model
    final class HabitCompletion: Identifiable {
        @Attribute(.unique) var id: UUID
        var completedAt: Date
        var habit: Habit?
        
        init(id: UUID = UUID(), completedAt: Date, habit: Habit? = nil) {
            self.id = id
            self.completedAt = completedAt
            self.habit = habit
        }
    }

}
