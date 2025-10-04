//
//  DataContainer.swift
//  Organise
//
//  Created by David Fitzgerald on 31/08/2025.
//

import Foundation
import SwiftData

actor DataContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool, configuration: ModelConfiguration) -> ModelContainer {
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        if shouldCreateDefaults {
            shouldCreateDefaults = false
            createSampleData(container: container)
        }
        return container
    }
}
