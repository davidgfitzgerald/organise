//
//  MigrationPlan.swift
//  Organise
//
//  Created by David Fitzgerald on 10/07/2025.
//

import SwiftData

enum AppMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            VersionedSchemaV1.self,
//            VersionedSchemaV2.self,
        ]
    }
    
    static var stages: [MigrationStage] {
        [
//            migrateV1toV2,
//            migrateV2toV3,
        ]
    }
    
//    static let migrateV1toV2 = MigrationStage.lightweight(
//        fromVersion: VersionedSchemaV1.self,
//        toVersion: VersionedSchemaV2.self
//    )
//
//    static let migrateV2toV3 = MigrationStage.custom(
//        fromVersion: VersionedSchemaV2.self,
//        toVersion: VersionedSchemaV3.self,
//        willMigrate: nil,
//        didMigrate: {context in
//            let habits = try? context.fetch(FetchDescriptor<VersionedSchemaV3.Habit>())
//            
//            habits?.forEach { habit in
//                habit.isArchived = false
//            }
//            
//            try? context.save()
//        }
//    )
    
}
