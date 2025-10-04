//
//  ContentView.swift
//  Organise
//
//  Created by David Fitzgerald on 04/10/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var habits: [Habit]

    var body: some View {
        NavigationView {
            List(habits, id: \.id) { habit in
                HStack(spacing: 12) {
                    Image(systemName: habit.icon)
                        .foregroundColor(Color(from: habit.color))
                        .font(.title2)
                        .frame(width: 30)
                    
                    Text(habit.name)
                        .font(.body)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Habits")
        }
    }
}

#Preview {
    var shouldCreateDefaults = true
    ContentView()
        .modelContainer(
            DataContainer.create(
                shouldCreateDefaults: &shouldCreateDefaults,
                configuration: ModelConfiguration(isStoredInMemoryOnly: true)
            )
        )
}
