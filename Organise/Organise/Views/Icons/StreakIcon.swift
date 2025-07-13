//
//  StreakIcon.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//
import SwiftUI

struct StreakIcon: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background that fills the entire frame
                RoundedRectangle(cornerRadius: geometry.size.width * 0.2)
                    .fill(Color.orange)
                
                // Calendar/streak design that scales with container
                VStack(spacing: geometry.size.width * 0.067) {
                    HStack(spacing: geometry.size.width * 0.067) {
                        ForEach(0..<7) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: geometry.size.width * 0.083,
                                       height: geometry.size.width * 0.083)
                        }
                    }
                    HStack(spacing: geometry.size.width * 0.067) {
                        ForEach(0..<5) { _ in
                            Circle()
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.083,
                                       height: geometry.size.width * 0.083)
                        }
                        ForEach(0..<2) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: geometry.size.width * 0.083,
                                       height: geometry.size.width * 0.083)
                        }
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    VStack {
        StreakIcon()
            .frame(width: 120, height: 120)
        Text("Streak")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}
