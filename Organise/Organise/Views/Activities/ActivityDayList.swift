//
//  ActivityDayList.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI
import SwiftData


struct ActivityDayList: View {
    @Binding var date: Date
    @Query(sort: \Activity.completedAt) private var activities: [Activity]
    @Query private var habits: [Habit]
    
    private var sortedActivities: [Activity] {
        let incomplete = activities.filter { $0.completedAt == nil }
            .sorted { $0.habit.name.localizedCaseInsensitiveCompare($1.habit.name) == .orderedAscending }

        
        let completed = activities.filter { $0.completedAt != nil }
            .sorted {
                guard let date1 = $0.completedAt, let date2 = $1.completedAt else { return false }
                return date1 > date2 // Most recent first
            }
        
        return incomplete + completed
    }

    var body: some View {
        VStack {
            Text("Activities")
                .font(.title)
            Text(date.shortest)
            List {
                ForEach(sortedActivities) { activity in
                    ActivityRow(activity: activity)
                        .id(activity.id)
                }
            }
            .listStyle(.plain)
            .animation(.easeInOut(duration: 0.3), value: activities.map { $0.id })

        }
    }
}

#Preview {
    ActivityDayList(date: .constant(Date()))
        .withSampleData()
}

