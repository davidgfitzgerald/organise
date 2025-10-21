import SwiftUI
import SwiftData

// MARK: - Models
@Model
final class Task {
    var id: UUID
    var title: String
    var date: Date?
    var isCompleted: Bool
    var notes: String
    
    init(title: String, date: Date? = nil, isCompleted: Bool = false, notes: String = "") {
        self.id = UUID()
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
        self.notes = notes
    }
}

// MARK: - Main App
@main
struct TaskCalendarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Task.self)
    }
}

// MARK: - Haptic Manager
class HapticManager {
    static let shared = HapticManager()
    
    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)
    private let heavy = UIImpactFeedbackGenerator(style: .heavy)
    private let selection = UISelectionFeedbackGenerator()
    private let notification = UINotificationFeedbackGenerator()
    
    func prepare() {
        light.prepare()
        medium.prepare()
        selection.prepare()
    }
    
    func dragStarted() {
        medium.impactOccurred()
    }
    
    func dragEntered() {
        light.impactOccurred()
    }
    
    func dragExited() {
        light.impactOccurred(intensity: 0.5)
    }
    
    func dropped() {
        notification.notificationOccurred(.success)
    }
    
    func taskCompleted() {
        notification.notificationOccurred(.success)
    }
    
    func taskDeleted() {
        notification.notificationOccurred(.warning)
    }
    
    func pageChanged() {
        selection.selectionChanged()
    }
}

// MARK: - Content View
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [Task]
    @State private var selectedWeekStart = Date().startOfWeek()
    @State private var showingAddTask = false
    @State private var newTaskTitle = ""
    @State private var showingMonthPicker = false
    @State private var expandedTaskId: UUID?
    
    var unscheduledTasks: [Task] {
        tasks.filter { $0.date == nil }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Mini Month Overview
                MiniMonthView(
                    selectedWeekStart: $selectedWeekStart,
                    tasks: tasks,
                    showingMonthPicker: $showingMonthPicker
                )
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                
                // Unscheduled Tasks Drawer
                UnscheduledTasksDrawer(tasks: unscheduledTasks)
                
                // Week View
                WeekView(
                    weekStart: selectedWeekStart,
                    tasks: tasks,
                    expandedTaskId: $expandedTaskId,
                    onDrop: scheduleTask,
                    onWeekChange: { newWeekStart in
                        selectedWeekStart = newWeekStart
                        HapticManager.shared.pageChanged()
                    }
                )
            }
            .navigationTitle(selectedWeekStart.formatted(.dateTime.month().year()))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Today") {
                        withAnimation {
                            selectedWeekStart = Date().startOfWeek()
                        }
                        HapticManager.shared.pageChanged()
                    }
                    .font(.subheadline)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingMonthPicker) {
                MonthPickerSheet(selectedWeekStart: $selectedWeekStart)
            }
            .alert("New Task", isPresented: $showingAddTask) {
                TextField("Task name", text: $newTaskTitle)
                Button("Cancel", role: .cancel) {
                    newTaskTitle = ""
                }
                Button("Add") {
                    addTask()
                }
            }
        }
    }
    
    private func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        let task = Task(title: newTaskTitle)
        modelContext.insert(task)
        newTaskTitle = ""
        HapticManager.shared.taskCompleted()
    }
    
    private func scheduleTask(_ taskId: UUID, to date: Date) {
        if let task = tasks.first(where: { $0.id == taskId }) {
            task.date = Calendar.current.startOfDay(for: date)
            try? modelContext.save()
            HapticManager.shared.dropped()
        }
    }
}

// MARK: - Mini Month View
struct MiniMonthView: View {
    @Binding var selectedWeekStart: Date
    let tasks: [Task]
    @Binding var showingMonthPicker: Bool
    
    private let calendar = Calendar.current
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    
    var monthDates: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedWeekStart) else {
            return []
        }
        
        let startOfMonth = monthInterval.start
        let endOfMonth = monthInterval.end
        
        var dates: [Date] = []
        var currentDate = startOfMonth
        
        while currentDate < endOfMonth {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    func hasTasksOnDate(_ date: Date) -> Bool {
        tasks.contains { task in
            guard let taskDate = task.date else { return false }
            return calendar.isDate(taskDate, inSameDayAs: date)
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Month header
            Button {
                showingMonthPicker = true
                HapticManager.shared.prepare()
            } label: {
                HStack(spacing: 4) {
                    Text(selectedWeekStart.formatted(.dateTime.month(.wide)))
                        .font(.subheadline.bold())
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .foregroundStyle(.primary)
            }
            
            // Mini calendar
            HStack(spacing: 4) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 10, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.secondary)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                ForEach(monthDates, id: \.self) { date in
                    let isInSelectedWeek = calendar.isDate(date, equalTo: selectedWeekStart, toGranularity: .weekOfYear)
                    
                    Button {
                        withAnimation {
                            selectedWeekStart = date.startOfWeek()
                        }
                        HapticManager.shared.pageChanged()
                    } label: {
                        ZStack(alignment: .bottom) {
                            Circle()
                                .fill(isInSelectedWeek ? Color.blue : Color.clear)
                            
                            Text("\(calendar.component(.day, from: date))")
                                .font(.system(size: 10))
                                .foregroundStyle(isInSelectedWeek ? .white : .primary)
                            
                            if hasTasksOnDate(date) {
                                Circle()
                                    .fill(isInSelectedWeek ? .white : .blue)
                                    .frame(width: 3, height: 3)
                                    .offset(y: 8)
                            }
                        }
                        .frame(height: 24)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

// MARK: - Month Picker Sheet
struct MonthPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedWeekStart: Date
    @State private var selectedMonth = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Select Month",
                    selection: $selectedMonth,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Jump to Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Select") {
                        selectedWeekStart = selectedMonth.startOfWeek()
                        HapticManager.shared.pageChanged()
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Unscheduled Tasks Drawer
struct UnscheduledTasksDrawer: View {
    let tasks: [Task]
    @State private var isExpanded = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
                HapticManager.shared.prepare()
            } label: {
                HStack {
                    Image(systemName: "tray")
                        .font(.subheadline)
                    Text("Inbox")
                        .font(.subheadline.bold())
                    Spacer()
                    Text("\(tasks.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .foregroundStyle(.primary)
            .background(Color(.systemGray6))
            
            // Tasks
            if isExpanded {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(tasks) { task in
                            InboxTaskCard(task: task)
                                .onDrag {
                                    HapticManager.shared.dragStarted()
                                    return NSItemProvider(object: task.id.uuidString as NSString)
                                }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .frame(height: 100)
                .background(Color(.systemGray6))
            }
        }
    }
}

// MARK: - Inbox Task Card
struct InboxTaskCard: View {
    let task: Task
    @Environment(\.modelContext) private var modelContext
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(task.title)
                .font(.subheadline.bold())
                .lineLimit(2)
            
            if !task.notes.isEmpty {
                Text(task.notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            HStack {
                Button {
                    showingDetails = true
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.caption)
                }
                
                Spacer()
                
                Button {
                    modelContext.delete(task)
                    HapticManager.shared.taskDeleted()
                } label: {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
        .padding(12)
        .frame(width: 160, height: 80)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        .sheet(isPresented: $showingDetails) {
            TaskDetailSheet(task: task)
        }
    }
}

// MARK: - Week View
struct WeekView: View {
    let weekStart: Date
    let tasks: [Task]
    @Binding var expandedTaskId: UUID?
    let onDrop: (UUID, Date) -> Void
    let onWeekChange: (Date) -> Void
    
    private let calendar = Calendar.current
    @State private var dragOffset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
    
    var weekDates: [Date] {
        (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: weekStart)
        }
    }
    
    var body: some View {
        TabView(selection: Binding(
            get: { weekStart },
            set: { newValue in
                onWeekChange(newValue)
            }
        )) {
            ForEach(generateWeeks(), id: \.self) { week in
                WeekPageView(
                    weekDates: generateDatesForWeek(week),
                    tasks: tasks,
                    expandedTaskId: $expandedTaskId,
                    onDrop: onDrop
                )
                .tag(week)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private func generateWeeks() -> [Date] {
        var weeks: [Date] = []
        for i in -2...2 {
            if let week = calendar.date(byAdding: .weekOfYear, value: i, to: weekStart) {
                weeks.append(week)
            }
        }
        return weeks
    }
    
    private func generateDatesForWeek(_ weekStart: Date) -> [Date] {
        (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: weekStart)
        }
    }
}

// MARK: - Week Page View
struct WeekPageView: View {
    let weekDates: [Date]
    let tasks: [Task]
    @Binding var expandedTaskId: UUID?
    let onDrop: (UUID, Date) -> Void
    
    private let calendar = Calendar.current
    
    func tasksForDate(_ date: Date) -> [Task] {
        tasks.filter { task in
            guard let taskDate = task.date else { return false }
            return calendar.isDate(taskDate, inSameDayAs: date)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                ForEach(weekDates, id: \.self) { date in
                    DayRowView(
                        date: date,
                        tasks: tasksForDate(date),
                        expandedTaskId: $expandedTaskId,
                        onDrop: { taskId in
                            onDrop(taskId, date)
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Day Row View
struct DayRowView: View {
    let date: Date
    let tasks: [Task]
    @Binding var expandedTaskId: UUID?
    let onDrop: (UUID) -> Void
    
    @State private var isTargeted = false
    @Environment(\.modelContext) private var modelContext
    
    private let calendar = Calendar.current
    
    var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Date indicator
                VStack(spacing: 2) {
                    Text(date.formatted(.dateTime.weekday(.abbreviated)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("\(calendar.component(.day, from: date))")
                        .font(.title2.bold())
                        .foregroundStyle(isToday ? .white : .primary)
                }
                .frame(width: 50)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isToday ? Color.blue : Color.clear)
                )
                
                // Tasks area
                VStack(alignment: .leading, spacing: 8) {
                    if tasks.isEmpty {
                        Text("No tasks")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 20)
                    } else {
                        ForEach(tasks) { task in
                            TaskRowCard(
                                task: task,
                                isExpanded: expandedTaskId == task.id,
                                onTap: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        expandedTaskId = expandedTaskId == task.id ? nil : task.id
                                    }
                                    HapticManager.shared.prepare()
                                },
                                onUnschedule: {
                                    task.date = nil
                                    try? modelContext.save()
                                    HapticManager.shared.taskDeleted()
                                }
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .contentShape(Rectangle())
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(isTargeted ? Color.blue : Color.clear, lineWidth: 3)
            )
            .dropDestination(for: String.self) { items, location in
                if let uuidString = items.first,
                   let uuid = UUID(uuidString: uuidString) {
                    onDrop(uuid)
                    return true
                }
                return false
            } isTargeted: { targeted in
                if targeted != isTargeted {
                    if targeted {
                        HapticManager.shared.dragEntered()
                    } else {
                        HapticManager.shared.dragExited()
                    }
                }
                isTargeted = targeted
            }
            
            Divider()
        }
    }
}

// MARK: - Task Row Card
struct TaskRowCard: View {
    let task: Task
    let isExpanded: Bool
    let onTap: () -> Void
    let onUnschedule: () -> Void
    
    @Environment(\.modelContext) private var modelContext
    @State private var showingEdit = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button {
                    task.isCompleted.toggle()
                    try? modelContext.save()
                    HapticManager.shared.taskCompleted()
                } label: {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(task.isCompleted ? .green : .gray)
                }
                
                Text(task.title)
                    .font(.body)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)
                
                Spacer()
                
                Button {
                    onTap()
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Progressive disclosure - expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    if !task.notes.isEmpty {
                        Text(task.notes)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack(spacing: 12) {
                        Button {
                            showingEdit = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            onUnschedule()
                        } label: {
                            Label("Unschedule", systemImage: "arrow.uturn.backward")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button(role: .destructive) {
                            modelContext.delete(task)
                            HapticManager.shared.taskDeleted()
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(.top, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .sheet(isPresented: $showingEdit) {
            TaskDetailSheet(task: task)
        }
    }
}

// MARK: - Task Detail Sheet
struct TaskDetailSheet: View {
    let task: Task
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var title: String
    @State private var notes: String
    
    init(task: Task) {
        self.task = task
        _title = State(initialValue: task.title)
        _notes = State(initialValue: task.notes)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    TextField("Title", text: $title)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        task.title = title
                        task.notes = notes
                        try? modelContext.save()
                        HapticManager.shared.taskCompleted()
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Date Extensions
extension Date {
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Task.self, inMemory: true)
//}

#Preview {
    InfiniteCalendarView()
}
