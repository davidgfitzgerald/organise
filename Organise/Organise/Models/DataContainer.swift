//
//  DataContainer.swift
//  Organise
//
//  Created by David Fitzgerald on 18/08/2025.
//

import Foundation
import SwiftData


actor DataContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let config: ModelConfiguration

        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            // 👇 Use in-memory store in previews
            AppLogger.debug("Using in-memory store for previews")
            config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        } else {
            // 👇 Use persistent store in debug/dev builds
            AppLogger.debug("Using persistent store")
            config = ModelConfiguration(schema: schema)
        }
        #else
        // 👇 Always persistent in release builds
        config = ModelConfiguration(schema: schema)
        #endif

        AppLogger.info("Creating model container")
        let container = try! ModelContainer(
            for: schema,
            migrationPlan: AppMigrationPlan.self,
            configurations: [config],
        )
        AppLogger.success("Created model container")
        
        if shouldCreateDefaults {
            AppLogger.debug("Creating sample data")
            try! createSampleData(context: container.mainContext)
            shouldCreateDefaults = false
        }
        
        return container
    }
}
