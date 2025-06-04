//
//  Activity2.swift
//  Organise
//
//  Created by David Fitzgerald on 04/06/2025.
//
import Foundation
import SwiftData

@Model
final class Activity2 {
    var habit: Habit2
    var completedAt: Date?
    
    init(habit: Habit2, completedAt: Date? = nil) {
        self.habit = habit
        self.completedAt = completedAt
    }
}
