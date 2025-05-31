//
//  Emoji.swift
//  Organise
//
//  Created by David Fitzgerald on 20/05/2025.
//

import SwiftUI

struct EmojiView: View {
    @State private var showingPicker = false
    @Binding var emoji: String

    var body: some View {
        Button(action: {
            showingPicker = true
        }) {
            Text(emoji)
                .font(.system(size: 30))
                .frame(width: 50, height: 50)
                .background(Color.red.opacity(0.1))
                .clipShape(Circle())
        }
        .buttonStyle(BorderlessButtonStyle())
        .popover(isPresented: $showingPicker) {
            EmojiPickerView(selectedEmoji: $emoji)
        }
    }
}

#Preview {
    @Previewable @State var emoji: String = "🏃"
    EmojiView(emoji: $emoji)
}
