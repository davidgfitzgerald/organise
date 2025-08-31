//
//  SampleData.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//
import SwiftData


struct SampleData: Codable {
    // Model the .json data
}

@MainActor
func createSampleData(container: ModelContainer) {
    AppLogger.info("Loading data.json")
    let sampleData: SampleData = load("data.json")
    AppLogger.success("Loaded data.json")

    // TODO - create items in DB
}
