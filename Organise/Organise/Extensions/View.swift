//
//  View.swift
//  Organise
//
//  Created by David Fitzgerald on 17/07/2025.
//

import SwiftUI


extension View {
    @ViewBuilder func changeTextColor(_ color: Color) -> some View {
        if UITraitCollection.current.userInterfaceStyle == .light {
            self.colorInvert().colorMultiply(color)
        } else {
            self.colorMultiply(color)
        }
    }
}
