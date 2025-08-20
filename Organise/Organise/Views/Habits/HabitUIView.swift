//
//  HabitUIView.swift
//  Organise
//
//  Created by David Fitzgerald on 17/07/2025.
//
import SwiftUI
import SwiftData

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


struct HabitUIView: View {
    @Environment(\.modelContext) private var context
    @Query var habits: [Habit]
    @State private var selectedDate: Date = .now
    @State private var showDatePicker = false
    @State private var isEditMode = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Enhanced Date Header
                DateHeaderView(selectedDate: $selectedDate, completionPercentage: calculateCompletionPercentage(on: selectedDate, context: context))
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .onTapGesture {
                        if Calendar.current.isDateInToday(selectedDate) {
                            withAnimation(.spring()) {
                                showDatePicker.toggle()
                            }
                        }
                    }

                Divider()
                    .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)

                // Habits List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        HabitRowNew()
                        ForEach(habits) { habit in
                            HabitRowView(
                                habit: habit,
                                isCompleted: habit.completedOn(selectedDate),
                                isEditMode: isEditMode,
                                onToggle: {
                                    try? habit.toggleCompletion(on: selectedDate)
                                },
                                onDelete: {
                                    // Delete all completions first, then delete the habit
                                    for completion in habit.completions {
                                        context.delete(completion)
                                    }
                                    context.delete(habit)
                                    try? context.save()
                                }
                            )
                        }
                        

                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 100)
                }

                Spacer()
            }
            .navigationTitle("Daily Habits")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditMode ? "Done" : "Edit") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isEditMode.toggle()
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    var shouldCreateDefaults = true
    HabitUIView()
        .modelContainer(DataContainer.create(shouldCreateDefaults: &shouldCreateDefaults))
}
