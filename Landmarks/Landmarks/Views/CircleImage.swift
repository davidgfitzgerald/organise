//
//  CircleImage.swift
//  Landmarks
//
//  Created by David Fitzgerald on 23/02/2025.
//

import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
        image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    CircleImage(image: landmarks[0].image)
}
