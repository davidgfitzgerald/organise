//
//  ActivityList.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI
import SwiftData

struct ActivityList: View {
    @Query private var allActivities: [Activity]
    @Binding var date: Date
    @State private var showingPicker = false
    
    private var filteredActivities: [Activity] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return allActivities.filter { activity in
            guard let completedAt = activity.completedAt else { return false}
            return completedAt >= startOfDay && completedAt < endOfDay
        }
    }

    var body: some View {
        VStack {
            Text("Activities")
                .font(.title)
            
            DatePickerView(date: $date, showing: $showingPicker)
                .padding()
            
            List {
                ForEach(filteredActivities) { activity in
                    ActivityRow(activity: activity)
                }
                ActivityRow(activity: Activity(habit: Habit(name: "Test")))
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
    ActivityList(date: $june2nd2025)
        .withSampleData()
}
