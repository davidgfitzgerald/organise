//
//  Habit.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//
import SwiftData
import Foundation

@Model
class Habit: Identifiable {
    var name: String
    var createdAt: Date
    var isLoadingEmoji: Bool
    var emoji: String = "?"
    @Relationship(deleteRule: .cascade, inverse: \Activity.habit)
    var activities: [Activity] = []
    
    init(name: String, emoji: String = "?") {
        self.name = name
        self.createdAt = Date()
        self.isLoadingEmoji = false
        self.emoji = emoji
    }
}
