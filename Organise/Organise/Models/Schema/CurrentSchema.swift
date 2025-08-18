//
//  Schema.swift
//  Organise
//
//  Created by David Fitzgerald on 13/07/2025.
//

import Foundation
import SwiftData


// Set models to the current version
typealias Habit = VersionedSchemaV1.Habit
typealias HabitCompletion = VersionedSchemaV1.HabitCompletion

let schema = Schema([
    Habit.self,
    HabitCompletion.self
])
