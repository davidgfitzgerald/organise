//
//  ActivityDayList.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI
import SwiftData


struct ActivityDayList: View {
    @Environment(\.modelContext) private var context
    @Binding var date: Date
    @Query(sort: \Activity.completedAt) private var allActivities: [Activity]
    @Query private var habits: [Habit]
    
    // Get all due activities for a given day
    private var dayActivities: [Activity] {
        let calendar = Calendar.current
        return allActivities.filter { activity in
            return calendar.isDate(activity.due, inSameDayAs: date)
        }
    }

    // Get all completed activities for a given day
    private var completedActivities: [Activity] {
        let calendar = Calendar.current
        return allActivities.filter { activity in
            return calendar.isDate(activity.completedAt, inSameDayAs: date)
        }
    }
    
    // Get remaining habits which do not have an activity for the given day
    private var remainingHabits: [Habit] {
        let dueHabitIds = Set(dayActivities.map { $0.habit.id })
        return habits.filter { habit in
            !dueHabitIds.contains(habit.id)
        }
    }

    // The day's activities, sorted
    private var sortedActivities: [Activity] {
        let completed = dayActivities
            .sorted {
                return $0.completedAt > $1.completedAt // Most recent first
            }
        
        return completed
    }

    var body: some View {
        VStack {
            List {
                ForEach(sortedActivities) { activity in
                    ActivityRow(activity: activity)
                        .id(activity.id)
                }
            }
            .listStyle(.plain)
            .animation(.easeInOut(duration: 0.3), value: sortedActivities.map { $0.id })
        }
    }
}

//#Preview {
//    ActivityDayList(date: .constant(Date()))
//        .withSampleData()
//}

