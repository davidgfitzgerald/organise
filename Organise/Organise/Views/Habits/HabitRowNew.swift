//
//  HabitRowView.swift
//  Organise
//
//  Created by David Fitzgerald on 27/07/2025.
//

import SwiftUI


struct HabitRowNew: View {
    @Environment(\.modelContext) private var context
    @State private var habitName: String = ""
    
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
                TextField("Add Habit", text: $habitName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .onSubmit {
                        AppLogger.info("Creating habit with name: \(habitName)")
                        let habit = Habit(name: habitName, icon: "checkmark.square.fill", colorString: "purple", maxStreak: 0, currentStreak: 0)
                        habitName = ""
                        // Validate habit can't be empty etc.
                        context.insert(habit)
                        try? context.save()
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
