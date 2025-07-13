//
//  ProgressIcon.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//
import SwiftUI

struct ProgressIcon: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background circle that fills the entire frame
                Circle()
                    .fill(Color.pink)
                
                // Arrow pointing up that scales with the container
                Image(systemName: "arrow.up")
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
        ProgressIcon()
            .frame(width: 120, height: 120)
        Text("Progress")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}
