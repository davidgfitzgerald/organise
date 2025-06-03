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
        Text("Habits")
            .font(.title)
        List {
            HabitForm()
            ForEach(habits) { habit in
                Text(habit.name)
            }
        }
        .onAppear {
            print("📱 Device - Habits count: \(habits.count)")
            print("📱 ModelContext: \(String(describing: modelContext))")
        }
    }
}

#Preview {
    return HabitsList()
        .withSampleData()
}
