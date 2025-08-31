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

    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(DataContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
    }
}

