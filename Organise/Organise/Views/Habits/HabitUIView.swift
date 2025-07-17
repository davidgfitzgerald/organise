//
//  HabitUIView.swift
//  Organise
//
//  Created by David Fitzgerald on 17/07/2025.
//

import SwiftUI

// MARK: - Models
struct HabitModel: Identifiable {
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
    @Published var habits: [HabitModel] = [
        HabitModel(name: "Drink Water", icon: "drop.fill", color: .blue, maxStreak: 45, currentStreak: 12),
        HabitModel(name: "Exercise", icon: "figure.run", color: .green, maxStreak: 28, currentStreak: 5),
        HabitModel(name: "Read", icon: "book.fill", color: .purple, maxStreak: 67, currentStreak: 23),
        HabitModel(name: "Meditate", icon: "leaf.fill", color: .mint, maxStreak: 31, currentStreak: 8),
        HabitModel(name: "Journal", icon: "pencil", color: .orange, maxStreak: 22, currentStreak: 0),
        HabitModel(name: "Sleep 8h", icon: "bed.double.fill", color: .indigo, maxStreak: 3, currentStreak: 3),
        HabitModel(name: "Fishing", icon: "fish.fill", color: .red, maxStreak: 3, currentStreak: 3),
        HabitModel(name: "Homemade Lunch", icon: "takeoutbag.and.cup.and.straw.fill", color: .green, maxStreak: 3, currentStreak: 3)
    ]
    
    @Published var completions: [HabitCompletion] = []
    
    init() {
        generateSampleCompletions()
    }
    
    private func generateSampleCompletions() {
        let calendar = Calendar.current
        let today = Date()
        
        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            
            for habit in habits {
                let shouldComplete = Int.random(in: 0...100) < 70
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
        
        updateCurrentStreak(for: habitId)
    }
    
    private func updateCurrentStreak(for habitId: UUID) {
        guard let habitIndex = habits.firstIndex(where: { $0.id == habitId }) else { return }
        
        let calendar = Calendar.current
        let today = Date()
        var currentStreak = 0
        
        for dayOffset in 0..<365 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { break }
            
            if isHabitCompleted(habitId: habitId, date: date) {
                currentStreak += 1
            } else {
                break
            }
        }
        
        habits[habitIndex].currentStreak = currentStreak
        
        if currentStreak > habits[habitIndex].maxStreak {
            habits[habitIndex].maxStreak = currentStreak
        }
    }
    
    var completionPercentage: Double {
        let totalHabits = habits.count
        guard totalHabits > 0 else { return 0 }
        let completedHabits = habits.filter { isHabitCompleted(habitId: $0.id, date: Date()) }.count
        return Double(completedHabits) / Double(totalHabits)
    }
}

// MARK: - Custom Progress Ring
struct ProgressRing: View {
    let progress: Double
    let color: Color
    let lineWidth: CGFloat
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: progress)
        }
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
            // Draw full plus lines, fade out toward check
            let pVStart = interp(plusVStart, checkStart)
            let pVEnd   = interp(plusVEnd,   checkMid)
            let pHStart = interp(plusHStart, checkMid)
            let pHEnd   = interp(plusHEnd,   checkEnd)

            path.move(to: pVStart)
            path.addLine(to: pVEnd)

            path.move(to: pHStart)
            path.addLine(to: pHEnd)
        } else {
            // Morph into continuous checkmark
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




// MARK: - Enhanced Habit Row View
struct HabitRowView: View {
    let habit: HabitModel
    let isCompleted: Bool
    let onToggle: () -> Void
    @State private var isPressed = false
    
    @Namespace private var iconNamespace
    
    var body: some View {
        HStack(spacing: 16) {
            // Habit Icon with animated background
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(habit.color.opacity(isCompleted ? 0.3 : 0.15))
                    .frame(width: 48, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(habit.color.opacity(0.3), lineWidth: 1)
                    )
                
                Image(systemName: habit.icon)
                    .font(.title3)
                    .foregroundColor(habit.color)
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
                    StreakIndicator(streak: habit.currentStreak, maxStreak: habit.maxStreak, color: habit.color)
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
                        .fill(isCompleted ? habit.color : Color.clear)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(isCompleted ? habit.color : Color.gray.opacity(0.4), lineWidth: 2)
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
                .fill(isCompleted ? habit.color.opacity(0.1) : Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(habit.color.opacity(isCompleted ? 0.5 : 0.1), lineWidth: 3)
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isPressed)
        
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


// MARK: - Date Header View
struct DateHeaderView: View {
    @Binding var selectedDate: Date

    // Hack to get DatePicker to dismiss
    @State private var calendarId: Int = 0

    let completionPercentage: Double
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
    
    var body: some View {
        // Date Selection
        HStack(spacing: 16) {
            HStack {
                DatePicker(
                    "Select date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                    // Workaround to dismiss calendar
                    // upon date selection.
                    .id(calendarId)
                    .onChange(of: selectedDate) { oldValue, newValue in
                        let components = Calendar.current.dateComponents([.year, .month], from: oldValue, to: newValue)
                        guard components.year == 0 && components.month == 0 else {
                            return
                        }
                        calendarId += 1
                    }
                    .datePickerStyle(.compact)
                    .labelsHidden()

            }

            Text("Today")
                .font(.caption)
                .foregroundColor(.orange)
                .opacity(isToday ? 1 : 0)
            
            Spacer()
            
            // Overall Progress Ring
            ZStack {
                ProgressRing(progress: completionPercentage, color: .green, lineWidth: 4, size: 50)
                
                VStack(spacing: 0) {
                    Text("\(Int(completionPercentage * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("done")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(
            Color(.systemGray5)
                .opacity(0.7)
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
        )
    }
}

// MARK: - Main UI View
struct HabitUIView: View {
    @StateObject private var habitData = HabitData()
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Enhanced Date Header
                DateHeaderView(selectedDate: $selectedDate, completionPercentage: habitData.completionPercentage)
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
                        ForEach(habitData.habits) { habit in
                            HabitRowView(
                                habit: habit,
                                isCompleted: habitData.isHabitCompleted(habitId: habit.id, date: selectedDate)
                            ) {
                                habitData.toggleHabitCompletion(habitId: habit.id, date: selectedDate)
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
