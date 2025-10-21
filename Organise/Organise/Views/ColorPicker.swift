//
//  ColorPicker.swift
//  Organise
//
//  Created by David Fitzgerald on 04/10/2025.
//

import SwiftUI

struct ColorPicker: View {
    @Binding var selection: String
    
    private let availableColors = [
        ".blue", ".green", ".purple", ".mint", ".orange", ".indigo",
        ".red", ".pink", ".yellow", ".gray", ".brown", ".cyan"
    ]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
            ForEach(availableColors, id: \.self) { colorName in
                colorButton(for: colorName)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func colorButton(for colorName: String) -> some View {
        Circle()
            .fill(Color(from: colorName))
            .frame(width: 30, height: 30)
            .overlay(
                Circle()
                    .stroke(selection == colorName ? Color.primary : Color.clear, lineWidth: 2)
            )
            .contentShape(Circle()) // Ensures entire circle is tappable
            .onTapGesture {
                selection = colorName
            }
    }
}
