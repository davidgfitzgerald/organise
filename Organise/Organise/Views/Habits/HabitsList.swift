//
//  ContentView.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//

import SwiftUI
import SwiftData


struct HabitsList: View {
    @Environment(\.modelContext) private var context
    @Binding var date: Date
    @Query(sort: \Habit.createdAt, order: .reverse) private var habits: [Habit]
    
    var body: some View {
        List {
            HabitForm()
            ForEach(habits) { habit in
                
                HabitRow(habit: habit, date: date)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            context.delete(habit)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
    }
}

#Preview {
    HabitsList(date: .constant(Date()))
        .withSampleData()
}
