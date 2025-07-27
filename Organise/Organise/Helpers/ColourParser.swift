//
//  ColourParser.swift
//  Organise
//
//  Created by David Fitzgerald on 27/07/2025.
//

import Foundation
import SwiftUICore

struct ColorParser {
    private static let colorMap: [String: Color] = [
        ".red": .red,
        ".green": .green,
        ".blue": .blue,
        ".orange": .orange,
        ".yellow": .yellow,
        ".pink": .pink,
        ".purple": .purple,
        ".primary": .primary,
        ".secondary": .secondary,
        ".black": .black,
        ".white": .white,
        ".gray": .gray,
        ".clear": .clear
    ]
    
    static func color(from string: String) -> Color {
        return colorMap[string.lowercased()] ?? .black
    }
}

// Usage
//let colorString = ".green"
//let color = ColorParser.color(from: colorString) ?? .black // fallback
