//
//  ActivityDayList.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI
import SwiftData

// TODO move this elsewhere?
extension Date {
    func isOn(_ day: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: day)
    }
}

struct ActivityDayList: View {
    @Query private var allActivities: [Activity]
    @Query private var allHabits: [Habit]
    @Binding var date: Date
    @State private var showingPicker = false
    
    private var completeActivities: [Activity] {
        return allActivities.filter { activity in
            guard let completedAt = activity.completedAt else { return false }
            return completedAt.isOn(date)
        }
    }
    
    private var incompleteHabits: [Habit] {
        let allHabitsSet = Set(allHabits)
        let completeHabitsSet = Set(completeActivities.map { $0.habit })
        return Array(allHabitsSet.subtracting(completeHabitsSet))
    }
    
    var body: some View {
        VStack {
            Text("Activities")
                .font(.title)
            
            DatePickerView(date: $date, showing: $showingPicker)
                .padding()
            
            List {
                ForEach(completeActivities) { activity in
                    ActivityRow(activity: activity)
                }
                ForEach(incompleteHabits) { habit in
                    ActivityRow(activity: Activity(habit: habit))
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
    ActivityDayList(date: $june2nd2025)
        .withSampleData()
}
