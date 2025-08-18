//
//  Character.swift
//  Organise
//
//  Created by David Fitzgerald on 13/07/2025.
//

import Foundation
import UIKit

extension String {
    var isValidSFSymbol: Bool {
        return UIImage(systemName: self) != nil
    }
}
