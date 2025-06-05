import SwiftUI
import SwiftData
import Observation

struct ActivityRow: View {
    @Environment(\.modelContext) private var context
    @Bindable var activity: Activity
    @State private var showingEmojiPicker = false
    
    var body: some View {
        HStack {
            Button {
                showingEmojiPicker = true
            } label: {
                Text(activity.habit.emoji.isEmpty ? "📝" : activity.habit.emoji)
                    .font(.title2)
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.secondary.opacity(0.1))
                    )
            }
            .buttonStyle(.plain)

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
        .sheet(isPresented: $showingEmojiPicker) {
            EmojiPicker(selectedEmoji: Binding(
                get: { activity.habit.emoji },
                set: { newValue in
                    activity.habit.emoji = newValue
                    try? context.save()
                }
            ))
        }
    }
}

#Preview {
    ActivityDayList(date: .constant(Date()))
        .withSampleData()
}
