//
//  HabitV1.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//
import SwiftData
import Foundation
import SwiftUICore

@Model
class HabitV1: Identifiable {
    var id = UUID()
    var name: String
    var icon: String
    var color: Color
    var maxStreak: Int
    var currentStreak: Int
    @Relationship(deleteRule: .cascade, inverse: \HabitCompletionV1.habit)
    var completions: [HabitCompletionV1] = []
    
    init(name: String, icon: String, color: Color) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.maxStreak = 0
        self.currentStreak = 0
    }
    
    func completion(for day: Date) -> HabitCompletionV1? {
        /**
         * Retrieve an activity for a given habit on a given day, if one exists.
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
         * Only creates a new activity if one doesn't already exist.
         */
        guard let modelContext = modelContext else {
            throw HabitError.contextNotAvailable
        }
        
        if completion(for: day) == nil {
            let newCompletion = HabitCompletionV1(habit: self, completedAt: day)
            modelContext.insert(newCompletion)
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
        
        if let existingCompletion = completion(for: day) {
            modelContext.delete(existingCompletion)
            try modelContext.save()
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
