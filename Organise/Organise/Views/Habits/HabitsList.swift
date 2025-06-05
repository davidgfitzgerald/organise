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
        List {
            HabitForm()
            ForEach(habits) { habit in
                HabitRow(habit: habit)
            }
        }
    }
}

#Preview {
    return HabitsList()
        .withSampleData()
}
