//
//  UI.swift
//  Organise
//
//  Created by David Fitzgerald on 13/07/2025.
//

import Foundation
import UIKit

/**
 * Make tap gestures cancel the current focus.
 *
 * For example, in a TextField, this is
 * used such that a user can easily dismiss the keyboard.
 */
extension UIApplication {
    func addTapGestureRecognizer() {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self as UIGestureRecognizerDelegate
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: @retroactive UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `true` to detect tap during other gestures
    }
}
