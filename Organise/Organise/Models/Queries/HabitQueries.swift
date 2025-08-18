//
//  HabitQueries.swift
//  Organise
//
//  Created by David Fitzgerald on 16/08/2025.
//

import Foundation
import SwiftData
import SwiftUICore


func getTotalHabitCount(context: ModelContext) -> Int {
    /**
     * Get the total count of habits.
     */
    let totalCount = (try? context.fetchCount(FetchDescriptor<Habit>())) ?? 0
    AppLogger.debug("totalCount: \(totalCount)")
    return totalCount
}

func getCompletedHabitCount(on date: Date, context: ModelContext) -> Int {
    /**
     * Get the count of habits completed on a day.
     */
    let completedPredicate = #Predicate<Habit> { habit in
        habit.completions.contains { completion in
            completion.completedAt >= date.day.start && completion.completedAt < date.day.end
        }
    }

    let completedCount = (try? context.fetchCount(FetchDescriptor<Habit>(predicate: completedPredicate))) ?? 0
    AppLogger.debug("completedCount: \(completedCount)")
    return completedCount
}

func calculateCompletionPercentage(on date: Date, context: ModelContext) -> Double {
    /**
     * Calculate the percentage of habits completed on a day.
     */
    let totalCount = getTotalHabitCount(context: context)
    guard totalCount > 0 else { return 0.0 }

    let completedCount = getCompletedHabitCount(on: date, context: context)
    let percentage = Double(completedCount) / Double(totalCount)
    
    AppLogger.debug("percentage: \(percentage)")
    
    return percentage
}
