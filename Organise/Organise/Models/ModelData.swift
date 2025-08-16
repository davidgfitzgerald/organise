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

// Main container for the app
var container: ModelContainer {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        let container = try ModelContainer(for: HabitV1.self, HabitCompletionV1.self, configurations: config)
        AppLogger.info("Created configured container")
        return container
    } catch {
        AppLogger.error("Failed to create configured container: \(error)")
        // Fallback: create container without configuration
        return try! ModelContainer(for: HabitV1.self, HabitCompletionV1.self)
    }
}

// Preview container - always in memory only
var previewContainer: ModelContainer {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: HabitV1.self, HabitCompletionV1.self, configurations: config)
        AppLogger.info("Created configured preview container")
        return container
    } catch {
        AppLogger.error("Failed to create configured preview container: \(error)")
        // Fallback: create empty container for previews
        return try! ModelContainer(for: HabitV1.self, HabitCompletionV1.self)
    }
} 
