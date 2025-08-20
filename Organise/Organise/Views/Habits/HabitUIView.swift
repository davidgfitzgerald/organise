//
//  HabitUIView.swift
//  Organise
//
//  Created by David Fitzgerald on 17/07/2025.
//
import SwiftUI
import SwiftData


struct PlusToCheckmarkShape: Shape {
    var progress: CGFloat // 0 = plus, 1 = checkmark

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let size = min(rect.width, rect.height)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let half = size / 2

        // === Define Plus (+) Lines ===
        let plusVStart = CGPoint(x: center.x, y: center.y - half * 0.5)
        let plusVEnd   = CGPoint(x: center.x, y: center.y + half * 0.5)

        let plusHStart = CGPoint(x: center.x - half * 0.5, y: center.y)
        let plusHEnd   = CGPoint(x: center.x + half * 0.5, y: center.y)

        // === Define Checkmark Points (single path) ===
        let checkStart = CGPoint(x: center.x - half * 0.4, y: center.y)
        let checkMid   = CGPoint(x: center.x - half * 0.1, y: center.y + half * 0.3)
        let checkEnd   = CGPoint(x: center.x + half * 0.4, y: center.y - half * 0.3)

        // === Interpolation Helper ===
        func interp(_ from: CGPoint, _ to: CGPoint) -> CGPoint {
            CGPoint(
                x: from.x + (to.x - from.x) * progress,
                y: from.y + (to.y - from.y) * progress
            )
        }

        if progress < 0.5 {
            // Draw plus symbol lines, fade out toward check
            let pVStart = interp(plusVStart, checkStart)
            let pVEnd   = interp(plusVEnd,   checkMid)
            let pHStart = interp(plusHStart, checkMid)
            let pHEnd   = interp(plusHEnd,   checkEnd)

            path.move(to: pVStart)
            path.addLine(to: pVEnd)

            path.move(to: pHStart)
            path.addLine(to: pHEnd)
        } else {
            // Morph from plus symbol into checkmark
            let p1 = interp(plusVStart, checkStart)
            let p2 = interp(plusVEnd,   checkMid)
            let p3 = interp(plusHEnd,   checkEnd)

            path.move(to: p1)
            path.addLine(to: p2)
            path.addLine(to: p3)
        }

        return path
    }
}

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
