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
    private var context: ModelContext? {
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
        print("🔍 completedOn(\(day)): \(result), activities count: \(activities.count)")
        return result
    }
    
    
    func complete(_ day: Date = Date()) {
        /**
         * Mark a given habit as completed on a given day.
         *
         * If an activity already exists, return that, else, create a new one.
         */
        guard let context = context else { 
            print("⚠️ No context available for complete")
            return 
        }
        
        if activity(day) == nil {
            let newActivity = Activity(habit: self, completedAt: day)
            context.insert(newActivity)
            try? context.save()
            print("✅ Created activity for \(day), activities count: \(activities.count)")
        } else {
            print("⚠️ Activity already exists for \(day)")
        }
    }
    
    func decomplete(_ day: Date) {
        guard let context = context else { 
            print("⚠️ No context available for decomplete")
            return 
        }
        
        if let existingActivity = activity(day) {
            context.delete(existingActivity)
            try? context.save()
            print("✅ Deleted activity for \(day), activities count: \(activities.count)")
        } else {
            print("⚠️ No activity found for \(day)")
        }
    }
}
