//
//  Activity.swift
//  Organise
//
//  Created by David Fitzgerald on 04/06/2025.
//
import Foundation
import SwiftData

@Model
final class Activity {
    var habit: Habit
    var completedAt: Date?
    
    init(habit: Habit, completedAt: Date? = nil) {
        self.habit = habit
        self.completedAt = completedAt
    }
}
