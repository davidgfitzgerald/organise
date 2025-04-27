//
//  Item.swift
//  ToDo
//
//  Created by David Fitzgerald on 27/04/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
