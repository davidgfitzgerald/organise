//
//  ActivityDayList.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI
import SwiftData


struct ActivityDayList: View {
    @Query(sort: \Activity.habit.name) private var allActivities: [Activity]
    var body: some View {
        VStack {
            Text("Activities")
                .font(.title)
            List {
                ForEach(allActivities) { activity in
                    ActivityRow(activity: activity)
                        .id(activity.id)
                }
            }
            .listStyle(.plain)
            .onAppear {
                print("📱 Activities count: \(allActivities.count)")
                for (index, activity) in allActivities.enumerated() {
                    print("📱 Activity \(index): \(activity.habit.name) - Completed: \(activity.completedAt != nil) - ID: \(activity.id)")
                }
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
    
    return ActivityDayList()
        .modelContainer(container)
}

