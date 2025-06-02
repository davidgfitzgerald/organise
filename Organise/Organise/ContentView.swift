//
//  ContentView.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Habits", systemImage: "list.bullet") {
                HabitsList()
            }
            Tab("Activities", systemImage: "figure.run") {
                ActivityList()
            }
        }
    }
}

#Preview {
    ContentView()
        .withSampleData()
}
