import SwiftUI
import SwiftData


struct ActivityRow2: View {
    @Environment(\.modelContext) private var context
    let item: Activity
    
    var body: some View {
        HStack {
            Text(item.habit.name)
                .foregroundColor(item.completedAt != nil ? .secondary : .primary)
            if let completedAt = item.completedAt {
                Text(completedAt.short)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if item.completedAt != nil {
                Button {
                    item.completedAt = nil
                    try? context.save()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Button {
                    item.completedAt = Date()
                    try? context.save()
                } label: {
                    Image(systemName: "circle")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Activity.self, Habit.self, configurations: config)
    
    let sampleHabits: [Habit] = [
        Habit(name: "Exercise"),
        Habit(name: "Read"),
        Habit(name: "Meditate"),
    ]
    sampleHabits.forEach { container.mainContext.insert($0) }
    try? container.mainContext.save()
    
    let sampleActivities = [
        Activity(habit: sampleHabits[0], completedAt: Date()),
        Activity(habit: sampleHabits[1]),
        Activity(habit: sampleHabits[2], completedAt: Date().addingTimeInterval(-3600))
    ]
    sampleActivities.forEach { container.mainContext.insert($0) }

    try? container.mainContext.save()
    
    return ActivityList()
        .modelContainer(container)
} 
