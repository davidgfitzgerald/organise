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
    @State private var date = Date()
    @State private var showingPicker = false

    var body: some View {
        VStack {
            Text("Activities")
                .font(.title)
                .onTapGesture {
                    if showingPicker {
                        withAnimation {
                            showingPicker = false
                        }
                    }
                }
            DatePickerView(date: $date, showing: $showingPicker)
                .padding()
            
            List(activities) { activity in
                Text(activity.name)
            }
            .onTapGesture {
                if showingPicker {
                    withAnimation {
                        showingPicker = false
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityList()
        .withSampleData()
}
