//
//  ActivityV1.swift
//  Organise
//
//  Created by David Fitzgerald on 04/06/2025.
//
import Foundation
import SwiftData

@Model
final class ActivityV1 {
    var habit: HabitV1
    var completedAt: Date
    var due: Date
    
    init(habit: HabitV1, completedAt: Date, due: Date = Date()) {
        self.habit = habit
        self.completedAt = completedAt
        self.due = Calendar.current.startOfDay(for: due)
    }
}
