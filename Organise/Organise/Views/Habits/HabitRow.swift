//
//  HabitRow.swift
//  Organise
//
//  Created by David Fitzgerald on 05/06/2025.
//

import SwiftUI
import SwiftData

struct HabitRow: View {
    @Environment(\.modelContext) private var context
    @Bindable var habit: Habit
    @State private var showingEmojiPicker = false
    let date: Date
    
    private var completed: Bool {
        habit.completedOn(date)
    }
    
    var body: some View {
        HStack {
            if habit.isLoadingEmoji {
                ProgressView()
                    .scaleEffect(0.8)
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.secondary.opacity(0.1))
                    )
            } else {
                Button {
                    showingEmojiPicker = true
                } label: {
                    Text(habit.emoji)
                        .font(.title2)
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.secondary.opacity(0.1))
                        )
                }
                .buttonStyle(.plain)
            }
            
            HStack {
                Text(habit.name)
                    .foregroundColor(completed ? .secondary : .primary)
                Spacer()
            }
            .fullStrikethrough(completed)
        }
        .contentShape(Rectangle()) // Make the entire row tappable
        .onTapGesture {
            if habit.completedOn(date) {
                habit.decomplete(date)
                print("DECOMPLETED")
            } else {
                habit.complete(date)
                print("COMPLETED")
            }
        }
        .sheet(isPresented: $showingEmojiPicker) {
            EmojiPicker(selectedEmoji: $habit.emoji)
        }
    }
}

#Preview {
    let container = PreviewHelper.createSampleContainer()
    let context = ModelContext(container)
    
    // Get the first habit from the sample data
    let descriptor = FetchDescriptor<Habit>()
    let habits = try! context.fetch(descriptor)
    let habit = habits.first!
    
    return HabitRow(habit: habit, date: Date())
        .modelContainer(container)
}
