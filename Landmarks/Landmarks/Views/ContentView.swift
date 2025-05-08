//
//  ContentView.swift
//  Landmarks
//
//  Created by David Fitzgerald on 03/05/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
