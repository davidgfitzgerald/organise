//
//  ProgressBar.swift
//  Organise
//
//  Created by David Fitzgerald on 20/08/2025.
//

import SwiftUI

struct ProgressBar: View {
    let total: Int
    let current: Int
    let color: Color
    var height: Double = 3
    var width: Double = 40.0
    var cornerRadius: Double = 4

    var body: some View {
        let progress = total > 0 ? Double(current) / Double(total) : 0
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(color.opacity(0.3))
            .frame(height: height)
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .frame(width: max(4, width * progress))
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
            .frame(width: width)
    }
}

#Preview {
    //
    /**
     * TODO - make rounding consistent.
     * If current is low then the left-hand radius does not
     * match the RHS and it looks strange.
     *
     * The approach should probably be to create the
     * progress at the same width as the bar but clip it
     * at the progress percentage to display how it should.
     */
    ProgressBar(
        total: 100,
        current: 5,
        color: .red,
        height: 10,
        width: 50.0,
        cornerRadius: 4
    )
}
