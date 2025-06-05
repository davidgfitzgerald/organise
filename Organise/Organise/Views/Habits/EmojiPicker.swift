import SwiftUI

struct EmojiPicker: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 6)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(Emojis.categories.keys.sorted()), id: \.self) { category in
                    Section(header: Text(category)) {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(Emojis.categories[category] ?? [], id: \.self) { emoji in
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
                        .padding(.vertical, 8)
                    }
                }
            }
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
