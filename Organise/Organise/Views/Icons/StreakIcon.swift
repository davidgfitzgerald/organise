//
//  StreakIcon.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI

struct StreakIcon: View {
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.orange)
                .frame(width: 120, height: 120)
            
            // Calendar/streak design
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(0..<7) { _ in
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }
                HStack(spacing: 8) {
                    ForEach(0..<5) { _ in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                    }
                    ForEach(0..<2) { _ in
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    StreakIcon()
    Text("Streak")
        .font(.caption)
        .foregroundColor(.secondary)
}
