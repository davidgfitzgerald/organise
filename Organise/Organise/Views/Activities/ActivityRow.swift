//
//  ActivityRow.swift
//  Organise
//
//  Created by David Fitzgerald on 03/06/2025.
//

import SwiftUI

struct ActivityRow: View {
    var activity: Activity

    var body: some View {
        HStack {
            HStack {
                Text(activity.habit.name)
                
                    .foregroundColor(activity.isCompleted ? .secondary : .primary)
            Spacer()
            }
            .fullStrikethrough(activity.isCompleted)
            
            if activity.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .padding(.leading, 12)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.secondary)
                    .padding(.leading, 12)
            }
        }
    }
}

#Preview {
    @Previewable @State var june2nd2025: Date = {
        var components = DateComponents()
        components.year = 2025
        components.month = 6
        components.day = 2
        return Calendar.current.date(from: components) ?? Date()
    }()
    ActivityDayList(date: $june2nd2025)
        .withSampleData()
}

#Preview {
    let container = PreviewHelper.createSampleContainer()
    let habit = Habit(name: "Laundry")
    let activity = Activity(habit: habit, completedAt: Date())
    container.mainContext.insert(habit)
    container.mainContext.insert(activity)
    try? container.mainContext.save()
    
    return ActivityRow(activity: activity)
}
