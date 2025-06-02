//
//  CheckmarkIcon.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI

struct CheckmarkIcon: View {
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)
            
            // Checkmark symbol
            Image(systemName: "checkmark")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.white)
        }
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    CheckmarkIcon()
    Text("Checkmark")
        .font(.caption)
        .foregroundColor(.secondary)
}
