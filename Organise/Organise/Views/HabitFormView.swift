//
//  HabitFormView.swift
//  Organise
//
//  Created by David Fitzgerald on 04/10/2025.
//

import SwiftUI
import SwiftData

struct HabitFormView: View {
    let habit: Habit?
    let onSave: (Habit) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var icon: String = "questionmark"
    @State private var color: String = ".gray"
    
    private let availableIcons = [
        "drop.fill", "figure.run", "book.fill", "leaf.fill", "pencil",
        "bed.double.fill", "fish.fill", "takeoutbag.and.cup.and.straw.fill",
        "heart.fill", "brain.head.profile", "dumbbell.fill", "bicycle",
        "car.fill", "airplane", "house.fill", "briefcase.fill"
    ]
    
    private let availableColors = [
        ".blue", ".green", ".purple", ".mint", ".orange", ".indigo",
        ".red", ".pink", ".yellow", ".gray", ".brown", ".cyan"
    ]
    
    init(habit: Habit?, onSave: @escaping (Habit) -> Void) {
        self.habit = habit
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Habit Details") {
                    TextField("Habit name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section("Icon") {
                    IconPicker(selection: $icon, color: color)
                }
                
                Section("Color") {
                    ColorPicker(selection: $color)
                }
            }
            .navigationTitle(habit == nil ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            if let habit = habit {
                name = habit.name
                icon = habit.icon
                color = habit.color
            }
        }
    }
    
    private func saveHabit() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        if let existingHabit = habit {
            // Update existing habit
            existingHabit.name = trimmedName
            existingHabit.icon = icon
            existingHabit.color = color
            onSave(existingHabit)
        } else {
            // Create new habit
            let newHabit = Habit(name: trimmedName, icon: icon, color: color)
            onSave(newHabit)
        }
        
        dismiss()
    }
}
