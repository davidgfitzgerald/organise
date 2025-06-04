//
//  Activity.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//
import SwiftData
import Foundation

@Model
class Activity: Identifiable {
    var id: UUID
    var habit: Habit
    var completedAt: Date?
    
    init(habit: Habit, completedAt: Date? = nil) {
        self.id = UUID()
        self.habit = habit
        self.completedAt = completedAt
    }
    
//    var isCompleted: Bool {
//        completedAt != nil
//    }
}
