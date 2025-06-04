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
    @Binding var date: Date
    @State private var showingPicker = false
    
    var body: some View {
        VStack {
            Text("Activities")
                .font(.title)
            
            DatePickerView(date: $date, showing: $showingPicker)
                .padding()
            
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
        .dismissDatePicker(when: showingPicker) {
            withAnimation {
                showingPicker = false
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
    
    let container = try! ModelContainer(for: Activity.self, Habit.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    
    // Create habits
    let exercise = Habit(name: "Exercise")
    let read = Habit(name: "Read")
    let meditate = Habit(name: "Meditate")
    
    // Create activities
    let exerciseActivity = Activity(habit: exercise, completedAt: Date())
    let readActivity = Activity(habit: read, completedAt: nil)
    let meditateActivity = Activity(habit: meditate, completedAt: Date())
    
    // Insert into context
    context.insert(exercise)
    context.insert(read)
    context.insert(meditate)
    context.insert(exerciseActivity)
    context.insert(readActivity)
    context.insert(meditateActivity)
    
    return ActivityDayList(date: $june2nd2025)
        .modelContainer(container)
}
