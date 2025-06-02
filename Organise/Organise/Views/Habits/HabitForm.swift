//
//  ContentView.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//

import SwiftUI
import SwiftData


struct HabitForm: View {
    @Environment(\.modelContext) private var context
    @State private var name = ""
    @State private var showError = false
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("", text: $name, prompt: Text("Enter habit name").foregroundColor(showError ? .red : .gray))
            .onSubmit {
                if name.isEmpty {
                    withAnimation(.easeInOut) {
                        showError = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeInOut) {
                            showError = false
                        }
                    }
                } else {
                    let habit = Habit(name: name)
                    context.insert(habit)
                    name = ""
                }
            }
        }
    }
}

#Preview {
    HabitForm()
        .withSampleData()
}
