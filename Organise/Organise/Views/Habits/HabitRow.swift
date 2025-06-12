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
    @State private var isSpinning = false

    
    var body: some View {
        HStack {
            if habit.isLoadingEmoji {
                Text("🔄")
                    .font(.title2)
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(isSpinning ? -360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isSpinning)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.secondary.opacity(0.1))
                    )
                    .onAppear { isSpinning = true }
                    .onDisappear { isSpinning = false }
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
            
            Text(habit.name)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .sheet(isPresented: $showingEmojiPicker) {
            EmojiPicker(selectedEmoji: $habit.emoji)
        }
    }
}

#Preview {
    let habit = Habit(name: "Exercise")
    return HabitRow(habit: habit)
        .withSampleData()
}
