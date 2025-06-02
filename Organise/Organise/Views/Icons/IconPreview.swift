//
//  IconPreview.swift
//  Organise
//
//  Created by David Fitzgerald on 03/06/2025.
//

import SwiftUI

// Preview showing all options
struct HabitAppIconPreviews: View {
    @State var lightMode = true
    var body: some View {
        VStack(spacing: 30) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 30) {
                VStack {
                    CheckmarkIcon()
                    Text("Checkmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    TargetIcon()
                    Text("Target")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    StreakIcon()
                    Text("Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    ProgressIcon()
                    Text("Progress")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            HStack {
                Spacer()
                Toggle("Light Mode", isOn: $lightMode)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
        .padding()
        .preferredColorScheme(lightMode ? .light : .dark)
    }
}

#Preview {
    Text("Habit App Icon Options")
        .font(.title2)
        .fontWeight(.semibold)
    HabitAppIconPreviews()

}
