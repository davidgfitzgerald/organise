//
//  IconPicker.swift
//  Organise
//
//  Created by David Fitzgerald on 04/10/2025.
//

import SwiftUI

struct IconPicker: View {
    @Binding var selection: String
    let color: String
    
    private let availableIcons = [
        "drop.fill", "figure.run", "book.fill", "leaf.fill", "pencil",
        "bed.double.fill", "fish.fill", "takeoutbag.and.cup.and.straw.fill",
        "heart.fill", "brain.head.profile", "dumbbell.fill", "bicycle",
        "car.fill", "airplane", "house.fill", "briefcase.fill"
    ]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
            ForEach(availableIcons, id: \.self) { iconName in
                iconButton(for: iconName)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func iconButton(for iconName: String) -> some View {
        Image(systemName: iconName)
            .font(.title2)
            .foregroundColor(Color(from: color))
            .frame(width: 40, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selection == iconName ? Color.blue.opacity(0.2) : Color.clear)
            )
            .contentShape(Rectangle()) // Ensures entire frame is tappable
            .onTapGesture {
                selection = iconName
            }
    }
}
