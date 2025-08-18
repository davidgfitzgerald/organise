//
//  HabitRowView.swift
//  Organise
//
//  Created by David Fitzgerald on 27/07/2025.
//

import SwiftUI


struct HabitRowNew: View {
    @Environment(\.modelContext) private var context
    @State private var name: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showIconError = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Habit Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.secondary.opacity(0.15))
                    .frame(width: 48, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.secondary.opacity(0.3), lineWidth: 1)
                    )
                
                Image(systemName: "questionmark.circle")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            // Add Habit
            VStack(alignment: .leading, spacing: 4) {
                TextField("Add Habit", text: $name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .onSubmit {
                        AppLogger.info("Creating habit with name: \(name)")
                        let habit = Habit(name: name, icon: "checkmark.square.fill", colorString: "purple", maxStreak: 0, currentStreak: 0)
                        
                        // Validate habit can't be empty etc.
                        context.insert(habit)
                        // try? context.save()
                        
                        // Capture value of habitName before it is reset
                        let habitName = name

                        Task {
                            do {
                                habit.isLoadingIcon = true
                                print("Creating habit: '\(habitName)'")

                                // Use the retry mechanism for better reliability
                                let suggestedIcon = try await ClaudeAPIService.suggestIconWithRetry(for: habitName)

                                await MainActor.run {
                                    habit.icon = String(suggestedIcon)
                                    habit.isLoadingIcon = false
                                }
                            } catch let claudeError as ClaudeAPIError {
                                await MainActor.run {
                                    habit.isLoadingIcon = false
                                    habit.icon = "questionmark.app.fill" // Set fallback icon

                                    // Show error alert to user
                                    errorMessage = claudeError.localizedDescription
                                    showIconError = true

                                    print("Claude API error: \(claudeError.localizedDescription)")
                                }
                            } catch {
                                await MainActor.run {
                                    habit.isLoadingIcon = false
                                    habit.icon = "questionmark.app.fill" // Set fallback icon

                                    // Show generic error
                                    errorMessage = "Failed to generate icon. Using default icon instead."
                                    showIconError = true

                                    print("Unexpected error: \(error.localizedDescription)")
                                }
                            }
                        }
                        
                        name = ""
                    }
            }
            
            Spacer()

        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.secondary.opacity(0.1), lineWidth: 3)
                )
        )
        
    }
}

#Preview {
    HabitRowNew().padding(16)
}
