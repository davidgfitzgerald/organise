//
//  TargetIcon.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI

// Alternative designs
struct TargetIcon: View {
    var body: some View {
        ZStack {
            // Rounded rectangle background
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.green)
                .frame(width: 120, height: 120)
            
            // Target/bullseye design
            Circle()
                .stroke(Color.white, lineWidth: 8)
                .frame(width: 60, height: 60)
            
            Circle()
                .fill(Color.white)
                .frame(width: 20, height: 20)
        }
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    TargetIcon()
    Text("Target")
        .font(.caption)
        .foregroundColor(.secondary)
}
