//
//  ContentView.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//

import SwiftUI
import SwiftData


struct HabitForm: View {
    @Environment(\.modelContext) private var context
    @State private var name = ""
    @State private var showError = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // TODO: Bug. Allow TextField to be dismissed.
            TextField("", text: $name, prompt: Text("Enter habit name").foregroundColor(showError ? .red : .gray))
            .onSubmit {
                if name.isEmpty {
                    withAnimation(.easeInOut) {
                        showError = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeInOut) {
                            showError = false
                        }
                    }
                } else {
                    let habit = Habit(name: name)
                    print("name is \(name)")
                    context.insert(habit)
                    
                    // Capture value of habitName before it is reset
                    let habitName = name
                    
                    Task {
                        do {
                            habit.isLoadingEmoji = true
                            print("About to create habit with name: '\(habitName)'")
                            let suggestedEmoji = try await ClaudeAPIService.suggestEmoji(for: habitName)
                            await MainActor.run {
                                habit.emoji = suggestedEmoji
                                habit.isLoadingEmoji = false
                            }
                        } catch {
                            await MainActor.run {
                                habit.isLoadingEmoji = false
                            }
                        }
                    }
                    
                    // Reset name
                    name = ""
                }
            }
        }
    }
}

#Preview {
    HabitForm()
        .withSampleData()
}
