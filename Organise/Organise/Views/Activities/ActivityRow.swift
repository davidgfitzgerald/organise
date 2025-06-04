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
        Button {
            print("🔘 Tap detected for: \(activity.habit.name)")
            print("🔘 Current completedAt: \(String(describing: activity.completedAt))")
            
            if activity.completedAt != nil {
                print("🔘 Setting to incomplete")
                activity.completedAt = nil
            } else {
                print("🔘 Setting to complete")
                activity.completedAt = Date()
            }
            
            do {
                try context.save()
                print("✅ Save successful")
            } catch {
                print("❌ Save failed: \(error)")
            }
        } label: {
            HStack {
                Text(activity.habit.name)
                    .foregroundColor(activity.completedAt != nil ? .secondary : .primary)
                Spacer()
                Image(systemName: activity.completedAt != nil ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(activity.completedAt != nil ? .green : .secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onAppear {
            print("📱 Row appeared for: \(activity.habit.name)")
        }
    }
}

#Preview {
    let container = PreviewHelper.createSampleContainer()
    let activity = Activity(habit: Habit(name: "Laundry"), completedAt: Date())
    
    return ActivityRow(activity: activity)
        .modelContainer(container)
}
