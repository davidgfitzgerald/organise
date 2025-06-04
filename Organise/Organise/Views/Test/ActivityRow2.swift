import SwiftUI
import SwiftData


struct ActivityRow2: View {
    @Environment(\.modelContext) private var context
    let item: Activity2
    
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
    let container = try! ModelContainer(for: Activity2.self, Habit2.self, configurations: config)
    
    let sampleHabits: [Habit2] = [
        Habit2(name: "Exercise"),
        Habit2(name: "Read"),
        Habit2(name: "Meditate"),
    ]
    sampleHabits.forEach { container.mainContext.insert($0) }
    try? container.mainContext.save()
    
    let sampleActivities = [
        Activity2(habit: sampleHabits[0], completedAt: Date()),
        Activity2(habit: sampleHabits[1]),
        Activity2(habit: sampleHabits[2], completedAt: Date().addingTimeInterval(-3600))
    ]
    sampleActivities.forEach { container.mainContext.insert($0) }

    try? container.mainContext.save()
    
    return ActivityList2()
        .modelContainer(container)
} 
