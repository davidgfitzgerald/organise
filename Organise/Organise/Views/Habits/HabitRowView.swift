//
//  HabitRowView.swift
//  Organise
//
//  Created by David Fitzgerald on 27/07/2025.
//

import SwiftUI

// MARK: - Enhanced Habit Row View
struct HabitRowView: View {
    @Environment(\.modelContext) private var context
    let habit: Habit
    let isCompleted: Bool
    let onToggle: () -> Void
    @State private var isPressed = false
    
    @Namespace private var iconNamespace
    
    var body: some View {
        HStack(spacing: 16) {
            // Habit Icon with animated background
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(from: habit.colorString).opacity(isCompleted ? 0.3 : 0.15))
                    .frame(width: 48, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(from: habit.colorString).opacity(0.3), lineWidth: 1)
                    )
                
                Image(systemName: habit.icon)
                    .font(.title3)
                    .foregroundColor(Color(from: habit.colorString))
                    .scaleEffect(isCompleted ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isCompleted)
            }
            
            // Habit Name and Streak
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                HStack {
                    StreakIndicator(streak: habit.currentStreak, maxStreak: habit.maxStreak, color: Color(from: habit.colorString))
                    // PB Badge
                    if habit.currentStreak == habit.maxStreak && habit.maxStreak > 0 {
                        Text("PB")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.orange)
                            )
                            .scaleEffect(0.9)
                    }
                }
            }
            
            Spacer()
                        
            // Completion Toggle with enhanced animation
            Button(action: {
                withAnimation(.easeIn(duration: 0.3)) {
                    onToggle()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? Color(from: habit.colorString) : Color.clear)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(isCompleted ? Color(from: habit.colorString) : Color.gray.opacity(0.4), lineWidth: 2)
                        )
                    
                    PlusToCheckmarkShape(progress: isCompleted ? 1 : 0)
                        .stroke(isCompleted ? .white : .gray, lineWidth: 3)
                        .frame(width: 44, height: 44)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isCompleted)
                }
            }
            .buttonStyle(.plain)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isCompleted ? Color(from: habit.colorString).opacity(0.1) : Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(from: habit.colorString).opacity(isCompleted ? 0.5 : 0.1), lineWidth: 3)
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isPressed)
        
    }
}

#Preview {
    @Previewable @State var isCompleted = false

    let habit = Habit(name: "Drink Water", icon: "drop.fill", colorString: ".blue", maxStreak: 45, currentStreak: 12)
    let now = Date()
    
    HabitRowView(
        habit: habit,
        isCompleted: isCompleted
    ) {
        try? isCompleted.toggle()
    }.padding(16)
}
