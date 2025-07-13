//
//  ActivityV2.swift
//  Organise
//
//  Created by David Fitzgerald on 13/07/2025.
//
import Foundation
import SwiftData

@Model
final class ActivityV2 {
    var habit: HabitV2
    var completedAt: Date
    var due: Date
    
    init(habit: HabitV2, completedAt: Date, due: Date = Date()) {
        self.habit = habit
        self.completedAt = completedAt
        self.due = Calendar.current.startOfDay(for: due)
    }
}
