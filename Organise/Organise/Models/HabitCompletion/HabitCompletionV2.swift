//
//  ActivityV2.swift
//  Organise
//
//  Created by David Fitzgerald on 13/07/2025.
//
import Foundation
import SwiftData

@Model
final class HabitCompletionV2 {
    var id = UUID()
    var habit: HabitV2
    var completedAt: Date
    var isCompleted: Bool
    
    init(habit: HabitV2, completedAt: Date) {
        self.habit = habit
        self.completedAt = completedAt
    }
}
