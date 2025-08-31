//
//  VersionedSchemaV1.swift
//  Organise
//
//  Created by David Fitzgerald on 18/08/2025.
//

import Foundation
import SwiftData


enum VersionedSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 0)
    
    static var models: [any PersistentModel.Type] {
        [
//            Habit.self,
//            HabitCompletion.self
        ]
    }
}

extension VersionedSchemaV1 {

//    @Model
//    final class SomeModel() {}

}
