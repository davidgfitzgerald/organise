//
//  ContentView.swift
//  Landmarks
//
//  Created by David Fitzgerald on 22/02/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
                .frame(height: 300)
            CircleImage()
                .offset(y: -130)
                .padding(.bottom, -130)
            VStack(alignment: .leading) {
                Text("Turtle Rock")
                    .font(.title)
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text("Joshua Tree National Park")
                    Spacer()
                    Text("California")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Divider()
                
                Text("About")
                    .font(.title2)
                Text("Turtle Rock is a striking natural formation, often resembling the rounded shell of a resting turtle, nestled within rugged landscapes of weathered stone and windswept terrain. Its surface is marked by centuries of erosion, with deep grooves and cracks adding character to its ancient form. Moss and lichen cling to its rough exterior, giving it a muted greenish hue that shifts in the changing light. Whether perched atop a coastal cliff, hidden within a dense forest, or standing alone in a desert expanse, Turtle Rock exudes a quiet, timeless presence, as if it has been watching over the land for generations.")
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
        
            }
            .padding()
        
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
