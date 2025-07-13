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
    @State private var selectedTab = "Habits"
    
    var body: some View {
        Text("Habits")
            .font(.title)
        DatePickerView(date: $date, showing: $showingPicker)
        HabitsList(date: $date)
    }
}

#Preview {
    ContentView()
        .withSampleData()
}

//        TabView(selection: $selectedTab) {
//            Tab("Habits", systemImage: "list.bullet", value: "Habits") {

//            }
//            Tab("Activities", systemImage: "figure.run" , value: "Activities") {
//                Text("Activities")
//                    .font(.title)
//                DatePickerView(date: $date, showing: $showingPicker)
//                ActivityDayList(date: $date)
//            }
//        }
