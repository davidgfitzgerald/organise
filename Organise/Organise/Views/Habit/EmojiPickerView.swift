//
//  EmojiPickerView.swift
//  Organise
//
//  Created by David Fitzgerald on 20/05/2025.
//

import SwiftUI


struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss
    
    let emojis = ["🏃", "🧘", "💪", "🏋️", "🚴", "🚶", "🧠", "📚", "💧", "🍎", "🥦", "💊", "😴", "🌞", "🧹", "✍️", "💰", "🎯"]
    
    var body: some View {
        VStack {
            Text("Select an Emoji")
                .font(.headline)
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                ForEach(emojis, id: \.self) { emoji in
                    Button(action: {
                        selectedEmoji = emoji
                        dismiss()
                    }) {
                        Text(emoji)
                            .font(.system(size: 24))
                            .padding(8)
                            .background(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .frame(width: 300, height: 250)
    }
}

#Preview {
    @Previewable @State var selectedEmoji: String = "💧"
    EmojiPickerView(selectedEmoji: $selectedEmoji)
}
