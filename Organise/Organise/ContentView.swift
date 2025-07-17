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
        HabitUIView()
    }
}

#Preview {
    ContentView()
        .withSampleData()
}


