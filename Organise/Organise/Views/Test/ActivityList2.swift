//
//  Activity2List.swift
//  Organise
//
//  Created by David Fitzgerald on 04/06/2025.
//

import SwiftUI
import SwiftData

struct ActivityList2: View {
    @Query(sort: \Activity2.habit.name) private var items: [Activity2]
    
    var body: some View {
        List {
            ForEach(items) { item in
                ActivityRow2(item: item)
                    .id(item.id)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Activity2.self, Habit2.self, configurations: config)
    
    let sampleHabits: [Habit2] = [
        Habit2(name: "Exercise"),
        Habit2(name: "Read"),
        Habit2(name: "Meditate"),
    ]
    sampleHabits.forEach { container.mainContext.insert($0) }
    try? container.mainContext.save()
    
    let sampleActivities = [
        Activity2(habit: sampleHabits[0], completedAt: Date()),
        Activity2(habit: sampleHabits[1]),
        Activity2(habit: sampleHabits[2], completedAt: Date().addingTimeInterval(-3600))
    ]
    sampleActivities.forEach { container.mainContext.insert($0) }

    try? container.mainContext.save()
    
    return ActivityList2()
        .modelContainer(container)
}
