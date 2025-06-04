//
//  Habit2.swift
//  Organise
//
//  Created by David Fitzgerald on 04/06/2025.
//

import Foundation
import SwiftData

@Model
class Habit2 {
    var name: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade, inverse: \Activity2.habit)  // TODO: How to handle deleting habits?
    var activities: [Activity2] = []
    
    init(name: String) {
        self.name = name
        self.createdAt = Date()
    }
}
