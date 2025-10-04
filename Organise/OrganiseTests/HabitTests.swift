//
//  HabitTests.swift
//  HabitTests
//
//  Created by David Fitzgerald on 04/10/2025.
//

import Testing
import SwiftData
@testable import Organise


@MainActor
@Test func createSampleDataLoadsHabits() async throws {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(
        for: Habit.self,
        configurations: config
    )
    
    createSampleData(container: container)
    
    let habits = try container.mainContext.fetch(FetchDescriptor<Habit>())
    #expect(habits.count == 1)
    #expect(habits[0].name == "Drink Water")
    #expect(habits[0].icon == "drop.fill")
    #expect(habits[0].color == ".blue")
}

