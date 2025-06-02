//
//  TargetIcon.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//
import SwiftUI

struct TargetIcon: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background that fills the entire frame
                RoundedRectangle(cornerRadius: geometry.size.width * 0.208)
                    .fill(Color.green)
                
                // Target/bullseye design that scales with container
                Circle()
                    .stroke(Color.white, lineWidth: geometry.size.width * 0.067)
                    .frame(width: geometry.size.width * 0.5,
                           height: geometry.size.width * 0.5)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * 0.167,
                           height: geometry.size.width * 0.167)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    VStack {
        TargetIcon()
            .frame(width: 120, height: 120)
        Text("Target")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}
