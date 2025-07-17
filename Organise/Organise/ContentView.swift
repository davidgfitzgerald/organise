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
    @State private var showingPicker: Bool = false
    @State var selectedTab = "Habits"
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            Tab("Habits", systemImage: "list.bullet", value: "Habits") {
                Text("Habits")
                    .font(.title)
                DatePickerView(date: $date, showing: $showingPicker)
                HabitsList(date: $date)
            }
            Tab("Experiments", systemImage: "testtube.2" , value: "Experiments") {
                HabitUIView()
            }
        }

    }
}

#Preview {
    ContentView()
        .withSampleData()
}


