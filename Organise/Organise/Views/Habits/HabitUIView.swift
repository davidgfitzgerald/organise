//
//  HabitUIView.swift
//  Organise
//
//  Created by David Fitzgerald on 17/07/2025.
//
import SwiftUI
import SwiftData

// MARK: - Sample Data
class HabitData: ObservableObject {
    @Published var habits: [Habit] = [
        Habit(name: "Drink Water", icon: "drop.fill", colorString: ".blue", maxStreak: 45, currentStreak: 12),
        Habit(name: "Exercise", icon: "figure.run", colorString: ".green", maxStreak: 28, currentStreak: 5),
        Habit(name: "Read", icon: "book.fill", colorString: ".purple", maxStreak: 67, currentStreak: 23),
        Habit(name: "Meditate", icon: "leaf.fill", colorString: ".mint", maxStreak: 31, currentStreak: 8),
        Habit(name: "Journal", icon: "pencil", colorString: ".orange", maxStreak: 22, currentStreak: 0),
        Habit(name: "Sleep 8h", icon: "bed.double.fill", colorString: ".indigo", maxStreak: 3, currentStreak: 3),
        Habit(name: "Fishing", icon: "fish.fill", colorString: ".red", maxStreak: 3, currentStreak: 3),
        Habit(name: "Homemade Lunch", icon: "takeoutbag.and.cup.and.straw.fill", colorString: ".green", maxStreak: 3, currentStreak: 3)
    ]
    
    @Published var completions: [HabitCompletion] = []
    
    var completionPercentage: Double {
        let totalHabits = habits.count
        guard totalHabits > 0 else { return 0 }
        let completedHabits = habits.filter { $0.completedOn(Date()) }.count
        return Double(completedHabits) / Double(totalHabits)
    }
}

// MARK: - Streak Indicator View
struct StreakIndicator: View {
    let streak: Int
    let maxStreak: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 2) {
                Image(systemName: "flame.fill")
                    .font(.caption2)
                    .foregroundColor(.orange)
                HStack(spacing: 0) {
                    Text("\(streak) ")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .contentTransition(.numericText())
                    Text("/ \(maxStreak)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .contentTransition(.numericText())
                    
                }
            }
            
            // Mini progress bar
            let progress = maxStreak > 0 ? Double(streak) / Double(maxStreak) : 0
            RoundedRectangle(cornerRadius: 2)
                .fill(color.opacity(0.3))
                .frame(height: 3)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: max(4, 40 * progress))
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
                .frame(width: 40)
        }
    }
}

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

// MARK: - Main UI View
struct HabitUIView: View {
    @Environment(\.modelContext) private var context
    @Query var habits: [Habit]
    @State private var selectedDate: Date = .now
    @State private var showDatePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Enhanced Date Header
                DateHeaderView(selectedDate: $selectedDate, completionPercentage: calculateCompletionPercentage(on: selectedDate))
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
                        ForEach(habits) { habit in
                            HabitRowView(
                                habit: habit,
                                isCompleted: habit.completedOn(selectedDate)
                            ) {
                                try? habit.toggleCompletion(on: selectedDate)
                            }
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
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: - Previews
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
