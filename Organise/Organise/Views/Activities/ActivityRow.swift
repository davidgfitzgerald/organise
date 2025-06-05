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
    ActivityDayList(date: .constant(Date()))
        .withSampleData()
}
