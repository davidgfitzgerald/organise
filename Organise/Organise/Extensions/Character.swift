//
//  Character.swift
//  Organise
//
//  Created by David Fitzgerald on 13/07/2025.
//

import Foundation

extension Character {
    var isEmoji: Bool {
        return unicodeScalars.allSatisfy { scalar  in
            scalar.properties.isEmoji ||
            scalar.properties.isEmojiModifierBase ||
            scalar.properties.isEmojiModifier ||
            scalar.properties.isVariationSelector
        }
    }
}
