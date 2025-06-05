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
    var due: Date
    
    init(habit: Habit, completedAt: Date? = nil, due: Date = Date()) {
        self.habit = habit
        self.completedAt = completedAt
        self.due = Calendar.current.startOfDay(for: due)
    }
}
