//
//  AppSchemaV1.swift
//  Organise
//
//  Created by David Fitzgerald on 10/07/2025.
//
import SwiftData
import Foundation

enum AppSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [
            Habit.self,
            Activity.self
        ]
    }
    
    @Model
    class Habit: Identifiable {
        var name: String
        var createdAt: Date
        var isLoadingEmoji: Bool
        var emoji: String = "?"
        @Relationship(deleteRule: .cascade, inverse: \Activity.habit)
        var activities: [Activity] = []
        
        init(name: String, emoji: String = "?") {
            self.name = name
            self.createdAt = Date()
            self.isLoadingEmoji = false
            self.emoji = emoji
        }
        
        func activity(for day: Date) -> Activity? {
            /**
             * Retrieve an activity for a given habit on a given day, if one exists.
             */
            return activities.first { $0.completedAt.isOn(day) }
        }
        
        func completedOn(_ day: Date) -> Bool {
            /**
             * Determine if a given habit has been completed on a given day.
             */
            return activity(for: day) != nil
        }
        
        func complete(on day: Date = Date()) throws {
            /**
             * Mark a given habit as completed on a given day.
             * Only creates a new activity if one doesn't already exist.
             */
            guard let modelContext = modelContext else {
                throw HabitError.contextNotAvailable
            }
            
            if activity(for: day) == nil {
                modelContext.insert(Activity(habit: self, completedAt: day))
                try modelContext.save()
            }
        }
        
        func decomplete(on day: Date) throws {
            /**
             * Mark a given habit as not completed on a given day.
             * Removes the activity if it exists.
             */
            guard let modelContext = modelContext else {
                throw HabitError.contextNotAvailable
            }
            
            if let existingActivity = activity(for: day) {
                modelContext.delete(existingActivity)
                try modelContext.save()
            }
        }
    }
    
    @Model
    final class Activity {
        var habit: Habit
        var completedAt: Date
        var due: Date
        
        init(habit: Habit, completedAt: Date, due: Date = Date()) {
            self.habit = habit
            self.completedAt = completedAt
            self.due = Calendar.current.startOfDay(for: due)
        }
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
