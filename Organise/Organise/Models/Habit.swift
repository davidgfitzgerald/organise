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
    @Relationship(deleteRule: .cascade, inverse: \Activity.habit)  // TODO: How to handle deleting habits?
    var activities: [Activity] = []
    
    init(name: String) {
        self.name = name
        self.createdAt = Date()
    }
}
