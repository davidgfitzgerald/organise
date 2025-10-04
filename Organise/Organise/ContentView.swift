//
//  ContentView.swift
//  Organise
//
//  Created by David Fitzgerald on 04/10/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var habits: [Habit]
    @Query var completions: [HabitCompletion]
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingAddHabit = false
    @State private var editingHabit: Habit?
    @State private var showingDeleteAlert = false
    @State private var habitToDelete: Habit?
    @State private var selectedDate = Date()
    
    private var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
    
    private func isHabitCompletedOnDate(_ habit: Habit, date: Date) -> Bool {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return completions.contains { completion in
            completion.habit?.id == habit.id &&
            completion.completedAt >= startOfDay &&
            completion.completedAt < endOfDay
        }
    }
    
    private func toggleHabitCompletion(_ habit: Habit, on date: Date) {
        let isCompleted = isHabitCompletedOnDate(habit, date: date)
        
        if isCompleted {
            // Remove completion
            if let completion = completions.first(where: { completion in
                completion.habit?.id == habit.id &&
                Calendar.current.isDate(completion.completedAt, inSameDayAs: date)
            }) {
                modelContext.delete(completion)
            }
        } else {
            // Add completion
            let completion = HabitCompletion(completedAt: date, habit: habit)
            modelContext.insert(completion)
        }
        
        try? modelContext.save()
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Date Picker Section
                VStack(spacing: 12) {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal)
                    
                    Text(selectedDateString)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 12)
                .background(Color(.systemGroupedBackground))
                
                // Habits List
                List(habits, id: \.id) { habit in
                    HStack(spacing: 12) {
                        // Completion checkbox
                        Button(action: {
                            toggleHabitCompletion(habit, on: selectedDate)
                        }) {
                            Image(systemName: isHabitCompletedOnDate(habit, date: selectedDate) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isHabitCompletedOnDate(habit, date: selectedDate) ? .green : .gray)
                                .font(.title2)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Habit icon
                        Image(systemName: habit.icon)
                            .foregroundColor(Color(from: habit.color))
                            .font(.title2)
                            .frame(width: 30)
                        
                        // Habit name
                        Text(habit.name)
                            .font(.body)
                            .strikethrough(isHabitCompletedOnDate(habit, date: selectedDate))
                            .foregroundColor(isHabitCompletedOnDate(habit, date: selectedDate) ? .secondary : .primary)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Delete", role: .destructive) {
                            habitToDelete = habit
                            showingDeleteAlert = true
                        }
                        
                        Button("Edit") {
                            editingHabit = habit
                        }
                    }
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddHabit = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                HabitFormView(habit: nil) { habit in
                    modelContext.insert(habit)
                    try? modelContext.save()
                }
            }
            .sheet(item: $editingHabit) { habit in
                HabitFormView(habit: habit) { updatedHabit in
                    try? modelContext.save()
                }
            }
            .alert("Delete Habit", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let habit = habitToDelete {
                        modelContext.delete(habit)
                        try? modelContext.save()
                    }
                }
            } message: {
                Text("Are you sure you want to delete this habit? This action cannot be undone.")
            }
        }
    }
}

struct IconPicker: View {
    @Binding var selection: String
    let color: String
    
    private let availableIcons = [
        "drop.fill", "figure.run", "book.fill", "leaf.fill", "pencil",
        "bed.double.fill", "fish.fill", "takeoutbag.and.cup.and.straw.fill",
        "heart.fill", "brain.head.profile", "dumbbell.fill", "bicycle",
        "car.fill", "airplane", "house.fill", "briefcase.fill"
    ]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
            ForEach(availableIcons, id: \.self) { iconName in
                iconButton(for: iconName)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func iconButton(for iconName: String) -> some View {
        Image(systemName: iconName)
            .font(.title2)
            .foregroundColor(Color(from: color))
            .frame(width: 40, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selection == iconName ? Color.blue.opacity(0.2) : Color.clear)
            )
            .contentShape(Rectangle()) // Ensures entire frame is tappable
            .onTapGesture {
                selection = iconName
            }
    }
}

struct ColorPicker: View {
    @Binding var selection: String
    
    private let availableColors = [
        ".blue", ".green", ".purple", ".mint", ".orange", ".indigo",
        ".red", ".pink", ".yellow", ".gray", ".brown", ".cyan"
    ]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
            ForEach(availableColors, id: \.self) { colorName in
                colorButton(for: colorName)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func colorButton(for colorName: String) -> some View {
        Circle()
            .fill(Color(from: colorName))
            .frame(width: 30, height: 30)
            .overlay(
                Circle()
                    .stroke(selection == colorName ? Color.primary : Color.clear, lineWidth: 2)
            )
            .contentShape(Circle()) // Ensures entire circle is tappable
            .onTapGesture {
                selection = colorName
            }
    }
}

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

#Preview {
    var shouldCreateDefaults = true
    ContentView()
        .modelContainer(
            DataContainer.create(
                shouldCreateDefaults: &shouldCreateDefaults,
                configuration: ModelConfiguration(isStoredInMemoryOnly: true)
            )
        )
}
