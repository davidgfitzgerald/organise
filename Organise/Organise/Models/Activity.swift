//
//  Activity.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//
import SwiftData
import Foundation

@Model
class Activity {
    var habit: Habit
    var completedAt: Date?
    
    init(habit: Habit, completedAt: Date? = nil) {
        self.habit = habit
        self.completedAt = completedAt
    }
}
