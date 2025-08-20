//
//  Color.swift
//  Organise
//
//  Created by David Fitzgerald on 16/08/2025.
//
import SwiftUI
import SwiftData
import Foundation


extension Color {
    private static let palette: [String: Color] = [
        "blue": .blue,
        "red": .red,
        "green": .green,
        "orange": .orange,
        "yellow": .yellow,
        "pink": .pink,
        "purple": .purple,
        "mint": .mint,
        "teal": .teal,
        "cyan": .cyan,
        "indigo": .indigo,
        "brown": .brown,
        "grey": .gray,
        "gray": .gray, // Alternative spelling
        "white": .white
    ]
    
    // Convert string like ".blue" or "blue" to Color
    init(from string: String) {
        let cleanString = string.hasPrefix(".") ? String(string.dropFirst()) : string
        
        // Try to find in palette first
        if let paletteColor = Self.palette[cleanString.lowercased()] {
            self = paletteColor
        } else if let hexColor = Color(hex: cleanString) {
            // Try to parse as hex if not in palette
            self = hexColor
        } else {
            // Fallback to blue
            self = .blue
        }
    }
    
    // Hex color initializer
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: return nil
        }
        
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
    
    // Returns a random color string
    static var random: String {
        let paletteKeys = Array(palette.keys)
        let randomKey = paletteKeys.randomElement() ?? "blue"
        return randomKey
    }
}
