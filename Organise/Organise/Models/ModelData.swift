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

//let modelConfiguration = ModelConfiguration(schema: schema)
//, configurations: [modelConfiguration]

//var container: ModelContainer {
//    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//    return try! ModelContainer(for:
//        schema, configurations: [modelConfiguration]
//    )
//}

@MainActor
let container: ModelContainer = {    
    let config: ModelConfiguration
    
    #if DEBUG
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
        // 👇 Use in-memory store in previews
        config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    } else {
        // 👇 Use persistent store in debug/dev builds
        config = ModelConfiguration(schema: schema)
    }
    #else
    // 👇 Always persistent in release builds
    config = ModelConfiguration(schema: schema)
    #endif
    
    return try! ModelContainer(for: schema, configurations: [config])
}()
