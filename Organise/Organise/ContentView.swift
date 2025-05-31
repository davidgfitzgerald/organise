//
//  ContentView.swift
//  Organise
//
//  Created by David Fitzgerald on 13/05/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]

    var body: some View {
        NavigationStack {
            List {
                ForEach(habits) { habit in
                    HabitRowView(habit: habit)
                }
                .onDelete(perform: deleteHabits)
                Button(action: addHabit) {
                    Label("Add", systemImage: "plus")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addHabit) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle(Text(Date(), style: .date))
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func addHabit() {
        print("Adding habit")
        let newHabit = Habit(title: "Habit", icon: "😎", isCompleted: false)
        modelContext.insert(newHabit)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save to database: \(error.localizedDescription)")
        }
    }
    
    private func deleteHabits(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(habits[index])
            do {
                try modelContext.save()
            } catch {
                print("Failed to save to database: \(error.localizedDescription)")
            }
        }
    }

}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        
        let modelContext = container.mainContext
        for i in 1...5 {
            let newHabit = Habit(title: "Habit \(i)", icon: "😎", isCompleted: false)
            modelContext.insert(newHabit)
        }
        
        return ContentView()
            .modelContainer(container)
    } catch {
        // Return a fallback view if container creation fails
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
