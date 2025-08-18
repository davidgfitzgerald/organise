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
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true

    var body: some Scene {
        

        WindowGroup {
            ContentView()
//                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .onAppear {
                    AppLogger.debug("isFirstLaunch: \(isFirstLaunch)")
                }
        }
        .modelContainer(DataContainer.create(shouldCreateDefaults: &isFirstLaunch))
    }
}

