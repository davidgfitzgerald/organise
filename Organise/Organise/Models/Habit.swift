//
//  Habit.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//
import SwiftData
import Foundation

@Model
class Habit: Identifiable {
    var name: String
    var createdAt: Date
    var isLoadingEmoji: Bool
    var emoji: String = "?"
    @Relationship(deleteRule: .cascade, inverse: \Activity.habit)
    var activities: [Activity] = []
    
    // Computed property to access DB context
    private var context: ModelContext! {
        return self.modelContext
    }
    
    init(name: String, emoji: String = "?") {
        self.name = name
        self.createdAt = Date()
        self.isLoadingEmoji = false
        self.emoji = emoji
    }
    
    func activity(_ day: Date) -> Activity? {
        /**
         * Retrieve an activity for a given habit, on a given day, if one exists.
         */
        return activities
            .filter { $0.habit === self }
            .first { $0.completedAt.isOn(day) }
    }
    
    func completedOn(_ day: Date) -> Bool {
        /**
         * Deterine if a given habit has been completed on a given day.
         */
        let result = activity(day) != nil
        return result
    }
    
    
    func complete(_ day: Date = Date()) {
        /**
         * Mark a given habit as completed on a given day.
         *
         * Only create a new activity if one doesn't already exist.
         */
        if activity(day) == nil {
            context.insert(Activity(habit: self, completedAt: day))
            try? context.save()
        }
    }
    
    func decomplete(_ day: Date) {
        /**
         * Mark a given habit as completed on a given day.
         *
         * Only create a new activity if one doesn't already exist.
         */
        if let existingActivity = activity(day) {
            context.delete(existingActivity)
            try? context.save()
        }
    }
}
