//
//  OrganiseApp.swift
//  Organise
//
//  Created by David Fitzgerald on 31/05/2025.
//

import SwiftUI
import SwiftData


@main
struct OrganiseApp: App {
    @Environment(\.modelContext) private var context

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
        .modelContainer(container)
    }
}
