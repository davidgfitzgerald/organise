//
//  ContentView.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//

import SwiftUI
import SwiftData


struct HabitsList: View {
    @Query(sort: \Habit.createdAt, order: .reverse) private var habits: [Habit]
    
    var body: some View {
        VStack {
            Text("You have \(habits.count) habits")
            List {
                HabitForm()
                ForEach(habits) { habit in
                    Text(habit.name)
                }
            }
        }
    }
}

#Preview {
    return HabitsList()
        .withSampleData()
}
