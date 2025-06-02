//
//  ProgressIcon.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI

struct ProgressIcon: View {
    var body: some View {
        ZStack {
            // Background
            Circle()
                .fill(Color.pink)
                .frame(width: 120, height: 120)
            
            // Simple arrow pointing up (growth/progress)
            Image(systemName: "arrow.up")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.white)
        }
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ProgressIcon()
    Text("Progress")
        .font(.caption)
        .foregroundColor(.secondary)
}
