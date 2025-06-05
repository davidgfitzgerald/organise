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
    var emoji: String = "?"  // TODO use AI to default to a sensible emoji
    @Relationship(deleteRule: .cascade)
    var activities: [Activity] = []
    
    init(name: String) {
        self.name = name
        self.createdAt = Date()
    }
}
