//
//  IconPreview.swift
//  Organise
//
//  Created by David Fitzgerald on 03/06/2025.
//

import SwiftUI

// Preview showing all options
struct IconsPreview: View {
    @Binding var lightMode: Bool
    var body: some View {
        VStack(spacing: 30) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 30) {
                VStack {
                    CheckmarkIcon()
                        .frame(width: 128, height: 128)
                    Text("Checkmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    TargetIcon()
                        .frame(width: 128, height: 128)
                    Text("Target")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    StreakIcon()
                        .frame(width: 128, height: 128)
                    Text("Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    ProgressIcon()
                        .frame(width: 128, height: 128)
                    Text("Progress")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

        }
        .padding()
        .preferredColorScheme(lightMode ? .light : .dark)
    }
}

#Preview {
    @Previewable @State var lightMode = true
    Text("Habit App Icon Options")
        .font(.title2)
        .fontWeight(.semibold)
    IconsPreview(lightMode: $lightMode)
    HStack {
        Spacer()
        Toggle("Light Mode", isOn: $lightMode)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
        Spacer()
    }

}
