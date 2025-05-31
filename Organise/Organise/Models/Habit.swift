//
//  Habit.swift
//  Organise
//
//  Created by David Fitzgerald on 20/05/2025.
//

import Foundation
import SwiftData

@Model
final class Habit {
    var title: String
    var icon: String
    var isCompleted: Bool
    private var createdAt: Date
    
    init(title: String, icon: String, isCompleted: Bool = false) {
        self.title = title
        self.icon = icon
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
}

