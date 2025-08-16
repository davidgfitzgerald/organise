//
//  HabitCompletionV2.swift
//  Organise
//
//  Created by David Fitzgerald on 04/06/2025.
//
import Foundation
import SwiftData

@Model
final class HabitCompletionV2 {
    var id: UUID
    var habit: HabitV2
    var completedAt: Date
    var isCompleted: Bool
    
    init(habit: HabitV2, completedAt: Date, isCompleted: Bool) {
        self.id = UUID()
        self.habit = habit
        self.completedAt = completedAt
        self.isCompleted = isCompleted
    }
}
