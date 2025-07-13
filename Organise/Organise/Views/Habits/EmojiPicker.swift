import SwiftUI

struct EmojiItem: Identifiable {
    let id: String
    let emoji: String
}

struct EmojiGrid: View {
    let category: String
    let emojis: [String]
    let selectedEmoji: String
    let onEmojiSelected: (String) -> Void
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 6)
    
    private var emojiItems: [EmojiItem] {
        emojis.map { emoji in
            EmojiItem(id: "\(category)-\(emoji)", emoji: emoji)
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(emojiItems) { item in
                Button {
                    onEmojiSelected(item.emoji)
                } label: {
                    Text(item.emoji)
                        .font(.system(size: 30))
                        .frame(width: 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedEmoji == item.emoji ? Color.blue.opacity(0.2) : Color.clear)
                        )
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct EmojiPicker: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 6)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(Emojis.categories.keys.sorted()), id: \.self) { category in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(category)
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.top, 16)
                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                if let emojis = Emojis.categories[category] {
                                    ForEach(emojis, id: \.self) { emoji in
                                        Button {
                                            selectedEmoji = emoji
                                            dismiss()
                                        } label: {
                                            Text(emoji)
                                                .font(.system(size: 30))
                                                .frame(width: 50, height: 50)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                                                )
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemGroupedBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Pick an Emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var emoji = "✅"
    return EmojiPicker(selectedEmoji: $emoji)
} 
