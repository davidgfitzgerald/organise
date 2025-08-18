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
            HabitCompletion.self
        ]
    }
}

extension VersionedSchemaV1 {

    @Model
    class Habit: Identifiable {
        var id: UUID
        var name: String
        var icon: String
        var maxStreak: Int
        var currentStreak: Int
        var colorString: String
        var isLoadingIcon: Bool

        @Relationship(deleteRule: .cascade, inverse: \HabitCompletion.habit)
        var completions: [HabitCompletion] = []
        
        init(
            name: String,
            icon: String,
            colorString: String,
            maxStreak: Int,
            currentStreak: Int,
            isLoadingIcon: Bool = false
        ) {
            self.id = UUID()
            self.name = name
            self.icon = icon
            self.colorString = colorString
            self.maxStreak = maxStreak
            self.currentStreak = currentStreak
            self.isLoadingIcon = isLoadingIcon
        }
        
        func completion(for day: Date) -> HabitCompletion? {
            /**
             * Retrieve a completion for a given habit on a given day, if one exists.
             */
            return completions.first { $0.completedAt.isOn(day) }
        }
        
        func completedOn(_ day: Date) -> Bool {
            /**
             * Determine if a given habit has been completed on a given day.
             */
            return completion(for: day) != nil
        }
        
        func complete(on day: Date = Date()) throws {
            /**
             * Mark a given habit as completed on a given day.
             * Only creates a new completion if one doesn't already exist.
             */
            guard let modelContext = modelContext else {
                throw HabitError.contextNotAvailable
            }
            
            if completion(for: day) == nil {
                let newCompletion = HabitCompletion(habit: self, completedAt: day, isCompleted: true)
                modelContext.insert(newCompletion)
                try modelContext.save()
            }
        }
        
        func decomplete(on day: Date) throws {
            /**
             * Mark a given habit as not completed on a given day.
             * Removes the completion if it exists.
             */
            guard let modelContext = modelContext else {
                throw HabitError.contextNotAvailable
            }
            
            if let existingCompletion = completion(for: day) {
                modelContext.delete(existingCompletion)
                try modelContext.save()
            }
        }
        
        func toggleCompletion(on day: Date) throws {
            /**
             * Toggle a habit's completion on a day to
             * become either completed, or not completed.
             */
            if completedOn(day) {
                try decomplete(on: day)
            } else {
                try complete(on: day)
            }
        }
        
        enum HabitError: Error {
            case contextNotAvailable
            
            var localizedDescription: String {
                switch self {
                case .contextNotAvailable:
                    return "Database context is not available"
                }
            }
        }
    }
    
    @Model
    final class HabitCompletion {
        var id: UUID
        
        @Relationship var habit: Habit?
        var completedAt: Date
        var isCompleted: Bool
        
        init(habit: Habit, completedAt: Date, isCompleted: Bool) {
            self.id = UUID()
            self.habit = habit
            self.completedAt = completedAt
            self.isCompleted = isCompleted
        }
    }

}
