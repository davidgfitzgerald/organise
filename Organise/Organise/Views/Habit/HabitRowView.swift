import SwiftUI

struct HabitRowView: View {
    @Bindable var habit: Habit
    @State private var isEditingTitle = false
    @FocusState private var titleIsFocused: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            EmojiView(emoji: $habit.icon)
            
            // Title (editable)
            if isEditingTitle {
                TextField("Habit title", text: $habit.title)
                    .font(.headline)
                    .focused($titleIsFocused)
                    .onSubmit {
                        isEditingTitle = false
                    }
                    .onAppear {
                        titleIsFocused = true
                    }
            } else {
                Text(habit.title)
                    .font(.headline)
                    .onTapGesture {
                        isEditingTitle = true
                    }
            }
            
            Spacer()
            
            // Completion button
            Button(action: {
                habit.isCompleted.toggle()
            }) {
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(habit.isCompleted ? .green : .gray)
                    .contentShape(Rectangle())
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
//        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}



// Preview
struct HabitRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HabitRowView(habit: Habit(title: "Daily Meditation", icon: "🧘", isCompleted: true))
            HabitRowView(habit: Habit(title: "Read 30 Minutes", icon: "📚", isCompleted: false))
            HabitRowView(habit: Habit(title: "Drink Water", icon: "💧"))
        }
        .padding()
    }
}
