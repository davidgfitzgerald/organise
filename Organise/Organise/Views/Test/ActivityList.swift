//
//  ActivityList.swift
//  Organise
//
//  Created by David Fitzgerald on 04/06/2025.
//

import SwiftUI
import SwiftData

struct ActivityList: View {
    @Query(sort: \Activity.habit.name) private var activities: [Activity]
    
    var body: some View {
        List {
            ForEach(activities) { activity in
                ActivityRow(activity: activity)
                    .id(activity.id)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Activity.self, Habit.self, configurations: config)
    
    let sampleHabits: [Habit] = [
        Habit(name: "Exercise"),
        Habit(name: "Read"),
        Habit(name: "Meditate"),
    ]
    sampleHabits.forEach { container.mainContext.insert($0) }
    try? container.mainContext.save()
    
    let sampleActivities = [
        Activity(habit: sampleHabits[0], completedAt: Date()),
        Activity(habit: sampleHabits[1]),
        Activity(habit: sampleHabits[2], completedAt: Date().addingTimeInterval(-3600))
    ]
    sampleActivities.forEach { container.mainContext.insert($0) }

    try? container.mainContext.save()
    
    return ActivityList()
        .modelContainer(container)
}
