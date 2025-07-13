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
    @State private var errorMessage = ""
    @State private var showEmojiError = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("", text: $name, prompt: Text("Enter habit name").foregroundColor(showError ? .red : .gray))
                .focused($isTextFieldFocused)
                .onSubmit {
                    submitHabit()
                }
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside the TextField
            isTextFieldFocused = false
        }
        .alert("Emoji Generation Failed", isPresented: $showEmojiError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func submitHabit() {
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
            context.insert(habit)
            
            // Capture value of habitName before it is reset
            let habitName = name
            
            Task {
                do {
                    habit.isLoadingEmoji = true
                    print("Creating habit: '\(habitName)'")
                    
                    // Use the retry mechanism for better reliability
                    let suggestedEmoji = try await ClaudeAPIService.suggestEmojiWithRetry(for: habitName)
                    
                    await MainActor.run {
                        habit.emoji = suggestedEmoji
                        habit.isLoadingEmoji = false
                    }
                } catch let claudeError as ClaudeAPIError {
                    await MainActor.run {
                        habit.isLoadingEmoji = false
                        habit.emoji = "❓" // Set fallback emoji
                        
                        // Show error alert to user
                        errorMessage = claudeError.localizedDescription
                        showEmojiError = true
                        
                        print("Claude API error: \(claudeError.localizedDescription)")
                    }
                } catch {
                    await MainActor.run {
                        habit.isLoadingEmoji = false
                        habit.emoji = "❓" // Set fallback emoji
                        
                        // Show generic error
                        errorMessage = "Failed to generate emoji. Using default emoji instead."
                        showEmojiError = true
                        
                        print("Unexpected error: \(error.localizedDescription)")
                    }
                }
            }
            
            // Reset name and dismiss keyboard
            name = ""
            isTextFieldFocused = false
        }
    }
}

#Preview {
    HabitForm()
        .withSampleData()
}
