//
//  ActivityList.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI
import SwiftData

struct ActivityList: View {
    @Query private var activities: [Activity]
    @Binding var date: Date
    @State private var showingPicker = false

    var body: some View {
        VStack {
            Text("Activities")
                .font(.title)
            
            DatePickerView(date: $date, showing: $showingPicker)
                .padding()
            
            List(activities) { activity in
                Text(activity.name)
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
