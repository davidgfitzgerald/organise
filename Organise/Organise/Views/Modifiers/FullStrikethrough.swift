//
//  FullStrikethrough.swift
//  Organise
//
//  Created by David Fitzgerald on 03/06/2025.
//

import SwiftUI

struct FullStrikethrough: ViewModifier {
    let isActive: Bool
    let color: Color
    let opacity: Double
    
    init(isActive: Bool, color: Color = .secondary, opacity: Double = 0.3) {
        self.isActive = isActive
        self.color = color
        self.opacity = opacity
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(isActive ? color : .clear)
                    .opacity(isActive ? opacity : 0)
            )
    }
}

extension View {
    func fullStrikethrough(_ isActive: Bool, color: Color = .secondary, opacity: Double = 0.3) -> some View {
        self.modifier(FullStrikethrough(isActive: isActive, color: color, opacity: opacity))
    }
}
