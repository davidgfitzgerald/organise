//
//  ModelData.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//
import Foundation
import SwiftData

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

// Single container that automatically detects preview vs app mode
var container: ModelContainer {
    do {
        // Check if we're in preview mode by looking at the environment
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        
        let config = ModelConfiguration(isStoredInMemoryOnly: isPreview)
        let container = try ModelContainer(for: Habit.self, HabitCompletionV1.self, configurations: config)
        
        if isPreview {
            AppLogger.info("Created preview container (in-memory)")
        } else {
            AppLogger.info("Created app container (persistent)")
        }

        return container
    } catch {
        AppLogger.error("Failed to create configured container: \(error)")
        fatalError("Failed to create configured container: \(error)")
    }
}
