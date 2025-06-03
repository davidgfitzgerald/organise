//
//  ContentView.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @State private var date = Date()

    var body: some View {
        TabView {
            Tab("Habits", systemImage: "list.bullet") {
                HabitsList()
            }
            Tab("Activities", systemImage: "figure.run") {
                ActivityDayList(date: $date)
            }
        }
    }
}

#Preview {
    ContentView()
        .withSampleData()
}
