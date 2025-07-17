//
//  HabitUIView.swift
//  Organise
//
//  Created by David Fitzgerald on 17/07/2025.
//

import SwiftUI

// MARK: - Models
struct HabitExperiment: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    var maxStreak: Int
    var currentStreak: Int
}

struct HabitCompletion: Identifiable {
    let id = UUID()
    let habitId: UUID
    let date: Date
    var isCompleted: Bool
}

// MARK: - Sample Data
class HabitData: ObservableObject {
    @Published var habits: [HabitExperiment] = [
        HabitExperiment(name: "Drink Water", icon: "drop.fill", color: .blue, maxStreak: 45, currentStreak: 12),
        HabitExperiment(name: "Exercise", icon: "figure.run", color: .green, maxStreak: 28, currentStreak: 5),
        HabitExperiment(name: "Read", icon: "book.fill", color: .purple, maxStreak: 67, currentStreak: 23),
        HabitExperiment(name: "Meditate", icon: "leaf.fill", color: .mint, maxStreak: 31, currentStreak: 8),
        HabitExperiment(name: "Journal", icon: "pencil", color: .orange, maxStreak: 22, currentStreak: 0),
        HabitExperiment(name: "Sleep 8h", icon: "bed.double.fill", color: .indigo, maxStreak: 15, currentStreak: 3)
    ]
    
    @Published var completions: [HabitCompletion] = []
    
    init() {
        generateSampleCompletions()
    }
    
    private func generateSampleCompletions() {
        let calendar = Calendar.current
        let today = Date()
        
        // Generate sample completions for the last 30 days
        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            
            for habit in habits {
                // Random completion pattern
                let shouldComplete = Int.random(in: 0...100) < 70 // 70% chance
                let completion = HabitCompletion(
                    habitId: habit.id,
                    date: calendar.startOfDay(for: date),
                    isCompleted: shouldComplete
                )
                completions.append(completion)
            }
        }
    }
    
    func getCompletions(for date: Date) -> [HabitCompletion] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return completions.filter { calendar.isDate($0.date, inSameDayAs: startOfDay) }
    }
    
    func isHabitCompleted(habitId: UUID, date: Date) -> Bool {
        return getCompletions(for: date).first { $0.habitId == habitId }?.isCompleted ?? false
    }
    
    func toggleHabitCompletion(habitId: UUID, date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        if let index = completions.firstIndex(where: { $0.habitId == habitId && calendar.isDate($0.date, inSameDayAs: startOfDay) }) {
            completions[index].isCompleted.toggle()
        } else {
            let newCompletion = HabitCompletion(habitId: habitId, date: startOfDay, isCompleted: true)
            completions.append(newCompletion)
        }
        
        // Update current streak (simplified calculation)
        updateCurrentStreak(for: habitId)
    }
    
    private func updateCurrentStreak(for habitId: UUID) {
        guard let habitIndex = habits.firstIndex(where: { $0.id == habitId }) else { return }
        
        let calendar = Calendar.current
        let today = Date()
        var currentStreak = 0
        
        // Count consecutive days from today backwards
        for dayOffset in 0..<365 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { break }
            
            if isHabitCompleted(habitId: habitId, date: date) {
                currentStreak += 1
            } else {
                break
            }
        }
        
        habits[habitIndex].currentStreak = currentStreak
        
        // Update max streak if current streak is higher
        if currentStreak > habits[habitIndex].maxStreak {
            habits[habitIndex].maxStreak = currentStreak
        }
    }
}

// MARK: - Views
struct HabitRowView: View {
    let habit: HabitExperiment
    let isCompleted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Habit Icon and Name
            HStack(spacing: 12) {
                Image(systemName: habit.icon)
                    .font(.title2)
                    .foregroundColor(habit.color)
                    .frame(width: 24, height: 24)
                
                Text(habit.name)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Streak Information
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 16) {
                    // Current Streak
                    VStack(alignment: .center, spacing: 2) {
                        Text("Current")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(habit.currentStreak)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    // Max Streak (PB)
                    VStack(alignment: .center, spacing: 2) {
                        Text("PB")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(habit.maxStreak)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                }
            }
            
            // Completion Toggle
            Button(action: onToggle) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .opacity(isCompleted ? 0.8 : 1.0)
        )
    }
}

struct HabitUIView: View {
    @StateObject private var habitData = HabitData()
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Date Picker
                VStack(alignment: .leading, spacing: 12) {
                    
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .padding(.horizontal)
                }
                .padding(.vertical, 16)
                .background(Color(.systemGray6))
                
                // Habits List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(habitData.habits) { habit in
                            HabitRowView(
                                habit: habit,
                                isCompleted: habitData.isHabitCompleted(habitId: habit.id, date: selectedDate)
                            ) {
                                habitData.toggleHabitCompletion(habitId: habit.id, date: selectedDate)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .navigationTitle("Daily Habits")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: "Experiments")
            .withSampleData()
    }
}


#Preview {
    ContentView(selectedTab: "Experiments")
        .withSampleData()
}
