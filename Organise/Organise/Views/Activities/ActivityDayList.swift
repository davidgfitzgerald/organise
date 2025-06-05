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
    private var dueActivities: [Activity] {
        let calendar = Calendar.current
        return allActivities.filter { activity in
            return calendar.isDate(activity.due, inSameDayAs: date)
        }
    }

    // Get all completed activities for a given day
    private var completedActivities: [Activity] {
        let calendar = Calendar.current
        return allActivities.filter { activity in
            return calendar.isDate(activity.due, inSameDayAs: date) && activity.completedAt != nil
        }
    }
    
    // Get remaining habits which do not have an activity for the given day
    private var remainingHabits: [Habit] {
        let dueHabitIds = Set(dueActivities.map { $0.habit.id })
        return habits.filter { habit in
            !dueHabitIds.contains(habit.id)
        }
    }

    // The days activities, sorted
    private var sortedActivities: [Activity] {
        let incomplete = dueActivities.filter { $0.completedAt == nil }
            .sorted { $0.habit.name.localizedCaseInsensitiveCompare($1.habit.name) == .orderedAscending }

        
        let completed = dueActivities.filter { $0.completedAt != nil }
            .sorted {
                guard let date1 = $0.completedAt, let date2 = $1.completedAt else { return false }
                return date1 > date2 // Most recent first
            }
        
        return incomplete + completed
    }
    
    // Func to create remaining habits
    private func createRemainingActivities() {
        for habit in remainingHabits {
            let activity = Activity(habit: habit, due: date)
            context.insert(activity)
        }
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
        .onAppear {
            createRemainingActivities()
        }
        .onChange(of: date) {
            createRemainingActivities()
        }
    }
}

#Preview {
    ActivityDayList(date: .constant(Date()))
        .withSampleData()
}

