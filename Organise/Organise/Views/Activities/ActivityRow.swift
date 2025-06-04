//
//  ActivityRow.swift
//  Organise
//
//  Created by David Fitzgerald on 03/06/2025.
//
import SwiftData
import SwiftUI

struct ActivityRow: View {
    @Environment(\.modelContext) private var context
    let activity: Activity

    var body: some View {
        HStack {
            HStack {
                Text(activity.habit.name)
                
                    .foregroundColor(activity.completedAt != nil ? .secondary : .primary)
            Spacer()
            }
            .fullStrikethrough(activity.completedAt != nil)
            
            if activity.completedAt != nil {
                Button {
                    print("Button pressed")
                    activity.completedAt = nil
                    try? context.save()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .padding(.leading, 12)
                }
            } else {
                Button {
                    print("Button pressed")
                    activity.completedAt = Date()
                    try? context.save()
                } label: {
                    Image(systemName: "circle")
                        .foregroundColor(.secondary)
                        .padding(.leading, 12)
                }
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
    let activity = Activity(habit: Habit(name: "Laundry"), completedAt: Date())
    
    ActivityRow(activity: activity)
    .modelContainer(container)
}
