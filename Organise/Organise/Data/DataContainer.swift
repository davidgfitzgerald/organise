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
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        if shouldCreateDefaults {
            createSampleData(container: container)
        }
        return container
    }
}
