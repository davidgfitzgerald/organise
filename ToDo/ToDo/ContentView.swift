//
//  ContentView.swift
//  ToDo
//
//  Created by David Fitzgerald on 27/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var greeting = "Hello, World!"
    @State private var isWaving = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(greeting)
                .font(.largeTitle)
                .bold()
            
            Image(systemName: "hand.wave")
                .font(.system(size: 50))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(isWaving ? 20 : -20))
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isWaving)
            
            Button("Tap me!") {
                greeting = ["Hello, Friend!", "Hi there!", "Welcome!", "Greetings!"].randomElement() ?? "Hello, World!"
                isWaving = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .onAppear {
            isWaving = true
        }
    }
}

#Preview {
    ContentView()
}
