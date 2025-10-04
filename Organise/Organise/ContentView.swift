//
//  ContentView.swift
//  Organise
//
//  Created by David Fitzgerald on 04/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
        .modelContainer(DataContainer.create(shouldCreateDefaults: true))
}
