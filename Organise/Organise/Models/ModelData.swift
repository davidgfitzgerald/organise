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

let modelConfiguration = ModelConfiguration(schema: schema)
var container: ModelContainer {
    do {
        let modelConfiguration = ModelConfiguration(schema: schema)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Failed to create ModelContainer: \(error)")
    }
}
