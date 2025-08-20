//
//  StreakIndicator.swift
//  Organise
//
//  Created by David Fitzgerald on 20/08/2025.
//

import SwiftUI


struct StreakIndicator: View {
    let streak: Int
    let maxStreak: Int
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 2) {
                Image(systemName: "flame.fill")
                    .font(.caption2)
                    .foregroundColor(.orange)
                    .opacity(streak >= maxStreak ? 1 : 0)
                HStack(spacing: 0) {
                    Text("\(streak) ")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .contentTransition(.numericText())
                    Text("/ \(maxStreak)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .contentTransition(.numericText())

                }
            }
            
            ProgressBar(
                total: maxStreak,
                current: streak,
                color: color,
            )

        }
    }
}


#Preview {
    StreakIndicator(
        streak: 5,
        maxStreak: 5,
        color: .red,
    )
    
    StreakIndicator(
        streak: 3,
        maxStreak: 5,
        color: .red,
    )
}
