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
    var body: some View {
        VStack {
            Text("Activities")
                .font(.title)
            List {
                ForEach(allActivities) { activity in
                    ActivityRow(activity: activity)
                        .id(activity.id)
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    ActivityDayList()
        .withSampleData()
}

