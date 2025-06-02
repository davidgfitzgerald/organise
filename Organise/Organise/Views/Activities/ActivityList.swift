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
            activity.completedAt >= startOfDay && activity.completedAt < endOfDay
        }
    }

    var body: some View {
        VStack {
            Text("Activities")
                .font(.title)
            
            DatePickerView(date: $date, showing: $showingPicker)
                .padding()
            
            List(filteredActivities) { activity in
                Text(activity.habit.name)
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
    @Previewable @State var date: Date = Date()
    ActivityList(date: $date)
        .withSampleData()
}
