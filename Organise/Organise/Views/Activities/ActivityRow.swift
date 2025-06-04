import SwiftUI
import SwiftData


struct ActivityRow: View {
    @Environment(\.modelContext) private var context
    let activity: Activity
    
    var body: some View {
        HStack {
            HStack {
                Text(activity.habit.name)
                    .foregroundColor(activity.completedAt != nil ? .secondary : .primary)
                if let completedAt = activity.completedAt {
                    Text(completedAt.short)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .fullStrikethrough(activity.completedAt != nil)
            if activity.completedAt != nil {
                Button {
                    activity.completedAt = nil
                    try? context.save()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .padding(.leading, 12)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Button {
                    activity.completedAt = Date()
                    try? context.save()
                } label: {
                    Image(systemName: "circle")
                        .foregroundColor(.secondary)
                        .padding(.leading, 12)
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
