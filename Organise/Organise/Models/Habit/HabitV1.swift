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
    var id: UUID
    var name: String
    var icon: String
    var maxStreak: Int
    var currentStreak: Int
    var colorString: String
    
    // Color persists as a string but is accessed as the object
    var color: Color {
        get {
            Color(from: colorString)
        }
        set {
            colorString = newValue.toString()
        }
    }

    @Relationship(deleteRule: .cascade, inverse: \HabitCompletionV1.habit)
    var completions: [HabitCompletionV1] = []
    
    init(name: String, icon: String, colorString: String, maxStreak: Int, currentStreak: Int) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.colorString = colorString
        self.maxStreak = maxStreak
        self.currentStreak = currentStreak
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
            let newCompletion = HabitCompletionV1(habit: self, completedAt: day, isCompleted: true)
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
