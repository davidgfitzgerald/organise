//
//  Color.swift
//  Organise
//
//  Created by David Fitzgerald on 16/08/2025.
//
import SwiftUI
import SwiftData
import Foundation

// MARK: - Color Extension
extension Color {
    
    // MARK: - Color Palette
    private static let colorPalette: [String: Color] = [
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
        "black": .black,
        "white": .white
    ]
    
    // MARK: - Initializers
    
    // Convert string like ".blue" or "blue" to Color
    init(from string: String) {
        let cleanString = string.hasPrefix(".") ? String(string.dropFirst()) : string
        
        // Try to find in palette first
        if let paletteColor = Self.colorPalette[cleanString.lowercased()] {
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
    
    // MARK: - Random Color Methods
    
    // Returns a random color string from the predefined palette (e.g., ".blue")
    static var random: String {
        let paletteKeys = Array(colorPalette.keys)
        let randomKey = paletteKeys.randomElement() ?? "blue"
        return randomKey
    }
    
    // Returns a random Color object from the predefined palette
    static func randomFromPalette() -> Color {
        let paletteColors = Array(colorPalette.values)
        return paletteColors.randomElement() ?? .blue
    }
    
    // MARK: - Utility Methods
    
    // Convert Color back to string
    func toString() -> String {
        // This is a simplified version - you might want to enhance this
        // to detect system colors vs hex colors
        return self.toHex()
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
    
    // MARK: - Palette Access
    
    // Get all available palette colors
    static var paletteColors: [Color] {
        return Array(colorPalette.values)
    }
    
    // Get all palette color names
    static var paletteColorNames: [String] {
        return Array(colorPalette.keys)
    }
    
    // Check if a color name exists in the palette
    static func isValidPaletteColor(_ name: String) -> Bool {
        let cleanName = name.hasPrefix(".") ? String(name.dropFirst()) : name
        return colorPalette.keys.contains(cleanName.lowercased())
    }
}
