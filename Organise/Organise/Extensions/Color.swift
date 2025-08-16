//
//  Color.swift
//  Organise
//
//  Created by David Fitzgerald on 16/08/2025.
//
import SwiftUI
import SwiftData
import Foundation

// MARK: - Simple Color Extension (add this first)
extension Color {
    // Convert string like ".blue" or "blue" to Color
    init(from string: String) {
        let cleanString = string.hasPrefix(".") ? String(string.dropFirst()) : string
        
        switch cleanString.lowercased() {
        case "blue": self = .blue
        case "red": self = .red
        case "green": self = .green
        case "orange": self = .orange
        case "yellow": self = .yellow
        case "pink": self = .pink
        case "purple": self = .purple
        case "mint": self = .mint
        case "teal": self = .teal
        case "cyan": self = .cyan
        case "indigo": self = .indigo
        case "brown": self = .brown
        case "gray": self = .gray
        case "black": self = .black
        case "white": self = .white
        default:
            // Try to parse as hex
            if let hexColor = Color(hex: cleanString) {
                self = hexColor
            } else {
                self = .blue // fallback
            }
        }
    }
    
    // Convert Color back to string
    func toString() -> String {
        // This is a simplified version - you might want to enhance this
        // to detect system colors vs hex colors
        return self.toHex()
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
    
    // Convert to hex string
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return "#0000FF"
        }
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(Float(components[0]) * 255),
                     lroundf(Float(components[1]) * 255),
                     lroundf(Float(components[2]) * 255))
    }
}
