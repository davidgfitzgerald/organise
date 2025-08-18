//
//  HabitQueries.swift
//  Organise
//
//  Created by David Fitzgerald on 16/08/2025.
//

import Foundation
import SwiftData
import SwiftUICore


func calculateCompletionPercentage(on date: Date, context: ModelContext) -> Double {
//    @Environment(\.modelContext) var context

    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: date)
    let dayInterval = DateInterval(start: startOfDay, duration: 24 * 60 * 60) // 24 hours
    // TODO add helper to just allow `date.day.start` or something?

    // Get total habits count
    let totalDescriptor = FetchDescriptor<Habit>()
    let totalCount = (try? context.fetchCount(totalDescriptor)) ?? 0

    // Get completed habits count
    let completedPredicate = #Predicate<Habit> { habit in
        habit.completions.contains { completion in
            completion.completedAt >= dayInterval.start && completion.completedAt < dayInterval.end
        }
    }

    let completedDescriptor = FetchDescriptor<Habit>(predicate: completedPredicate)
    let completedCount = (try? context.fetchCount(completedDescriptor)) ?? 0

    guard totalCount > 0 else { return 0.0 }
    return Double(completedCount) / Double(totalCount) * 100.0
}
