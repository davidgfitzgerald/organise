//
//  CheckmarkIcon.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI

struct CheckmarkIcon: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background circle that fills the entire frame
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Checkmark symbol that scales with the container
                Image(systemName: "checkmark")
                    .font(.system(size: geometry.size.width * 0.4, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    VStack {
        CheckmarkIcon()
            .frame(width: 120, height: 120)
        Text("Checkmark")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}
